#tag Class
Protected Class App
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  // ============================================
		  // Phase 1 Demo: Event System & App Loop
		  // ============================================
		  // Shows:
		  //   - Fullscreen alternate screen
		  //   - Canvas-based rendering with diff updates
		  //   - Key event handling
		  //   - Terminal resize detection
		  //   - Tick-driven spinner animation
		  //   - Clean shutdown on 'q' or Ctrl+C

		  mWidth = XjTerminal.Width
		  mHeight = XjTerminal.Height
		  mCanvas = New XjCanvas(mWidth, mHeight)
		  mKeyCount = 0
		  mLastKeyName = "(none)"

		  mSpinnerFrames.Add("|")
		  mSpinnerFrames.Add("/")
		  mSpinnerFrames.Add("-")
		  mSpinnerFrames.Add("\")

		  // Create event loop at ~10fps
		  mLoop = New XjEventLoop(100)
		  mLoop.AutoAlternateScreen = True
		  mLoop.AutoRawMode = True

		  // Set callbacks
		  mLoop.SetOnKeyPress(AddressOf HandleKey)
		  mLoop.SetOnResize(AddressOf HandleResize)
		  mLoop.SetOnTick(AddressOf HandleTick)

		  // Run (blocks until Stop_)
		  // First tick will draw the initial UI on the clean alternate screen
		  mLoop.Run

		  // After exiting
		  Print("XjTTY-Toolkit Phase 1 Demo — finished.")
		  Print("Total ticks: " + Str(mLoop.TickCount))
		  Print("Total keys: " + Str(mKeyCount))
		  Print("Duration: " + Format(mLoop.ElapsedSeconds, "0.0") + "s")

		End Function
	#tag EndEvent

	#tag Method, Flags = &h21
		Private Sub HandleKey(key As XjKeyEvent)
		  mKeyCount = mKeyCount + 1
		  mLastKeyName = key.KeyName

		  // Log the event
		  AddEventLog("Key: " + key.KeyName)

		  // Quit on 'q' or Ctrl+C
		  If key.Char = "q" Or key.Char = "Q" Then
		    mLoop.Stop_
		    Return
		  End If
		  If key.IsCtrl And key.Char = Chr(3) Then
		    mLoop.Stop_
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
		  mPrevCanvas = Nil

		  AddEventLog("Resize: " + Str(width) + "x" + Str(height))

		  mNeedsRedraw = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandleTick(tickCount As Integer)
		  // Always redraw on tick to animate spinner
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

		  // Styles
		  Var baseBorder As New XjStyle
		  Var borderStyle As XjStyle = baseBorder.SetFG(XjANSI.FG_CYAN)

		  Var baseTitle As New XjStyle
		  Var titleStyle As XjStyle = baseTitle.SetFG(XjANSI.FG_BRIGHT_YELLOW).SetBold

		  Var baseLbl As New XjStyle
		  Var labelStyle As XjStyle = baseLbl.SetFG(XjANSI.FG_BRIGHT_WHITE).SetBold

		  Var baseVal As New XjStyle
		  Var valueStyle As XjStyle = baseVal.SetFG(XjANSI.FG_WHITE)

		  Var baseGreen As New XjStyle
		  Var greenStyle As XjStyle = baseGreen.SetFG(XjANSI.FG_GREEN)

		  Var baseDim As New XjStyle
		  Var dimStyle As XjStyle = baseDim.SetFG(XjANSI.FG_BRIGHT_BLACK)

		  Var baseHighlight As New XjStyle
		  Var highlightStyle As XjStyle = baseHighlight.SetFG(XjANSI.FG_BRIGHT_CYAN)

		  // Main box (full width, 16 rows tall, or fit to terminal)
		  Var boxW As Integer = mWidth
		  Var boxH As Integer = mHeight
		  If boxW < 40 Then boxW = 40
		  If boxH < 16 Then boxH = 16
		  If boxW > mWidth Then boxW = mWidth
		  If boxH > mHeight Then boxH = mHeight

		  mCanvas.DrawBox(0, 0, boxW, boxH, borderStyle, 2)

		  // Title
		  Var title As String = " XjTTY-Toolkit  Phase 1: Event Loop Demo "
		  Var titleX As Integer = (boxW - title.Length) / 2
		  If titleX < 2 Then titleX = 2
		  mCanvas.WriteText(titleX, 0, title, titleStyle)

		  // Info section
		  Var row As Integer = 2
		  Var col As Integer = 3

		  mCanvas.WriteText(col, row, "Platform: ", labelStyle)
		  mCanvas.WriteText(col + 10, row, XjPlatform.PlatformInfo, valueStyle)

		  row = row + 1
		  mCanvas.WriteText(col, row, "Terminal: ", labelStyle)
		  mCanvas.WriteText(col + 10, row, Str(mWidth) + " x " + Str(mHeight), valueStyle)

		  row = row + 1
		  Var spinIdx As Integer = mLoop.TickCount Mod mSpinnerFrames.Count
		  Var spinner As String = mSpinnerFrames(spinIdx)
		  mCanvas.WriteText(col, row, "Ticks:    ", labelStyle)
		  mCanvas.WriteText(col + 10, row, Str(mLoop.TickCount) + "  " + spinner, greenStyle)

		  row = row + 1
		  Var elapsed As Double = mLoop.ElapsedSeconds
		  Var fps As String = "—"
		  If elapsed > 0.5 Then
		    fps = Format(mLoop.TickCount / elapsed, "0.0")
		  End If
		  mCanvas.WriteText(col, row, "FPS:      ", labelStyle)
		  mCanvas.WriteText(col + 10, row, fps, valueStyle)

		  // Key section
		  row = row + 2
		  mCanvas.WriteText(col, row, "Last key: ", labelStyle)
		  mCanvas.WriteText(col + 10, row, mLastKeyName, highlightStyle)

		  row = row + 1
		  mCanvas.WriteText(col, row, "Keys hit: ", labelStyle)
		  mCanvas.WriteText(col + 10, row, Str(mKeyCount), valueStyle)

		  // Event log
		  row = row + 2
		  mCanvas.WriteText(col, row, "Event Log:", labelStyle)
		  row = row + 1

		  Var logStart As Integer = 0
		  Var maxLogLines As Integer = boxH - row - 3
		  If maxLogLines < 1 Then maxLogLines = 1
		  If mEventLog.Count > maxLogLines Then
		    logStart = mEventLog.Count - maxLogLines
		  End If

		  For i As Integer = logStart To mEventLog.Count - 1
		    If row >= boxH - 2 Then Exit
		    mCanvas.WriteText(col + 1, row, mEventLog(i), dimStyle)
		    row = row + 1
		  Next

		  // Footer
		  Var footer As String = " Press 'q' to quit "
		  Var footerX As Integer = (boxW - footer.Length) / 2
		  If footerX < 2 Then footerX = 2
		  mCanvas.WriteText(footerX, boxH - 1, footer, dimStyle)

		  // Render
		  If mPrevCanvas <> Nil Then
		    XjTerminal.Write(mCanvas.DiffRender(mPrevCanvas))
		  Else
		    XjTerminal.Write(mCanvas.Render)
		  End If

		  mPrevCanvas = mCanvas.Snapshot
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub AddEventLog(text As String)
		  Var timestamp As String = Format(mLoop.ElapsedSeconds, "0.0") + "s"
		  mEventLog.Add("[" + timestamp + "] " + text)

		  // Keep only last 50 entries
		  While mEventLog.Count > 50
		    mEventLog.RemoveAt(0)
		  Wend
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mCanvas As XjCanvas
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPrevCanvas As XjCanvas
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLoop As XjEventLoop
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mEventLog() As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mKeyCount As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLastKeyName As String
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
		Private mSpinnerFrames() As String
	#tag EndProperty


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
