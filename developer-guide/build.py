#!/usr/bin/env python3
"""
build.py — Static site generator for XjTTY-Toolkit API Documentation.

Usage:
    python3 build.py                  # build all languages from cached sources
    python3 build.py --lang en        # build only English
    python3 build.py --lang th        # build only Thai
    python3 build.py --lang jp        # build only Japanese

Requires: pip install markdown pyyaml jinja2 pygments
"""

import os
import re
import sys
import shutil
from pathlib import Path

import markdown
import yaml
from jinja2 import Environment, FileSystemLoader
from markdown.extensions.codehilite import CodeHiliteExtension
from markdown.extensions.fenced_code import FencedCodeExtension
from markdown.extensions.tables import TableExtension
from markdown.extensions.toc import TocExtension
from markdown.extensions.admonition import AdmonitionExtension

# ── Paths ────────────────────────────────────────────────────────────────────

ROOT     = Path(__file__).parent
SRC      = ROOT / "src"
DIST     = ROOT / "dist"

def _rel(p):
    try:
        return p.relative_to(ROOT)
    except ValueError:
        return p

LAYOUT   = SRC / "_layout"
ASSETS   = SRC / "_assets"
PAGES_EN = SRC / "pages"
NAV_FILE = ROOT / "nav.yaml"

LANGUAGES = {
    "en": {"label": "English",  "pages_dir": SRC / "pages",
           "flag": "EN"},
    "th": {"label": "ภาษาไทย", "pages_dir": SRC / "pages_th",
           "flag": "TH"},
    "jp": {"label": "日本語",   "pages_dir": SRC / "pages_jp",
           "flag": "JP"},
}

# ── Markdown setup ───────────────────────────────────────────────────────────

MD_EXTENSIONS = [
    FencedCodeExtension(),
    CodeHiliteExtension(guess_lang=False, css_class="highlight", noclasses=False),
    TocExtension(permalink=True, toc_depth="2-3"),
    TableExtension(),
    AdmonitionExtension(),
    "markdown.extensions.attr_list",
    "markdown.extensions.def_list",
    "markdown.extensions.abbr",
    "markdown.extensions.smarty",
]

def make_md():
    return markdown.Markdown(extensions=MD_EXTENSIONS)

# ── YAML frontmatter ─────────────────────────────────────────────────────────

FRONTMATTER_RE = re.compile(r"^---\s*\n(.*?)\n---\s*\n", re.DOTALL)

def parse_frontmatter(text):
    m = FRONTMATTER_RE.match(text)
    if m:
        meta = yaml.safe_load(m.group(1)) or {}
        body = text[m.end():]
    else:
        meta = {}
        body = text
    return meta, body

# ── TOC extractor ─────────────────────────────────────────────────────────

HEADING_RE = re.compile(r"^(#{2,3})\s+(.+)$", re.MULTILINE)

def extract_toc(md_body):
    items = []
    for m in HEADING_RE.finditer(md_body):
        level  = len(m.group(1))
        text   = m.group(2).strip()
        anchor = re.sub(r"[^\w\s-]", "", text.lower())
        anchor = re.sub(r"\s+", "-", anchor).strip("-")
        items.append({"level": level, "text": text, "anchor": anchor})
    return items

# ── Navigation ────────────────────────────────────────────────────────────

def load_nav():
    with open(NAV_FILE) as f:
        return yaml.safe_load(f)

def build_flat_pages(nav):
    pages = []
    for section in nav["sections"]:
        for item in section["pages"]:
            pages.append(item)
    return pages

def find_neighbours(flat_pages, current_slug):
    for i, page in enumerate(flat_pages):
        if page["slug"] == current_slug:
            prev_page = flat_pages[i - 1] if i > 0 else None
            next_page = flat_pages[i + 1] if i < len(flat_pages) - 1 else None
            return prev_page, next_page
    return None, None

def slug_to_output_path(slug, lang_dist):
    if slug == "index":
        return lang_dist / "index.html"
    if slug.endswith("/index"):
        return lang_dist / slug.replace("/index", "") / "index.html"
    return lang_dist / (slug + ".html")

