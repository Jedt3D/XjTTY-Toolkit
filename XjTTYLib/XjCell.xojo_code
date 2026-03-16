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
		  mChar = " "
		  mStyle = New XjStyle
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(char As String, style As XjStyle)
		  If char = "" Then
		    mChar = " "
		  Else
		    mChar = char.Left(1)
		  End If
		  If style Is Nil Then
		    mStyle = New XjStyle
		  Else
		    mStyle = style.Clone
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
		  // Reuses the existing XjStyle object to avoid allocation pressure.
		  // Previously created a New XjStyle per call — at 4800 cells × 30fps
		  // that was 144,000 allocations/second, causing heap corruption on macOS Tahoe.
		  mChar = " "
		  If mStyle Is Nil Then
		    mStyle = New XjStyle
		  Else
		    mStyle.ResetToDefault()
		  End If
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
		  // Copy style properties in-place instead of cloning.
		  // Avoids allocating a new XjStyle for every SetCell call during Paint.
		  If s Is Nil Then
		    If mStyle Is Nil Then
		      mStyle = New XjStyle
		    Else
		      mStyle.ResetToDefault()
		    End If
		  Else
		    If mStyle Is Nil Then
		      mStyle = s.Clone
		    Else
		      mStyle.CopyFrom(s)
		    End If
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
