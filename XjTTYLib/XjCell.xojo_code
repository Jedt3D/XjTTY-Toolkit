#tag Class
Protected Class XjCell
	#tag Method, Flags = &h0
		Function Char() As String
		  Return mChar
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Clone() As XjCell
		  Return New XjCell(mChar, mStyle)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  // Share a single default style across all cells to minimize allocations.
		  // During Paint, each cell's mStyle gets replaced with the widget's style ref.
		  mChar = " "
		  Static defaultStyle As XjStyle
		  If defaultStyle Is Nil Then defaultStyle = New XjStyle
		  mStyle = defaultStyle
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(char As String, style As XjStyle)
		  If char = "" Then
		    mChar = " "
		  Else
		    mChar = char.Left(1)
		  End If
		  // Share source style reference — no Clone allocation needed.
		  If style Is Nil Then
		    Static defaultStyle As XjStyle
		    If defaultStyle Is Nil Then defaultStyle = New XjStyle
		    mStyle = defaultStyle
		  Else
		    mStyle = style
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Equals(other As XjCell) As Boolean
		  If other Is Nil Then Return False
		  Return mChar = other.mChar And mStyle.Equals(other.mStyle)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Render() As String
		  // Render this cell as an ANSI string
		  If mStyle.IsEmpty Then Return mChar
		  Return mStyle.ToANSI + mChar + XjANSI.Reset
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Reset()
		  // Reset to empty space with default style.
		  // NEVER dereferences mStyle — always replaces it — because macOS Tahoe's
		  // xzone malloc can corrupt the mStyle pointer, making any method call on it
		  // (ResetToDefault, CopyFrom) crash with SIGSEGV.
		  // Uses a shared default instance to avoid per-call allocation.
		  mChar = " "
		  Static defaultStyle As XjStyle
		  If defaultStyle Is Nil Then defaultStyle = New XjStyle
		  mStyle = defaultStyle
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Set(char As String, style As XjStyle)
		  SetChar(char)
		  SetStyle(style)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetChar(c As String)
		  If c = "" Then
		    mChar = " "
		  Else
		    mChar = c.Left(1)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetStyle(s As XjStyle)
		  // NEVER dereferences mStyle — always replaces it — because macOS Tahoe's
		  // xzone malloc can corrupt the mStyle pointer, making any method call on it
		  // (CopyFrom, ResetToDefault) crash with SIGSEGV.
		  // Shares the source style reference directly instead of cloning. This is safe
		  // because Paint passes the same style object for many cells (e.g., border color),
		  // and cells only need to READ styles during Render(). No per-cell allocation.
		  If s Is Nil Then
		    Static defaultStyle As XjStyle
		    If defaultStyle Is Nil Then defaultStyle = New XjStyle
		    mStyle = defaultStyle
		  Else
		    mStyle = s
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Style() As XjStyle
		  Return mStyle
		End Function
	#tag EndMethod


	#tag Note, Name = "About"
		XjCell — Single Character Cell
		
		Part of XjTTY-Toolkit foundation layer.
		Represents a single character position in the terminal
		with associated style information. Used by XjCanvas.
	#tag EndNote


	#tag Property, Flags = &h21
		Private mChar As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mStyle As XjStyle
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
