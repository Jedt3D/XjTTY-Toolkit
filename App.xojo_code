#tag Class
Protected Class App
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  // ============================================
		  // Phase 3 Demo: Widget System
		  // ============================================
		  // Shows:
		  //   - Widget tree built from XjBox, XjText, XjTextInput
		  //   - XjTable with data rows
		  //   - XjProgressBar with format tokens
		  //   - XjSpinner with braille animation
		  //   - XjTree with hierarchy display
		  //   - XjFocusManager for Tab cycling between inputs
		  //   - Auto-resize and minimum size guard

		  #Pragma Unused args

		  mWidth = XjTerminal.Width
		  mHeight = XjTerminal.Height
		  mCanvas = New XjCanvas(mWidth, mHeight)
		  mKeyCount = 0

		  // Build widget tree
		  BuildWidgets

		  // Solve layout
		  XjLayoutSolver.Solve(mRoot.LayoutNode, mWidth, mHeight)

		  // Build focus chain
		  mFocusManager = New XjFocusManager
		  mFocusManager.BuildChain(mRoot)

		  // Create event loop at ~10fps
		  mLoop = New XjEventLoop(100)
		  mLoop.AutoAlternateScreen = True
		  mLoop.AutoRawMode = True

		  mLoop.SetOnKeyPress(AddressOf HandleKey)
		  mLoop.SetOnResize(AddressOf HandleResize)
		  mLoop.SetOnTick(AddressOf HandleTick)

		  mLoop.Run

		  // After exiting
		  Print("XjTTY-Toolkit Phase 3 Demo " + Chr(8212) + " finished.")
		  Print("Total ticks: " + Str(mLoop.TickCount))
		  Print("Total keys: " + Str(mKeyCount))
		  Print("Duration: " + Format(mLoop.ElapsedSeconds, "0.0") + "s")

		  // Show what was typed in the input
		  If mInput1 <> Nil Then
		    Print("Input 1: " + mInput1.Value)
		  End If
		  If mInput2 <> Nil Then
		    Print("Input 2: " + mInput2.Value)
		  End If

		End Function
	#tag EndEvent

	#tag Method, Flags = &h21
		Private Sub BuildWidgets()
		  // Styles
		  Var base As New XjStyle
		  Var cyanBorder As XjStyle = base.SetFG(XjANSI.FG_CYAN)
		  Var greenBorder As XjStyle = base.SetFG(XjANSI.FG_GREEN)
		  Var magentaBorder As XjStyle = base.SetFG(XjANSI.FG_MAGENTA)
		  Var yellowBorder As XjStyle = base.SetFG(XjANSI.FG_YELLOW)
		  Var whiteBorder As XjStyle = base.SetFG(XjANSI.FG_WHITE)
		  Var dimStyle As XjStyle = base.SetFG(XjANSI.FG_BRIGHT_BLACK)

		  // ---- Root: column layout ----
		  mRoot = New XjBox
		  Call mRoot.SetDirection(XjLayoutNode.DIR_COLUMN).SetName("root")

		  // ---- Header: fixed 3 rows ----
		  Var header As New XjText
		  Call header.SetHeight(XjConstraint.Fixed(3))
		  Call header.SetName("header")
		  Call header.SetBorder(2, cyanBorder)
		  Call header.SetTitle(" XjTTY-Toolkit Phase 3: Widget Demo ")
		  Call header.SetText("Platform: " + XjPlatform.PlatformInfo)
		  Call header.SetStyle(base.SetFG(XjANSI.FG_WHITE))
		  mRoot.AddChild(header)

		  // ---- Middle: row layout ----
		  Var middle As New XjBox
		  Call middle.SetDirection(XjLayoutNode.DIR_ROW).SetName("middle")
		  mRoot.AddChild(middle)

		  // ---- Left sidebar: tree + spinner ----
		  Var sidebar As New XjBox
		  Call sidebar.SetDirection(XjLayoutNode.DIR_COLUMN).SetName("sidebar")
		  Call sidebar.SetWidth(XjConstraint.Percent(30).SetMin(20))
		  Call sidebar.SetBorder(0, magentaBorder).SetTitle(" Sidebar ")
		  middle.AddChild(sidebar)

		  // Tree widget
		  mTree = New XjTree
		  Call mTree.SetName("tree")
		  BuildTreeData
		  sidebar.AddChild(mTree)

		  // Spinner
		  mSpinner = New XjSpinner
		  Call mSpinner.SetName("spinner")
		  Call mSpinner.SetHeight(XjConstraint.Fixed(1))
		  Call mSpinner.SetFormat("dots")
		  Call mSpinner.SetMessage("Processing...")
		  sidebar.AddChild(mSpinner)

		  // ---- Right content: column with table, progress, inputs ----
		  Var content As New XjBox
		  Call content.SetDirection(XjLayoutNode.DIR_COLUMN).SetName("content")
		  Call content.SetBorder(0, greenBorder).SetTitle(" Content ")
		  middle.AddChild(content)

		  // Table
		  mTable = New XjTable
		  Call mTable.SetName("table")
		  Call mTable.SetHeight(XjConstraint.Fixed(6))
		  Var hdrs() As String
		  hdrs.Add("Widget")
		  hdrs.Add("Type")
		  hdrs.Add("Status")
		  Call mTable.SetHeaders(hdrs)
		  Var r1() As String
		  r1.Add("XjBox")
		  r1.Add("Container")
		  r1.Add(Chr(&h2714) + " Done")
		  mTable.AddRow(r1)
		  Var r2() As String
		  r2.Add("XjText")
		  r2.Add("Display")
		  r2.Add(Chr(&h2714) + " Done")
		  mTable.AddRow(r2)
		  Var r3() As String
		  r3.Add("XjTextInput")
		  r3.Add("Interactive")
		  r3.Add(Chr(&h2714) + " Done")
		  mTable.AddRow(r3)
		  Var r4() As String
		  r4.Add("XjTable")
		  r4.Add("Data")
		  r4.Add(Chr(&h2714) + " Done")
		  mTable.AddRow(r4)
		  Call mTable.SetColumnAlign(2, XjTable.ALIGN_CENTER)

		  Var altBase As New XjStyle
		  Call mTable.SetAltRowStyle(altBase.SetFG(XjANSI.FG_BRIGHT_WHITE))
		  content.AddChild(mTable)

		  // Progress bar
		  mProgress = New XjProgressBar
		  Call mProgress.SetName("progress")
		  Call mProgress.SetHeight(XjConstraint.Fixed(1))
		  Call mProgress.SetFormat(":bar :percent :eta")
		  Call mProgress.SetTotal(100)
		  content.AddChild(mProgress)

		  // Input box with two fields
		  Var inputBox As New XjBox
		  Call inputBox.SetDirection(XjLayoutNode.DIR_COLUMN).SetName("inputbox")
		  Call inputBox.SetHeight(XjConstraint.Fixed(5))
		  Call inputBox.SetBorder(0, whiteBorder).SetTitle(" Input (Tab to switch) ")
		  content.AddChild(inputBox)

		  // Text input 1
		  mInput1 = New XjTextInput
		  Call mInput1.SetName("input1")
		  Call mInput1.SetHeight(XjConstraint.Fixed(1))
		  Call mInput1.SetLabel("Name: ", base.SetFG(XjANSI.FG_BRIGHT_WHITE).SetBold)
		  Call mInput1.SetPlaceholder("Type your name...")
		  Call mInput1.SetStyle(base.SetFG(XjANSI.FG_BRIGHT_CYAN))
		  inputBox.AddChild(mInput1)

		  // Text input 2 (password)
		  mInput2 = New XjTextInput
		  Call mInput2.SetName("input2")
		  Call mInput2.SetHeight(XjConstraint.Fixed(1))
		  Call mInput2.SetLabel("Pass: ", base.SetFG(XjANSI.FG_BRIGHT_WHITE).SetBold)
		  Call mInput2.SetPlaceholder("Type password...")
		  Call mInput2.SetMask("*")
		  Call mInput2.SetStyle(base.SetFG(XjANSI.FG_BRIGHT_YELLOW))
		  inputBox.AddChild(mInput2)

		  // Event log text
		  mEventText = New XjText
		  Call mEventText.SetName("eventlog")
		  Call mEventText.SetStyle(dimStyle)
		  Call mEventText.SetWrap(False)
		  content.AddChild(mEventText)

		  // ---- Footer ----
		  Var footer As New XjText
		  Call footer.SetHeight(XjConstraint.Fixed(3))
		  Call footer.SetName("footer")
		  Call footer.SetBorder(0, yellowBorder)
		  Call footer.SetText("Press Ctrl+C or ESC to quit  |  Tab to cycle focus  |  Phase 3: Widget System")
		  Call footer.SetAlign(XjText.ALIGN_CENTER)
		  Call footer.SetStyle(dimStyle)
		  mRoot.AddChild(footer)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub BuildTreeData()
		  Var root As New XjTreeNode("XjTTY-Toolkit")
		  Var libNode As New XjTreeNode("XjTTYLib")
		  Call root.AddChild(libNode)

		  Call libNode.AddChild(New XjTreeNode("XjWidget (base)"))
		  Call libNode.AddChild(New XjTreeNode("XjBox"))
		  Call libNode.AddChild(New XjTreeNode("XjText"))
		  Call libNode.AddChild(New XjTreeNode("XjTextInput"))
		  Call libNode.AddChild(New XjTreeNode("XjTable"))
		  Call libNode.AddChild(New XjTreeNode("XjProgressBar"))
		  Call libNode.AddChild(New XjTreeNode("XjSpinner"))
		  Call libNode.AddChild(New XjTreeNode("XjTree"))

		  Var infra As New XjTreeNode("Infrastructure")
		  Call root.AddChild(infra)
		  Call infra.AddChild(New XjTreeNode("XjCanvas"))
		  Call infra.AddChild(New XjTreeNode("XjLayoutNode"))
		  Call infra.AddChild(New XjTreeNode("XjEventLoop"))

		  mTree.AddRoot(root)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandleKey(key As XjKeyEvent)
		  mKeyCount = mKeyCount + 1

		  AddEventLog("Key: " + key.KeyName)

		  // Quit on ESC or Ctrl+C
		  If key.IsEscape Then
		    mLoop.Stop_
		    Return
		  End If
		  If key.IsCtrl And key.Char = Chr(3) Then
		    mLoop.Stop_
		    Return
		  End If

		  // Route through focus manager (handles Tab + forwards to focused widget)
		  If mFocusManager.HandleKey(key) Then
		    mNeedsRedraw = True
		    Return
		  End If

		  mNeedsRedraw = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandleResize(width As Integer, height As Integer)
		  mWidth = width
		  mHeight = height
		  mCanvas = New XjCanvas(mWidth, mHeight)

		  // Re-solve layout
		  XjLayoutSolver.Solve(mRoot.LayoutNode, mWidth, mHeight)

		  AddEventLog("Resize: " + Str(width) + "x" + Str(height))
		  mNeedsRedraw = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandleTick(tickCount As Integer)
		  // Advance progress bar (auto-fills over ~10 seconds at 10fps)
		  If Not mProgress.IsComplete Then
		    mProgress.Advance(0.1)
		  End If

		  // Tick widgets (spinner animation etc.)
		  mRoot.HandleTick(tickCount)

		  // Complete spinner when progress is done
		  If mProgress.IsComplete And mSpinner.IsRunning Then
		    mSpinner.Success("All done!")
		  End If

		  mNeedsRedraw = True

		  If mNeedsRedraw Then
		    RedrawUI
		    mNeedsRedraw = False
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RedrawUI()
		  mCanvas.Clear

		  // Minimum size guard
		  If mWidth < MIN_WIDTH Or mHeight < MIN_HEIGHT Then
		    Var baseWarn As New XjStyle
		    Var warnStyle As XjStyle = baseWarn.SetFG(XjANSI.FG_BRIGHT_YELLOW).SetBold
		    Var baseInfo As New XjStyle
		    Var infoStyle As XjStyle = baseInfo.SetFG(XjANSI.FG_WHITE)

		    Var msgY As Integer = mHeight / 2 - 1
		    If msgY < 0 Then msgY = 0

		    Var msg1 As String = "Terminal too small!"
		    Var msg2 As String = "Need at least " + Str(MIN_WIDTH) + "x" + Str(MIN_HEIGHT)
		    Var msg3 As String = "Current: " + Str(mWidth) + "x" + Str(mHeight)

		    Var x1 As Integer = (mWidth - msg1.Length) / 2
		    Var x2 As Integer = (mWidth - msg2.Length) / 2
		    Var x3 As Integer = (mWidth - msg3.Length) / 2
		    If x1 < 0 Then x1 = 0
		    If x2 < 0 Then x2 = 0
		    If x3 < 0 Then x3 = 0

		    mCanvas.WriteText(x1, msgY, msg1, warnStyle)
		    mCanvas.WriteText(x2, msgY + 1, msg2, infoStyle)
		    mCanvas.WriteText(x3, msgY + 2, msg3, infoStyle)

		    XjTerminal.Write(mCanvas.Render)
		    Return
		  End If

		  // Update event log text
		  UpdateEventLog

		  // Paint the entire widget tree
		  mRoot.Paint(mCanvas)

		  XjTerminal.Write(mCanvas.Render)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UpdateEventLog()
		  If mEventText Is Nil Then Return

		  // Build the event log as a multi-line string
		  Var lines() As String
		  Var maxLines As Integer = mEventText.ContentHeight
		  If maxLines < 1 Then maxLines = 5

		  Var startIdx As Integer = 0
		  If mEventLog.Count > maxLines Then
		    startIdx = mEventLog.Count - maxLines
		  End If

		  For i As Integer = startIdx To mEventLog.Count - 1
		    lines.Add(mEventLog(i))
		  Next

		  Call mEventText.SetText(String.FromArray(lines, EndOfLine))
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub AddEventLog(text As String)
		  Var timestamp As String = Format(mLoop.ElapsedSeconds, "0.0") + "s"
		  mEventLog.Add("[" + timestamp + "] " + text)

		  While mEventLog.Count > 50
		    mEventLog.RemoveAt(0)
		  Wend
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mCanvas As XjCanvas
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLoop As XjEventLoop
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mRoot As XjBox
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mFocusManager As XjFocusManager
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mEventLog() As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mKeyCount As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mWidth As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mHeight As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mNeedsRedraw As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTree As XjTree
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSpinner As XjSpinner
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTable As XjTable
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mProgress As XjProgressBar
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mInput1 As XjTextInput
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mInput2 As XjTextInput
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mEventText As XjText
	#tag EndProperty


	#tag Constant, Name = MIN_WIDTH, Type = Double, Dynamic = False, Default = \"70", Scope = Private
	#tag EndConstant

	#tag Constant, Name = MIN_HEIGHT, Type = Double, Dynamic = False, Default = \"20", Scope = Private
	#tag EndConstant


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
