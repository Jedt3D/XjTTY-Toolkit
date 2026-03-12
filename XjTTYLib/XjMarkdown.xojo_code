#tag Module
Protected Module XjMarkdown
	#tag Method, Flags = &h0
		Sub Render(text As String)
		  Var lines() As String = text.Split(Chr(10))
		  Var inCodeBlock As Boolean = False

		  For i As Integer = 0 To lines.Count - 1
		    Var line As String = lines(i)

		    // Code block toggle
		    If line.Trim.Left(3) = "```" Then
		      inCodeBlock = Not inCodeBlock
		      If inCodeBlock Then
		        Var s As New XjStyle
		        Print(s.SetFG(90).Apply("  " + Chr(&hE2) + Chr(&h94) + Chr(&h80) + Chr(&hE2) + Chr(&h94) + Chr(&h80) + Chr(&hE2) + Chr(&h94) + Chr(&h80)))
		      Else
		        Var s As New XjStyle
		        Print(s.SetFG(90).Apply("  " + Chr(&hE2) + Chr(&h94) + Chr(&h80) + Chr(&hE2) + Chr(&h94) + Chr(&h80) + Chr(&hE2) + Chr(&h94) + Chr(&h80)))
		      End If
		      Continue
		    End If

		    If inCodeBlock Then
		      Var s As New XjStyle
		      Print(s.SetFG(XjANSI.FG_YELLOW).Apply("    " + line))
		      Continue
		    End If

		    // Horizontal rule
		    If line.Trim = "---" Or line.Trim = "===" Or line.Trim = "***" Then
		      Var s As New XjStyle
		      Var rule As String = ""
		      Var w As Integer = 40
		      For c As Integer = 1 To w
		        rule = rule + Chr(&hE2) + Chr(&h94) + Chr(&h80)
		      Next
		      Print(s.SetFG(90).Apply(rule))
		      Continue
		    End If

		    // Headers
		    If line.Left(4) = "### " Then
		      Var s As New XjStyle
		      Print(s.SetFG(XjANSI.FG_CYAN).Apply("   " + line.Middle(4)))
		      Continue
		    ElseIf line.Left(3) = "## " Then
		      Var s As New XjStyle
		      Var s2 As XjStyle = s.SetFG(XjANSI.FG_CYAN).SetBold
		      Print(s2.Apply("  " + line.Middle(3)))
		      Continue
		    ElseIf line.Left(2) = "# " Then
		      Var s As New XjStyle
		      Var s2 As XjStyle = s.SetFG(XjANSI.FG_CYAN).SetBold
		      Print(s2.Apply(line.Middle(2).Uppercase))
		      Continue
		    End If

		    // Unordered list
		    Var trimmed As String = line.TrimLeft
		    If trimmed.Left(2) = "- " Or trimmed.Left(2) = "* " Then
		      Var indent As Integer = line.Length - trimmed.Length
		      Var prefix As String = ""
		      For c As Integer = 1 To indent
		        prefix = prefix + " "
		      Next
		      Var bullet As String = Chr(&hE2) + Chr(&h80) + Chr(&hA2)
		      Var content As String = trimmed.Middle(2)
		      content = FormatInline(content)
		      Print(prefix + "  " + bullet + " " + content)
		      Continue
		    End If

		    // Ordered list
		    If trimmed.Length >= 3 Then
		      Var firstChar As String = trimmed.Left(1)
		      If firstChar >= "1" And firstChar <= "9" Then
		        Var dotPos As Integer = trimmed.IndexOf(". ")
		        If dotPos >= 1 And dotPos <= 3 Then
		          Var indent As Integer = line.Length - trimmed.Length
		          Var prefix As String = ""
		          For c As Integer = 1 To indent
		            prefix = prefix + " "
		          Next
		          Var num As String = trimmed.Left(dotPos)
		          Var content As String = trimmed.Middle(dotPos + 2)
		          content = FormatInline(content)
		          Print(prefix + "  " + num + ". " + content)
		          Continue
		        End If
		      End If
		    End If

		    // Regular paragraph
		    If line.Trim = "" Then
		      Print("")
		    Else
		      Print(FormatInline(line))
		    End If
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function FormatInline(line As String) As String
		  // Bold: **text**
		  While line.IndexOf("**") >= 0
		    Var startPos As Integer = line.IndexOf("**")
		    Var endPos As Integer = line.IndexOf(startPos + 2, "**")
		    If endPos < 0 Then Exit

		    Var before As String = line.Left(startPos)
		    Var content As String = line.Middle(startPos + 2, endPos - startPos - 2)
		    Var after As String = line.Middle(endPos + 2)

		    Var s As New XjStyle
		    Var sBold As XjStyle = s.SetBold
		    line = before + sBold.Apply(content) + after
		  Wend

		  // Italic: *text* (single asterisk, not inside **)
		  While line.IndexOf("*") >= 0
		    Var startPos As Integer = line.IndexOf("*")
		    Var endPos As Integer = line.IndexOf(startPos + 1, "*")
		    If endPos < 0 Then Exit

		    Var before As String = line.Left(startPos)
		    Var content As String = line.Middle(startPos + 1, endPos - startPos - 1)
		    Var after As String = line.Middle(endPos + 1)

		    Var s As New XjStyle
		    Var sItal As XjStyle = s.SetItalic
		    line = before + sItal.Apply(content) + after
		  Wend

		  // Inline code: `text`
		  While line.IndexOf("`") >= 0
		    Var startPos As Integer = line.IndexOf("`")
		    Var endPos As Integer = line.IndexOf(startPos + 1, "`")
		    If endPos < 0 Then Exit

		    Var before As String = line.Left(startPos)
		    Var content As String = line.Middle(startPos + 1, endPos - startPos - 1)
		    Var after As String = line.Middle(endPos + 1)

		    Var s As New XjStyle
		    Var sInv As XjStyle = s.SetInverse
		    line = before + sInv.Apply(" " + content + " ") + after
		  Wend

		  Return line
		End Function
	#tag EndMethod


	#tag Note, Name = "About"
		XjMarkdown — Terminal Markdown Renderer

		Part of XjTTY-Toolkit Phase 5 (Utility Modules).
		Render basic markdown with ANSI styling.

		Supported:
		  # Header 1, ## Header 2, ### Header 3
		  **bold**, *italic*, `code`
		  - Unordered lists
		  1. Ordered lists
		  ``` Code blocks ```
		  --- Horizontal rules

		Usage:
		  XjMarkdown.Render(markdownText)
	#tag EndNote

End Module
#tag EndModule