def relative_root(output_path, lang_dist):
    depth = len(output_path.relative_to(lang_dist).parts) - 1
    return "../" * depth if depth > 0 else "./"

# ── Page builder ──────────────────────────────────────────────────────────

def build_page(item, nav, flat_pages, env, lang_code, lang_dist):
    lang_info = LANGUAGES[lang_code]
    pages_dir = lang_info["pages_dir"]
    src_rel   = item["src"].replace("pages/", "")
    src_path  = pages_dir / src_rel

    if not src_path.exists():
        src_path = PAGES_EN / src_rel      # fallback to EN
    if not src_path.exists():
        print(f"  [WARN] Missing: {src_path}")
        return

    raw          = src_path.read_text(encoding="utf-8")
    meta, body   = parse_frontmatter(raw)

    md           = make_md()
    content_html = md.convert(body)
    toc_items    = extract_toc(body)

    prev_page, next_page = find_neighbours(flat_pages, item["slug"])
    output_path  = slug_to_output_path(item["slug"], lang_dist)
    root_prefix  = relative_root(output_path, lang_dist)

    lang_links = []
    for lc, linfo in LANGUAGES.items():
        lang_links.append({
            "code":   lc,
            "label":  linfo["label"],
            "flag":   linfo["flag"],
            "href":   f"/{lc}/index.html",
            "active": lc == lang_code,
        })

    template = env.get_template("page.html")
    html = template.render(
        nav          = nav,
        current_slug = item["slug"],
        page_title   = meta.get("title", item["title"]),
        description  = meta.get("description", ""),
        content      = content_html,
        toc          = toc_items,
        prev_page    = prev_page,
        next_page    = next_page,
        root         = root_prefix,
        site_title   = nav["title"],
        site_version = nav["version"],
        lang_code    = lang_code,
        lang_links   = lang_links,
    )

    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(html, encoding="utf-8")
    print(f"  ✓  {_rel(output_path)}")

# ── Main ──────────────────────────────────────────────────────────────────

def build(langs=None):
    if langs is None:
        langs = list(LANGUAGES.keys())

    print(f"\n🔨  Building XjTTY-Toolkit API Docs → {_rel(DIST)}/\n")

    DIST.mkdir(exist_ok=True)

    # Root redirect
    root_redir = DIST / "index.html"
    root_redir.write_text(
        '<!DOCTYPE html><html><head>'
        '<meta http-equiv="refresh" content="0;url=en/index.html">'
        '<title>XjTTY-Toolkit API</title></head>'
        '<body><a href="en/index.html">XjTTY-Toolkit API Documentation</a></body></html>',
        encoding="utf-8",
    )

    # Copy assets
    assets_out = DIST / "assets"
    assets_out.mkdir(exist_ok=True)
    if ASSETS.exists():
        for f in ASSETS.iterdir():
            if f.is_file():
                shutil.copy2(f, assets_out / f.name)
    print("  ✓  assets/ copied")

    nav        = load_nav()
    flat_pages = build_flat_pages(nav)
    env        = Environment(loader=FileSystemLoader(str(LAYOUT)), autoescape=False)

    total = 0
    for lang_code in langs:
        lang_info = LANGUAGES[lang_code]
        lang_dist = DIST / lang_code
        lang_dist.mkdir(exist_ok=True)

        print(f"\n  [{lang_code.upper()}] Building {lang_info['label']} → dist/{lang_code}/")
        for item in flat_pages:
            build_page(item, nav, flat_pages, env, lang_code, lang_dist)
            total += 1

    print(f"\n✅  Done — {total} pages built across {len(langs)} language(s).\n")


if __name__ == "__main__":
    args = sys.argv[1:]
    lang_filter = None
    if "--lang" in args:
        idx = args.index("--lang")
        if idx + 1 < len(args):
            lang_filter = [args[idx + 1]]
    build(langs=lang_filter)
