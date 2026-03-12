#tag Class
Protected Class App
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  // ============================================
		  // Phase 5 Demo: Utility Modules
		  // ============================================
		  // Shows all 8 utility modules (non-interactive)

		  #Pragma Unused args

		  Print("")
		  Print("=== XjTTY-Toolkit Phase 5: Utility Modules Demo ===")
		  Print("")

		  // --- XjWhich ---
		  Print("--- XjWhich: Find Executables ---")
		  Var gitPath As String = XjWhich.Which("git")
		  Print("  git:  " + If(gitPath <> "", gitPath, "(not found)"))
		  Var bashPath As String = XjWhich.Which("bash")
		  Print("  bash: " + If(bashPath <> "", bashPath, "(not found)"))
		  Var nodePath As String = XjWhich.Which("node")
		  Print("  node: " + If(nodePath <> "", nodePath, "(not found)"))
		  Print("  xojo exists? " + If(XjWhich.Exists("xojo"), "yes", "no"))
		  Print("")

		  // --- XjLogger ---
		  Print("--- XjLogger: Structured Logging ---")
		  Var log As New XjLogger("Demo")
		  Call log.SetLevel(XjLogger.LEVEL_DEBUG)
		  log.Debug("Initializing subsystems...")
		  log.Info("Server started", "port=8080")
		  log.Warn("Memory usage high", "used=85%")
		  log.Error_("Connection refused", "host=db.local")
		  Print("")
		  Print("  JSON format:")
		  Call log.SetJSON(True)
		  log.Info("Request handled", "method=GET path=/api")
		  Call log.SetJSON(False)
		  Print("")

		  // --- XjOption ---
		  Print("--- XjOption: CLI Argument Parser ---")
		  Var opt As New XjOption("myapp", "A sample CLI application")
		  Call opt.AddOption("output", "o", "output", "Output file path", "out.txt")
		  Call opt.AddOption("port", "p", "port", "Server port", "3000")
		  Call opt.AddFlag("verbose", "v", "verbose", "Enable verbose output")
		  Call opt.AddFlag("dry-run", "n", "dry-run", "Show what would be done")
		  Call opt.AddArgument("input", "Input file to process", True)
		  Print(opt.Help)
		  Print("")

		  // Parse sample args
		  Var sampleArgs() As String
		  sampleArgs.Add("--verbose")
		  sampleArgs.Add("-o")
		  sampleArgs.Add("result.txt")
		  sampleArgs.Add("data.csv")
		  Call opt.Parse(sampleArgs)
		  Print("  Parsed: --verbose -o result.txt data.csv")
		  Print("  verbose = " + If(opt.GetFlag("verbose"), "true", "false"))
		  Print("  output  = " + opt.GetString("output"))
		  Print("  input   = " + opt.GetString("input"))
		  Print("  port    = " + opt.GetString("port") + " (default)")
		  Print("")

		  // --- XjConfig ---
		  Print("--- XjConfig: Configuration ---")
		  Var cfg As New XjConfig
		  cfg.Set("app.name", "XjTTY-Toolkit")
		  cfg.Set("app.version", "0.5.0")
		  cfg.Set("server.port", "8080")
		  cfg.Set("server.host", "localhost")
		  cfg.Set("debug", "false")
		  Print("  app.name    = " + cfg.Get("app.name"))
		  Print("  app.version = " + cfg.Get("app.version"))
		  Print("  server.port = " + cfg.Get("server.port"))
		  Print("  missing     = " + cfg.Get("missing", "(default)"))
		  Print("  total keys  = " + Str(cfg.Count))
		  Print("")

		  // --- XjFont ---
		  Print("--- XjFont: ASCII Art Text ---")
		  Var banner() As String = XjFont.Render("XOJO")
		  For i As Integer = 0 To banner.Count - 1
		    Print("  " + banner(i))
		  Next
		  Print("")

		  // With color
		  Var colorStyle As New XjStyle
		  Call colorStyle.SetFG(XjANSI.FG_CYAN)
		  Var colorBanner() As String = XjFont.Render("HI!", colorStyle)
		  For i As Integer = 0 To colorBanner.Count - 1
		    Print("  " + colorBanner(i))
		  Next
		  Print("")

		  // --- XjPie ---
		  Print("--- XjPie: Terminal Charts ---")
		  Var pie As New XjPie
		  Call pie.AddSlice("Xojo", 60)
		  Call pie.AddSlice("Python", 25)
		  Call pie.AddSlice("Ruby", 15)
		  pie.Draw
		  Print("")

		  // --- XjMarkdown ---
		  Print("--- XjMarkdown: Terminal Markdown ---")
		  Var md As String = "# Welcome" + Chr(10)
		  md = md + "" + Chr(10)
		  md = md + "This is **bold** and *italic* text." + Chr(10)
		  md = md + "" + Chr(10)
		  md = md + "## Features" + Chr(10)
		  md = md + "- First item" + Chr(10)
		  md = md + "- Second with `inline code`" + Chr(10)
		  md = md + "- Third item" + Chr(10)
		  md = md + "" + Chr(10)
		  md = md + "---" + Chr(10)
		  md = md + "" + Chr(10)
		  md = md + "```" + Chr(10)
		  md = md + "Var x As Integer = 42" + Chr(10)
		  md = md + "Print(Str(x))" + Chr(10)
		  md = md + "```" + Chr(10)
		  XjMarkdown.Render(md)
		  Print("")

		  // --- XjPager ---
		  Print("--- XjPager: Content Pager ---")
		  Print("  (Interactive pager available via XjPager.Page)")
		  Print("  Supports: SPACE=next page, q=quit, Down=scroll")
		  Print("")

		  Print("=== Demo Complete ===")
		  XjPrompt.Ok("All 8 utility modules demonstrated!")
		  Print("")

		  Return 0
		End Function
	#tag EndEvent


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
