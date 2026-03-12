#tag Class
Protected Class App
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  // ============================================
		  // Phase 2 Demo: Layout Engine
		  // ============================================
		  // Shows:
		  //   - Flexbox-like layout with header/sidebar/content/footer
		  //   - Fixed, percentage, and auto sizing
		  //   - Borders and titles on layout nodes
		  //   - Auto-resize when terminal changes size
		  //   - Spinner animation + key/event tracking in layout panels

		  mWidth = XjTerminal.Width
		  mHeight = XjTerminal.Height
		  mCanvas = New XjCanvas(mWidth, mHeight)
		  mKeyCount = 0
		  mLastKeyName = "(none)"

		  mSpinnerFrames.Add("|")
		  mSpinnerFrames.Add("/")
		  mSpinnerFrames.Add("-")
		  mSpinnerFrames.Add("\")

		  // Build layout tree
		  BuildLayout

		  // Solve layout for current terminal size
		  XjLayoutSolver.Solve(mRoot, mWidth, mHeight)

		  // Create event loop at ~10fps
		  mLoop = New XjEventLoop(100)
		  mLoop.AutoAlternateScreen = True
		  mLoop.AutoRawMode = True

		  // Set callbacks
		  mLoop.SetOnKeyPress(AddressOf HandleKey)
		  mLoop.SetOnResize(AddressOf HandleResize)
		  mLoop.SetOnTick(AddressOf HandleTick)

		  // Run (blocks until Stop_)
		  mLoop.Run

		  // After exiting
		  Print("XjTTY-Toolkit Phase 2 Demo — finished.")
		  Print("Total ticks: " + Str(mLoop.TickCount))
		  Print("Total keys: " + Str(mKeyCount))
		  Print("Duration: " + Format(mLoop.ElapsedSeconds, "0.0") + "s")

		End Function
	#tag EndEvent

	#tag Method, Flags = &h21
		Private Sub BuildLayout()
		  // ============================================================
		  // RESPONSIVE LAYOUT (current) — fits to terminal window size
		  // ============================================================
		  // The layout tree uses Auto/Percent constraints so it adapts
		  // to any terminal size. XjLayoutSolver.Solve is called with
		  // the actual terminal dimensions (mWidth, mHeight) and the
		  // layout reflows automatically on resize.
		  //
		  // To use FIXED size instead (like a dialog box centered on screen):
		  // ----------------------------------------------------------------
		  // // Fixed 80x24 layout, ignoring terminal size:
		  // Var fixedW As Integer = 80
		  // Var fixedH As Integer = 24
		  // Call mRoot.SetWidth(XjConstraint.Fixed(fixedW)).SetHeight(XjConstraint.Fixed(fixedH))
		  // XjLayoutSolver.Solve(mRoot, fixedW, fixedH)
		  //
		  // // To center a fixed layout on a larger terminal:
		  // Var offsetX As Integer = (mWidth - fixedW) / 2
		  // Var offsetY As Integer = (mHeight - fixedH) / 2
		  // XjLayoutSolver.Solve(mRoot, fixedW, fixedH)
		  // // Then offset all rendering by (offsetX, offsetY)
		  // ----------------------------------------------------------------

		  // Styles for borders
		  Var baseCyan As New XjStyle
		  Var cyanBorder As XjStyle = baseCyan.SetFG(XjANSI.FG_CYAN)

		  Var baseMagenta As New XjStyle
		  Var magentaBorder As XjStyle = baseMagenta.SetFG(XjANSI.FG_MAGENTA)

		  Var baseGreen As New XjStyle
		  Var greenBorder As XjStyle = baseGreen.SetFG(XjANSI.FG_GREEN)

		  Var baseYellow As New XjStyle
		  Var yellowBorder As XjStyle = baseYellow.SetFG(XjANSI.FG_YELLOW)

		  // Root: column direction, fills terminal (responsive)
		  mRoot = New XjLayoutNode
		  Call mRoot.SetDirection(XjLayoutNode.DIR_COLUMN).SetName("root")

		  // Header: fixed 3 rows with double-line border
		  Var header As New XjLayoutNode
		  Call header.SetHeight(XjConstraint.Fixed(3)).SetName("header").SetBorder(2, cyanBorder).SetTitle(" XjTTY-Toolkit Phase 2: Layout Demo ")
		  mRoot.AddChild(header)

		  // Middle section: row direction, auto height (expands to fill)
		  Var middle As New XjLayoutNode
		  Call middle.SetDirection(XjLayoutNode.DIR_ROW).SetName("middle")
		  mRoot.AddChild(middle)

		  // Sidebar: 25% width, min 15 cols so it stays usable on small terminals
		  Var sidebar As New XjLayoutNode
		  Call sidebar.SetWidth(XjConstraint.Percent(25).SetMin(15)).SetName("sidebar").SetBorder(0, magentaBorder).SetTitle(" Nav ")
		  middle.AddChild(sidebar)

		  // Main content: auto width (fills remaining 75%+)
		  Var content As New XjLayoutNode
		  Call content.SetName("content").SetBorder(0, greenBorder).SetTitle(" Content ")
		  middle.AddChild(content)

		  // Footer: fixed 3 rows with border
		  Var footer As New XjLayoutNode
		  Call footer.SetHeight(XjConstraint.Fixed(3)).SetName("footer").SetBorder(0, yellowBorder)
		  mRoot.AddChild(footer)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandleKey(key As XjKeyEvent)
		  mKeyCount = mKeyCount + 1
		  mLastKeyName = key.KeyName

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

		  // Recreate canvas at new size
		  mCanvas = New XjCanvas(mWidth, mHeight)

		  // Re-solve layout for new terminal size
		  XjLayoutSolver.Solve(mRoot, mWidth, mHeight)

		  AddEventLog("Resize: " + Str(width) + "x" + Str(height))

		  mNeedsRedraw = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandleTick(tickCount As Integer)
		  #Pragma Unused tickCount

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

		  // ---- Minimum terminal size guard ----
		  // Like btop/htop: if terminal is too small, show a message instead of broken UI.
		  // MIN_WIDTH and MIN_HEIGHT define the smallest usable size for our layout.
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

		    // Render the "too small" screen
		    XjTerminal.Write(mCanvas.Render)
		    Return
		  End If

		  // Styles
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

		  Var baseActive As New XjStyle
		  Var activeStyle As XjStyle = baseActive.SetFG(XjANSI.FG_BRIGHT_MAGENTA).SetBold

		  // Paint all layout borders
		  mRoot.PaintTo(mCanvas)

		  // --- Header content ---
		  Var hdr As XjLayoutNode = mRoot.FindByName("header")
		  If hdr <> Nil Then
		    mCanvas.WriteText(hdr.ContentX, hdr.ContentY, "Platform: " + XjPlatform.PlatformInfo + "  |  Terminal: " + Str(mWidth) + "x" + Str(mHeight), valueStyle)
		  End If

		  // --- Sidebar content ---
		  Var sb As XjLayoutNode = mRoot.FindByName("sidebar")
		  If sb <> Nil Then
		    Var sx As Integer = sb.ContentX
		    Var sy As Integer = sb.ContentY

		    mCanvas.WriteText(sx, sy, "Navigation", labelStyle)
		    sy = sy + 2
		    mCanvas.WriteText(sx, sy, "> Dashboard", activeStyle)
		    sy = sy + 1
		    mCanvas.WriteText(sx, sy, "  Settings", dimStyle)
		    sy = sy + 1
		    mCanvas.WriteText(sx, sy, "  About", dimStyle)
		    sy = sy + 1
		    mCanvas.WriteText(sx, sy, "  Help", dimStyle)
		  End If

		  // --- Main content ---
		  Var ct As XjLayoutNode = mRoot.FindByName("content")
		  If ct <> Nil Then
		    Var cx As Integer = ct.ContentX
		    Var cy As Integer = ct.ContentY

		    // Spinner
		    Var spinIdx As Integer = mLoop.TickCount Mod mSpinnerFrames.Count
		    Var spinner As String = mSpinnerFrames(spinIdx)

		    mCanvas.WriteText(cx, cy, "Ticks:    ", labelStyle)
		    mCanvas.WriteText(cx + 10, cy, Str(mLoop.TickCount) + "  " + spinner, greenStyle)

		    cy = cy + 1
		    Var elapsed As Double = mLoop.ElapsedSeconds
		    Var fps As String = Chr(8212)
		    If elapsed > 0.5 Then
		      fps = Format(mLoop.TickCount / elapsed, "0.0")
		    End If
		    mCanvas.WriteText(cx, cy, "FPS:      ", labelStyle)
		    mCanvas.WriteText(cx + 10, cy, fps, valueStyle)

		    cy = cy + 1
		    mCanvas.WriteText(cx, cy, "Last key: ", labelStyle)
		    mCanvas.WriteText(cx + 10, cy, mLastKeyName, highlightStyle)

		    cy = cy + 1
		    mCanvas.WriteText(cx, cy, "Keys hit: ", labelStyle)
		    mCanvas.WriteText(cx + 10, cy, Str(mKeyCount), valueStyle)

		    // Layout info
		    cy = cy + 2
		    mCanvas.WriteText(cx, cy, "Layout Nodes:", labelStyle)
		    cy = cy + 1
		    mCanvas.WriteText(cx + 1, cy, "header:  " + NodeInfo(mRoot.FindByName("header")), dimStyle)
		    cy = cy + 1
		    mCanvas.WriteText(cx + 1, cy, "sidebar: " + NodeInfo(mRoot.FindByName("sidebar")), dimStyle)
		    cy = cy + 1
		    mCanvas.WriteText(cx + 1, cy, "content: " + NodeInfo(mRoot.FindByName("content")), dimStyle)
		    cy = cy + 1
		    mCanvas.WriteText(cx + 1, cy, "footer:  " + NodeInfo(mRoot.FindByName("footer")), dimStyle)

		    // Event log
		    cy = cy + 2
		    mCanvas.WriteText(cx, cy, "Event Log:", labelStyle)
		    cy = cy + 1

		    Var maxLog As Integer = ct.ContentY + ct.ContentHeight - cy
		    If maxLog < 1 Then maxLog = 1
		    Var logStart As Integer = 0
		    If mEventLog.Count > maxLog Then
		      logStart = mEventLog.Count - maxLog
		    End If

		    For i As Integer = logStart To mEventLog.Count - 1
		      If cy >= ct.ContentY + ct.ContentHeight Then Exit
		      mCanvas.WriteText(cx + 1, cy, mEventLog(i), dimStyle)
		      cy = cy + 1
		    Next
		  End If

		  // --- Footer content ---
		  Var ft As XjLayoutNode = mRoot.FindByName("footer")
		  If ft <> Nil Then
		    Var footerText As String = "Press 'q' to quit  |  Phase 2: Layout Engine Demo"
		    Var fx As Integer = ft.ContentX + (ft.ContentWidth - footerText.Length) / 2
		    If fx < ft.ContentX Then fx = ft.ContentX
		    mCanvas.WriteText(fx, ft.ContentY, footerText, dimStyle)
		  End If

		  // Render — always full render for robustness.
		  // Full render overwrites every cell on every frame, so external
		  // events (Cmd+K clear, terminal resize scroll) can't leave artifacts.
		  //
		  // To enable diff rendering for performance (only redraws changed cells):
		  // If mPrevCanvas <> Nil Then
		  //   XjTerminal.Write(mCanvas.DiffRender(mPrevCanvas))
		  // Else
		  //   XjTerminal.Write(mCanvas.Render)
		  // End If
		  // mPrevCanvas = mCanvas.Snapshot
		  XjTerminal.Write(mCanvas.Render)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function NodeInfo(node As XjLayoutNode) As String
		  If node Is Nil Then Return "(nil)"
		  Return Str(node.ComputedWidth) + "x" + Str(node.ComputedHeight) + " at " + Str(node.ComputedX) + "," + Str(node.ComputedY)
		End Function
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
		Private mRoot As XjLayoutNode
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


	// Minimum terminal size for the layout to render properly.
	// Below this, a "Terminal too small" message is shown instead.
	#tag Constant, Name = MIN_WIDTH, Type = Double, Dynamic = False, Default = \"60", Scope = Private
	#tag EndConstant

	#tag Constant, Name = MIN_HEIGHT, Type = Double, Dynamic = False, Default = \"16", Scope = Private
	#tag EndConstant



	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
