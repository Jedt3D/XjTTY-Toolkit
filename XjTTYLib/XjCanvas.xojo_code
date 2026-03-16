#tag Class
Protected Class XjCanvas
	#tag Method, Flags = &h0
		Sub Blit(source As XjCanvas, srcX As Integer, srcY As Integer, srcW As Integer, srcH As Integer, destX As Integer, destY As Integer)
		  // Copy a region from another canvas onto this canvas.
		  // Uses parallel arrays — no XjCell objects involved.
		  For row As Integer = 0 To srcH - 1
		    For col As Integer = 0 To srcW - 1
		      Var sx As Integer = srcX + col
		      Var sy As Integer = srcY + row
		      Var dx As Integer = destX + col
		      Var dy As Integer = destY + row

		      If sx >= 0 And sx < source.mWidth And sy >= 0 And sy < source.mHeight Then
		        If dx >= 0 And dx < mWidth And dy >= 0 And dy < mHeight Then
		          Var srcIdx As Integer = sy * source.mWidth + sx
		          Var dstIdx As Integer = dy * mWidth + dx
		          mChars(dstIdx) = source.mChars(srcIdx)
		          mStyles(dstIdx) = source.mStyles(srcIdx)
		        End If
		      End If
		    Next
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Clear()
		  // Clear all cells to empty space with default style.
		  // Direct array writes — no object dereferences.
		  For i As Integer = 0 To mChars.Count - 1
		    mChars(i) = " "
		    mStyles(i) = mDefaultStyle
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ClearRegion(x As Integer, y As Integer, w As Integer, h As Integer)
		  // Clear a rectangular region
		  For row As Integer = y To y + h - 1
		    For col As Integer = x To x + w - 1
		      If col >= 0 And col < mWidth And row >= 0 And row < mHeight Then
		        Var idx As Integer = row * mWidth + col
		        mChars(idx) = " "
		        mStyles(idx) = mDefaultStyle
		      End If
		    Next
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(width As Integer, height As Integer)
		  mWidth = width
		  mHeight = height
		  mDefaultStyle = New XjStyle
		  InitCells
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DiffRender(previous As XjCanvas) As String
		  // Render only the cells that differ from the previous canvas.
		  // Uses parallel arrays directly — no XjCell dereference.

		  If previous Is Nil Then Return Render

		  Var parts() As String

		  // Disable auto-wrap to prevent scroll when writing bottom-right corner
		  parts.Add(XjANSI.AutoWrapDisable)

		  Var lastRow As Integer = -1
		  Var lastCol As Integer = -1
		  Var lastStyle As XjStyle = Nil

		  For row As Integer = 0 To mHeight - 1
		    For col As Integer = 0 To mWidth - 1
		      Var idx As Integer = row * mWidth + col
		      Var curChar As String = mChars(idx)
		      Var curStyle As XjStyle = mStyles(idx)

		      // Check if this cell differs from the previous frame
		      Var changed As Boolean = True
		      If row < previous.mHeight And col < previous.mWidth Then
		        Var prevIdx As Integer = row * previous.mWidth + col
		        Var prevChar As String = previous.mChars(prevIdx)
		        Var prevStyle As XjStyle = previous.mStyles(prevIdx)
		        If curChar = prevChar Then
		          If curStyle Is prevStyle Then
		            changed = False
		          ElseIf curStyle <> Nil And prevStyle <> Nil And curStyle.Equals(prevStyle) Then
		            changed = False
		          End If
		        End If
		      End If

		      If changed Then
		        // Only move cursor if not at expected position
		        If row <> lastRow Or col <> lastCol Then
		          parts.Add(XjANSI.CursorPosition(row + 1, col + 1))
		        End If

		        // Apply style if changed
		        If curStyle Is Nil Then curStyle = mDefaultStyle
		        If lastStyle Is Nil Or (Not (curStyle Is lastStyle) And Not curStyle.Equals(lastStyle)) Then
		          If Not curStyle.IsEmpty Then
		            parts.Add(XjANSI.Reset + curStyle.ToANSI)
		          ElseIf lastStyle <> Nil And Not lastStyle.IsEmpty Then
		            parts.Add(XjANSI.Reset)
		          End If
		          lastStyle = curStyle
		        End If

		        parts.Add(curChar)
		        lastRow = row
		        lastCol = col + 1
		      End If
		    Next
		  Next

		  If parts.Count > 0 Then
		    parts.Add(XjANSI.Reset)
		  End If

		  // Re-enable auto-wrap
		  parts.Add(XjANSI.AutoWrapEnable)

		  Return String.FromArray(parts, "")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DrawBox(x As Integer, y As Integer, w As Integer, h As Integer, style As XjStyle, borderStyle As Integer)
		  // Draw a box border
		  // borderStyle: 0=single, 1=double, 2=round, 3=bold, 4=ascii

		  Var tl, tr, bl, br, horiz, vert As String

		  Select Case borderStyle
		  Case 1
		    // Double line
		    tl = Chr(&h2554)
		    tr = Chr(&h2557)
		    bl = Chr(&h255A)
		    br = Chr(&h255D)
		    horiz = Chr(&h2550)
		    vert = Chr(&h2551)
		  Case 2
		    // Round corners
		    tl = Chr(&h256D)
		    tr = Chr(&h256E)
		    bl = Chr(&h2570)
		    br = Chr(&h256F)
		    horiz = Chr(&h2500)
		    vert = Chr(&h2502)
		  Case 3
		    // Bold/thick
		    tl = Chr(&h250F)
		    tr = Chr(&h2513)
		    bl = Chr(&h2517)
		    br = Chr(&h251B)
		    horiz = Chr(&h2501)
		    vert = Chr(&h2503)
		  Case 4
		    // ASCII
		    tl = "+"
		    tr = "+"
		    bl = "+"
		    br = "+"
		    horiz = "-"
		    vert = "|"
		  Case Else
		    // Single line (default)
		    tl = Chr(&h250C)
		    tr = Chr(&h2510)
		    bl = Chr(&h2514)
		    br = Chr(&h2518)
		    horiz = Chr(&h2500)
		    vert = Chr(&h2502)
		  End Select

		  // Top edge
		  SetCell(x, y, tl, style)
		  For col As Integer = x + 1 To x + w - 2
		    SetCell(col, y, horiz, style)
		  Next
		  SetCell(x + w - 1, y, tr, style)

		  // Sides
		  For row As Integer = y + 1 To y + h - 2
		    SetCell(x, row, vert, style)
		    SetCell(x + w - 1, row, vert, style)
		  Next

		  // Bottom edge
		  SetCell(x, y + h - 1, bl, style)
		  For col As Integer = x + 1 To x + w - 2
		    SetCell(col, y + h - 1, horiz, style)
		  Next
		  SetCell(x + w - 1, y + h - 1, br, style)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DrawHLine(x As Integer, y As Integer, length As Integer, char As String, style As XjStyle)
		  // Draw a horizontal line
		  If char = "" Then char = Chr(&h2500)
		  For i As Integer = 0 To length - 1
		    SetCell(x + i, y, char, style)
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DrawVLine(x As Integer, y As Integer, length As Integer, char As String, style As XjStyle)
		  // Draw a vertical line
		  If char = "" Then char = Chr(&h2502)
		  For i As Integer = 0 To length - 1
		    SetCell(x, y + i, char, style)
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub FillRegion(x As Integer, y As Integer, w As Integer, h As Integer, char As String, style As XjStyle)
		  // Fill a rectangular region with a character and style
		  For row As Integer = y To y + h - 1
		    For col As Integer = x To x + w - 1
		      SetCell(col, row, char, style)
		    Next
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetCell(x As Integer, y As Integer) As XjCell
		  // Get cell at (x, y) — constructs an XjCell from parallel arrays.
		  // Not used in hot render path — only for external inspection.
		  If x < 0 Or x >= mWidth Or y < 0 Or y >= mHeight Then Return New XjCell
		  Var idx As Integer = y * mWidth + x
		  Return New XjCell(mChars(idx), mStyles(idx))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetHeight() As Integer
		  Return mHeight
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetWidth() As Integer
		  Return mWidth
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub InitCells()
		  // Initialize parallel arrays for chars and styles.
		  // Two array allocations instead of 4800 XjCell objects.
		  // This eliminates the heap corruption target on macOS Tahoe.
		  Var total As Integer = mWidth * mHeight
		  ReDim mChars(total - 1)
		  ReDim mStyles(total - 1)
		  For i As Integer = 0 To total - 1
		    mChars(i) = " "
		    mStyles(i) = mDefaultStyle
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Render() As String
		  // Render the entire canvas as an ANSI string.
		  // Reads directly from parallel arrays — no XjCell dereference.
		  // Builds per-row strings to reduce allocation pressure.

		  Var rows() As String
		  Var lastStyle As XjStyle = Nil

		  // Home cursor + clear screen + disable auto-wrap header
		  rows.Add(XjANSI.CursorPosition(1, 1) + XjANSI.CSI + "2J" + XjANSI.AutoWrapDisable)

		  For row As Integer = 0 To mHeight - 1
		    // Build each row as a separate string to limit array growth
		    Var rowParts() As String
		    rowParts.Add(XjANSI.CursorPosition(row + 1, 1))

		    For col As Integer = 0 To mWidth - 1
		      Var idx As Integer = row * mWidth + col
		      Var cellChar As String = mChars(idx)
		      Var cellStyle As XjStyle = mStyles(idx)
		      If cellStyle Is Nil Then cellStyle = mDefaultStyle

		      // Only emit style codes when style changes
		      If lastStyle Is Nil Then
		        If Not cellStyle.IsEmpty Then
		          rowParts.Add(cellStyle.ToANSI)
		        End If
		        lastStyle = cellStyle
		      ElseIf Not (cellStyle Is lastStyle) And Not cellStyle.Equals(lastStyle) Then
		        If Not cellStyle.IsEmpty Then
		          rowParts.Add(XjANSI.Reset + cellStyle.ToANSI)
		        ElseIf Not lastStyle.IsEmpty Then
		          rowParts.Add(XjANSI.Reset)
		        End If
		        lastStyle = cellStyle
		      End If

		      rowParts.Add(cellChar)
		    Next

		    rows.Add(String.FromArray(rowParts, ""))
		  Next

		  // Reset at end and re-enable auto-wrap
		  rows.Add(XjANSI.Reset + XjANSI.AutoWrapEnable)

		  Return String.FromArray(rows, "")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Resize(newWidth As Integer, newHeight As Integer)
		  // Resize the canvas, preserving existing content where possible.
		  // Creates new parallel arrays and copies overlapping region.
		  Var newTotal As Integer = newWidth * newHeight
		  Var newChars() As String
		  Var newStyles() As XjStyle
		  ReDim newChars(newTotal - 1)
		  ReDim newStyles(newTotal - 1)

		  For i As Integer = 0 To newTotal - 1
		    newChars(i) = " "
		    newStyles(i) = mDefaultStyle
		  Next

		  // Copy existing content
		  Var copyW As Integer = If(newWidth < mWidth, newWidth, mWidth)
		  Var copyH As Integer = If(newHeight < mHeight, newHeight, mHeight)

		  For row As Integer = 0 To copyH - 1
		    For col As Integer = 0 To copyW - 1
		      Var oldIdx As Integer = row * mWidth + col
		      Var newIdx As Integer = row * newWidth + col
		      newChars(newIdx) = mChars(oldIdx)
		      newStyles(newIdx) = mStyles(oldIdx)
		    Next
		  Next

		  mWidth = newWidth
		  mHeight = newHeight
		  mChars = newChars
		  mStyles = newStyles
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetCell(x As Integer, y As Integer, char As String, style As XjStyle)
		  // Set a cell at (x, y) — 0-based coordinates.
		  // Direct array writes — no XjCell object involved.
		  If x < 0 Or x >= mWidth Or y < 0 Or y >= mHeight Then Return
		  Var idx As Integer = y * mWidth + x
		  If char = "" Then
		    mChars(idx) = " "
		  Else
		    mChars(idx) = char.Left(1)
		  End If
		  If style Is Nil Then
		    mStyles(idx) = mDefaultStyle
		  Else
		    mStyles(idx) = style
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetChar(x As Integer, y As Integer, char As String)
		  // Set just the character at (x, y) without changing style
		  If x < 0 Or x >= mWidth Or y < 0 Or y >= mHeight Then Return
		  Var idx As Integer = y * mWidth + x
		  If char = "" Then
		    mChars(idx) = " "
		  Else
		    mChars(idx) = char.Left(1)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Snapshot() As XjCanvas
		  // Create a deep copy of this canvas for diff rendering.
		  // Copies parallel arrays — style references are shared (read-only during Render).
		  Var copy As New XjCanvas(mWidth, mHeight)
		  For i As Integer = 0 To mChars.Count - 1
		    copy.mChars(i) = mChars(i)
		    copy.mStyles(i) = mStyles(i)
		  Next
		  Return copy
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString() As String
		  // Render as plain text (no ANSI codes) for debugging
		  Var parts() As String
		  For row As Integer = 0 To mHeight - 1
		    Var rowParts() As String
		    For col As Integer = 0 To mWidth - 1
		      rowParts.Add(mChars(row * mWidth + col))
		    Next
		    parts.Add(String.FromArray(rowParts, ""))
		  Next
		  Return String.FromArray(parts, EndOfLine)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteText(x As Integer, y As Integer, text As String, style As XjStyle)
		  // Write a string horizontally starting at (x, y)
		  For i As Integer = 0 To text.Length - 1
		    Var cx As Integer = x + i
		    If cx >= mWidth Then Exit
		    SetCell(cx, y, text.Middle(i, 1), style)
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteTextWrapped(x As Integer, y As Integer, maxWidth As Integer, text As String, style As XjStyle)
		  // Write text with word wrapping within maxWidth
		  Var col As Integer = x
		  Var row As Integer = y
		  Var words() As String = text.Split(" ")

		  For w As Integer = 0 To words.Count - 1
		    Var word As String = words(w)

		    // Check if word fits on current line
		    If col > x And (col + word.Length) > (x + maxWidth) Then
		      col = x
		      row = row + 1
		      If row >= mHeight Then Return
		    End If

		    // Write the word
		    For i As Integer = 0 To word.Length - 1
		      If col >= x + maxWidth Then
		        col = x
		        row = row + 1
		        If row >= mHeight Then Return
		      End If
		      SetCell(col, row, word.Middle(i, 1), style)
		      col = col + 1
		    Next

		    // Add space after word (if not at end)
		    If w < words.Count - 1 And col < x + maxWidth Then
		      SetCell(col, row, " ", style)
		      col = col + 1
		    End If
		  Next
		End Sub
	#tag EndMethod


	#tag Note, Name = "About"
		XjCanvas — 2D Character Render Buffer

		Part of XjTTY-Toolkit foundation layer.
		Uses PARALLEL ARRAYS (mChars + mStyles) instead of XjCell objects
		to avoid heap corruption on macOS Tahoe's xzone malloc. The previous
		approach of 4800 small XjCell objects was a fragile corruption target.

		Key features:
		- Cell-level character and style control via parallel arrays
		- Text writing with optional word wrap
		- Box drawing (single, double, round, bold, ASCII)
		- Region operations: clear, fill, blit
		- Full render: outputs complete ANSI for entire canvas
		- Diff render: outputs only changed cells (efficient updates)
		- Snapshot for frame-to-frame comparison
		- Optimized style tracking to minimize escape codes

		Coordinates are 0-based (x=column, y=row).
		The canvas is the foundation for all higher-level TUI
		widgets and layout in XjTTY-Toolkit.
	#tag EndNote


	#tag Property, Flags = &h21
		Private mChars() As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mDefaultStyle As XjStyle
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mHeight As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mStyles() As XjStyle
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mWidth As Integer
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
