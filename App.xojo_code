#tag Class
Protected Class App
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  // ============================================
		  // Phase 6 Demo: YAML UI Definition
		  // ============================================
		  // Parses YAML markup and builds a widget tree

		  #Pragma Unused args

		  Print("")
		  Print("=== XjTTY-Toolkit Phase 6: YAML UI Definition Demo ===")
		  Print("")

		  // Define a UI layout in YAML
		  Var yaml As String = ""
		  yaml = yaml + "box:" + Chr(10)
		  yaml = yaml + "  name: root" + Chr(10)
		  yaml = yaml + "  direction: column" + Chr(10)
		  yaml = yaml + "  border: single" + Chr(10)
		  yaml = yaml + "  title: My Application" + Chr(10)
		  yaml = yaml + "  width: 60" + Chr(10)
		  yaml = yaml + "  height: 20" + Chr(10)
		  yaml = yaml + "  children:" + Chr(10)
		  yaml = yaml + "    - box:" + Chr(10)
		  yaml = yaml + "        name: header" + Chr(10)
		  yaml = yaml + "        height: 3" + Chr(10)
		  yaml = yaml + "        border: round" + Chr(10)
		  yaml = yaml + "        title: Header" + Chr(10)
		  yaml = yaml + "        children:" + Chr(10)
		  yaml = yaml + "          - text:" + Chr(10)
		  yaml = yaml + "              content: Welcome to XjTTY!" + Chr(10)
		  yaml = yaml + "              align: center" + Chr(10)
		  yaml = yaml + "    - box:" + Chr(10)
		  yaml = yaml + "        name: body" + Chr(10)
		  yaml = yaml + "        direction: row" + Chr(10)
		  yaml = yaml + "        height: auto" + Chr(10)
		  yaml = yaml + "        children:" + Chr(10)
		  yaml = yaml + "          - box:" + Chr(10)
		  yaml = yaml + "              name: sidebar" + Chr(10)
		  yaml = yaml + "              width: 30%" + Chr(10)
		  yaml = yaml + "              border: single" + Chr(10)
		  yaml = yaml + "              title: Menu" + Chr(10)
		  yaml = yaml + "              children:" + Chr(10)
		  yaml = yaml + "                - text:" + Chr(10)
		  yaml = yaml + "                    content: Dashboard" + Chr(10)
		  yaml = yaml + "                - text:" + Chr(10)
		  yaml = yaml + "                    content: Settings" + Chr(10)
		  yaml = yaml + "                - text:" + Chr(10)
		  yaml = yaml + "                    content: About" + Chr(10)
		  yaml = yaml + "          - box:" + Chr(10)
		  yaml = yaml + "              name: content" + Chr(10)
		  yaml = yaml + "              width: auto" + Chr(10)
		  yaml = yaml + "              border: single" + Chr(10)
		  yaml = yaml + "              title: Content" + Chr(10)
		  yaml = yaml + "              children:" + Chr(10)
		  yaml = yaml + "                - text:" + Chr(10)
		  yaml = yaml + "                    content: Main content area" + Chr(10)
		  yaml = yaml + "                - progressbar:" + Chr(10)
		  yaml = yaml + "                    name: progress" + Chr(10)
		  yaml = yaml + "                    value: 65" + Chr(10)
		  yaml = yaml + "                    total: 100" + Chr(10)
		  yaml = yaml + "    - box:" + Chr(10)
		  yaml = yaml + "        name: footer" + Chr(10)
		  yaml = yaml + "        height: 3" + Chr(10)
		  yaml = yaml + "        border: single" + Chr(10)
		  yaml = yaml + "        children:" + Chr(10)
		  yaml = yaml + "          - text:" + Chr(10)
		  yaml = yaml + "              content: Status: Ready" + Chr(10)

		  // --- Step 1: Show the YAML source ---
		  Print("--- YAML Source ---")
		  Var yamlLines() As String = yaml.Split(Chr(10))
		  For i As Integer = 0 To yamlLines.Count - 1
		    Print("  " + yamlLines(i))
		  Next
		  Print("")

		  // --- Step 2: Parse YAML ---
		  Print("--- Parsed Tree ---")
		  Var root As XjYAMLNode = XjYAML.Parse(yaml)
		  Print(root.Dump(1))

		  // --- Step 3: Build widget tree ---
		  Print("--- Widget Tree ---")
		  Var widget As XjWidget = XjUIParser.BuildFromNode(root)
		  If widget <> Nil Then
		    Print(XjUIParser.DumpWidgetTree(widget, 1))
		  Else
		    Print("  (no widget built)")
		  End If

		  // --- Step 4: Render to canvas ---
		  Print("--- Rendered UI ---")
		  If widget <> Nil Then
		    Var w As Integer = 60
		    Var h As Integer = 20
		    Var canvas As New XjCanvas(w, h)

		    // Solve layout
		    Var layoutNode As XjLayoutNode = widget.LayoutNode
		    Call layoutNode.SetWidth(XjConstraint.Fixed(w))
		    Call layoutNode.SetHeight(XjConstraint.Fixed(h))
		    XjLayoutSolver.Solve(layoutNode, w, h)

		    // Paint
		    widget.Paint(canvas)

		    // Output rendered canvas line by line
		    For row As Integer = 0 To h - 1
		      Var line As String = ""
		      For col As Integer = 0 To w - 1
		        Var cell As XjCell = canvas.GetCell(col, row)
		        If cell <> Nil Then
		          If cell.Style <> Nil Then
		            line = line + cell.Style.Apply(cell.Char)
		          Else
		            line = line + cell.Char
		          End If
		        Else
		          line = line + " "
		        End If
		      Next
		      Print("  " + line)
		    Next
		  End If

		  Print("")
		  Print("=== Demo Complete ===")
		  XjPrompt.Ok("YAML UI Definition system working!")
		  Print("")

		  Return 0
		End Function
	#tag EndEvent


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
