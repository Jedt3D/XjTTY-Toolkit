#tag Module
Protected Module ThemeModule
	#tag Method, Flags = &h0
		Function Accent() As XjStyle
		  Var s As New XjStyle
		  Return s.SetFG(XjANSI.FG_CYAN)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function AccentBold() As XjStyle
		  Var s As New XjStyle
		  Return s.SetFG(XjANSI.FG_BRIGHT_CYAN).SetBold
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function AltRow() As XjStyle
		  Var s As New XjStyle
		  Return s.SetFG(XjANSI.FG_WHITE).SetDim
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Border() As XjStyle
		  Var s As New XjStyle
		  Return s.SetFG(XjANSI.FG_BRIGHT_BLACK)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function BorderFocused() As XjStyle
		  Var s As New XjStyle
		  Return s.SetFG(XjANSI.FG_CYAN)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Error_() As XjStyle
		  Var s As New XjStyle
		  Return s.SetFG(XjANSI.FG_BRIGHT_RED)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Header() As XjStyle
		  Var s As New XjStyle
		  Return s.SetFG(XjANSI.FG_BRIGHT_WHITE).SetBold
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HintKey() As XjStyle
		  Var s As New XjStyle
		  Return s.SetFG(XjANSI.FG_BRIGHT_CYAN).SetBold
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HintText() As XjStyle
		  Var s As New XjStyle
		  Return s.SetFG(XjANSI.FG_BRIGHT_BLACK)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Muted() As XjStyle
		  Var s As New XjStyle
		  Return s.SetFG(XjANSI.FG_BRIGHT_BLACK)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Normal() As XjStyle
		  Var s As New XjStyle
		  Return s.SetFG(XjANSI.FG_WHITE)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PadRight(s As String, width As Integer) As String
		  If s.Length >= width Then Return s.Left(width)
		  Var parts() As String
		  parts.Add(s)
		  Var i As Integer = s.Length
		  While i < width
		    parts.Add(" ")
		    i = i + 1
		  Wend
		  Return String.FromArray(parts, "")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Selected() As XjStyle
		  Var s As New XjStyle
		  Return s.SetFG(XjANSI.FG_BLACK).SetBG(XjANSI.BG_CYAN)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Success() As XjStyle
		  Var s As New XjStyle
		  Return s.SetFG(XjANSI.FG_BRIGHT_GREEN)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function TitleBar() As XjStyle
		  Var s As New XjStyle
		  Return s.SetFG(XjANSI.FG_BLACK).SetBG(XjANSI.BG_CYAN)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function TitleBarBreadcrumb() As XjStyle
		  Var s As New XjStyle
		  Return s.SetFG(XjANSI.FG_BRIGHT_BLACK).SetBG(XjANSI.BG_CYAN)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Truncate(s As String, maxLen As Integer) As String
		  If s.Length <= maxLen Then Return s
		  If maxLen <= 1 Then Return s.Left(maxLen)
		  Return s.Left(maxLen - 1) + Chr(&h2026)  // ellipsis
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Warning() As XjStyle
		  Var s As New XjStyle
		  Return s.SetFG(XjANSI.FG_BRIGHT_YELLOW)
		End Function
	#tag EndMethod


	#tag Constant, Name = kVersion, Type = String, Dynamic = False, Default = \"1.0.0", Scope = Public
	#tag EndConstant


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
End Module
#tag EndModule
