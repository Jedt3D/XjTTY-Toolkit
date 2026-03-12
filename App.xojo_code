#tag Class
Protected Class App
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  Print("=== XjTTY-Toolkit Foundation Demo ===")
		  Print("")

		  // --- Platform Detection ---
		  Print("--- Platform ---")
		  Print("OS: " + XjPlatform.OSName)
		  Print("Architecture: " + XjPlatform.Architecture)
		  Print("Info: " + XjPlatform.PlatformInfo)
		  Print("")

		  // --- Terminal Info ---
		  Print("--- Terminal ---")
		  Print("Size: " + Str(XjTerminal.Width) + "x" + Str(XjTerminal.Height))
		  Print("Color support: " + If(XjTerminal.SupportsColor, "Yes", "No"))
		  Print("Color depth: " + Str(XjTerminal.ColorDepth) + "-bit")
		  Print("")

		  // --- Color Demo ---
		  Print("--- Colors ---")
		  Print(XjColor.Red("Red") + " " + XjColor.Green("Green") + " " + XjColor.Blue("Blue") + " " + XjColor.Yellow("Yellow") + " " + XjColor.Magenta("Magenta") + " " + XjColor.Cyan("Cyan"))
		  Print(XjColor.BrightRed("Bright Red") + " " + XjColor.BrightGreen("Bright Green") + " " + XjColor.BrightBlue("Bright Blue"))
		  Print(XjColor.BoldText("Bold") + " " + XjColor.ItalicText("Italic") + " " + XjColor.UnderlineText("Underline") + " " + XjColor.DimText("Dim") + " " + XjColor.InverseText("Inverse"))
		  Print(XjColor.OnRed(" On Red ") + " " + XjColor.OnGreen(" On Green ") + " " + XjColor.OnBlue(" On Blue "))
		  Print(XjColor.Success("Success!") + " " + XjColor.Warning("Warning!") + " " + XjColor.Error_("Error!") + " " + XjColor.Info("Info"))
		  Print("")

		  // --- True Color Gradient ---
		  If XjTerminal.ColorDepth >= 24 Then
		    Print("--- True Color Gradient ---")
		    Print(XjColor.Gradient("XjTTY-Toolkit: Beautiful Terminal UIs in Xojo!", 255, 0, 100, 0, 200, 255))
		    Print("")
		  End If

		  // --- Style Builder ---
		  Print("--- Style Builder ---")
		  Var base1 As New XjStyle
		  Var s1 As XjStyle = base1.SetFG(XjANSI.FG_CYAN).SetBold.SetUnderline
		  Print(s1.Apply("Cyan + Bold + Underline"))

		  Var base2 As New XjStyle
		  Var s2 As XjStyle = base2.SetFGRGB(255, 165, 0).SetBG(XjANSI.BG_BLACK)
		  Print(s2.Apply("Orange on Black (RGB)"))
		  Print("")

		  // --- Canvas Demo ---
		  Print("--- Canvas Demo ---")
		  Var canvas As New XjCanvas(40, 8)

		  // Draw a box
		  Var baseBorder As New XjStyle
		  Var borderStyle As XjStyle = baseBorder.SetFG(XjANSI.FG_CYAN)
		  canvas.DrawBox(0, 0, 40, 8, borderStyle, 2)

		  // Write text inside the box
		  Var baseTitle As New XjStyle
		  Var titleStyle As XjStyle = baseTitle.SetFG(XjANSI.FG_YELLOW).SetBold
		  canvas.WriteText(2, 1, "XjTTY-Toolkit v0.1", titleStyle)

		  Var baseBody As New XjStyle
		  Var bodyStyle As XjStyle = baseBody.SetFG(XjANSI.FG_WHITE)
		  canvas.WriteText(2, 3, "Foundation libraries ready:", bodyStyle)

		  Var baseCheck As New XjStyle
		  Var checkStyle As XjStyle = baseCheck.SetFG(XjANSI.FG_GREEN)
		  canvas.WriteText(2, 4, "[+] XjPlatform, XjANSI, XjColor", checkStyle)
		  canvas.WriteText(2, 5, "[+] XjTerminal, XjCursor, XjScreen", checkStyle)
		  canvas.WriteText(2, 6, "[+] XjReader, XjStyle, XjCanvas", checkStyle)

		  // Render the canvas (plain text since we're not in alternate screen)
		  Print(canvas.ToString)
		  Print("")

		  // --- Interactive Demo ---
		  Print("--- Interactive Key Reader Demo ---")
		  Print("Press keys to see them parsed. Press 'q' or Ctrl+C to quit.")
		  Print("")

		  XjTerminal.EnableRawMode
		  XjTerminal.EnableNonBlockingInput

		  Var reader As New XjReader

		  Do
		    Var key As XjKeyEvent = reader.ReadKey
		    If key <> Nil Then
		      Var display As String = "Key: " + key.KeyName
		      If key.IsCharKey Then
		        display = display + " (char=" + key.Char + ", code=" + Str(Asc(key.Char)) + ")"
		      End If
		      display = display + Chr(13) + Chr(10)
		      XjTerminal.Write(display)

		      // Quit on 'q' or Ctrl+C
		      If key.Char = "q" Or (key.IsCtrl And key.Char = Chr(3)) Then Exit
		    End If

		    App.DoEvents(10)
		  Loop

		  XjTerminal.DisableRawMode

		  Print("")
		  Print("Done! XjTTY-Toolkit foundation is working.")

		End Function
	#tag EndEvent


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
