#tag Class
Protected Class App
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  // ============================================
		  // Polish Demo: New Features
		  // ============================================

		  #Pragma Unused args

		  Print("")
		  Print("=== XjTTY-Toolkit Polish: New Features Demo ===")
		  Print("")

		  // --- XjStyle Presets ---
		  Print("--- XjStyle Semantic Presets ---")
		  Print(XjStyle.Success.Apply("  Success: Operation completed"))
		  Print(XjStyle.Warning.Apply("  Warning: Disk space low"))
		  Print(XjStyle.Danger.Apply("  Danger:  Critical error"))
		  Print(XjStyle.Info.Apply("  Info:    Server started"))
		  Print(XjStyle.Muted.Apply("  Muted:   Debug information"))
		  Print(XjStyle.Highlight.Apply("  Highlight: Important text"))
		  Print("")

		  // --- XjCommand ---
		  Print("--- XjCommand: Shell Execution ---")
		  Var result As XjCommandResult = XjCommand.Run("echo Hello from shell")
		  Print("  Output: " + result.Output.Trim)
		  Print("  Exit code: " + Str(result.ExitCode))
		  Print("  Success? " + If(result.IsSuccess, "yes", "no"))
		  Print("")

		  Var dateOutput As String = XjCommand.Capture("date")
		  Print("  Date: " + dateOutput.Trim)
		  Print("  git exists? " + If(XjCommand.Success("which git"), "yes", "no"))
		  Print("  Dry run: " + XjCommand.DryRun("rm -rf /"))
		  Print("")

		  // --- XjHistory + Ask ---
		  Print("--- XjHistory: Input History ---")
		  Print("  (Use Up/Down arrows to recall previous inputs)")
		  Print("")

		  Var history As New XjHistory
		  // Pre-seed some history
		  history.Add("The Matrix")
		  history.Add("Inception")
		  history.Add("Interstellar")

		  Var movie As String = XjPrompt.AskWithHistory("Enter a movie title:", history, "")
		  Print("  -> Movie: " + movie)
		  Print("")

		  // Ask again — history includes previous answer
		  Var movie2 As String = XjPrompt.AskWithHistory("Enter another movie:", history, "")
		  Print("  -> Movie 2: " + movie2)
		  Print("")

		  Print("=== Polish Demo Complete ===")
		  XjPrompt.Ok("All polish features working!")
		  Print("")

		  Return 0
		End Function
	#tag EndEvent


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
