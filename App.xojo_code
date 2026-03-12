#tag Class
Protected Class App
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  // ============================================
		  // Phase 4 Demo: Prompt System
		  // ============================================
		  // Shows all 13 prompt types running inline
		  // (no fullscreen, no canvas — just stdout)

		  #Pragma Unused args

		  Print("")
		  Print("=== XjTTY-Toolkit Phase 4: Prompt System Demo ===")
		  Print("")

		  // --- Output helpers ---
		  XjPrompt.Say("Welcome to the Prompt System demo!")
		  XjPrompt.Ok("All 13 prompt types are available.")
		  XjPrompt.Warn("Some prompts require keyboard interaction.")
		  Print("")

		  // 1. Ask
		  Var name As String = XjPrompt.Ask("What is your name?", "World")
		  Print("  -> Name: " + name)
		  Print("")

		  // 2. Confirm
		  Var sure As Boolean = XjPrompt.Confirm("Continue the demo?")
		  If Not sure Then
		    XjPrompt.Error_("Demo cancelled.")
		    Return 0
		  End If
		  Print("")

		  // 3. Password
		  Var pass As String = XjPrompt.Password("Enter a secret:")
		  Print("  -> Password length: " + Str(pass.Length))
		  Print("")

		  // 4. Select
		  Var colors() As String
		  colors.Add("Red")
		  colors.Add("Green")
		  colors.Add("Blue")
		  colors.Add("Yellow")
		  colors.Add("Cyan")
		  Var color As String = XjPrompt.Select_("Pick a color:", colors)
		  Print("  -> Color: " + color)
		  Print("")

		  // 5. MultiSelect
		  Var toppings() As String
		  toppings.Add("Cheese")
		  toppings.Add("Pepperoni")
		  toppings.Add("Mushrooms")
		  toppings.Add("Onions")
		  toppings.Add("Peppers")
		  Var selected() As String = XjPrompt.MultiSelect("Choose toppings:", toppings)
		  Var selStr As String = String.FromArray(selected, ", ")
		  Print("  -> Toppings: " + selStr)
		  Print("")

		  // 6. EnumSelect
		  Var sizes() As String
		  sizes.Add("Small")
		  sizes.Add("Medium")
		  sizes.Add("Large")
		  Var size As String = XjPrompt.EnumSelect("Pick a size:", sizes)
		  Print("  -> Size: " + size)
		  Print("")

		  // 7. Slider
		  Var vol As Integer = XjPrompt.Slider("Volume:", 0, 100, 5, 50)
		  Print("  -> Volume: " + Str(vol))
		  Print("")

		  // 8. KeyPress
		  Var key As XjKeyEvent = XjPrompt.KeyPress("Press any key to continue...")
		  If key <> Nil Then
		    Print("  -> Key: " + key.KeyName)
		  Else
		    Print("  -> (no key)")
		  End If
		  Print("")

		  // 9. Expand
		  Var actions() As String
		  actions.Add("Yes")
		  actions.Add("No")
		  actions.Add("Diff")
		  Var actionKeys() As String
		  actionKeys.Add("y")
		  actionKeys.Add("n")
		  actionKeys.Add("d")
		  Var action As String = XjPrompt.Expand("Overwrite file?", actions, actionKeys)
		  Print("  -> Action: " + action)
		  Print("")

		  // Summary
		  Print("")
		  Print("=== Demo Complete ===")
		  XjPrompt.Ok("All prompt types demonstrated successfully!")
		  Print("")

		  Return 0
		End Function
	#tag EndEvent


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
