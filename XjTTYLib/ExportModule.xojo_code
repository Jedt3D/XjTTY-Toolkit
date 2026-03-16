#tag Module
Protected Module ExportModule
	#tag Method, Flags = &h0
		Function BuildOutputPath(baseName As String, ext As String) As String
		  Var dir As FolderItem = EnsureExportsDir
		  If dir Is Nil Then Return ""
		  
		  // Date stamp: YYYY-MM-DD
		  Var now As DateTime = DateTime.Now
		  Var dateStr As String = Format(now.Year, "0000") + "-" + Format(now.Month, "00") + "-" + Format(now.Day, "00")
		  
		  Var fileName As String = baseName + "_" + dateStr + "." + ext
		  Return dir.Child(fileName).NativePath
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function CSVQuote(s As String) As String
		  // RFC 4180: quote if contains comma, newline, or double quote
		  If s.IndexOf(",") >= 0 Or s.IndexOf(EndOfLine) >= 0 Or s.IndexOf("""") >= 0 Then
		    Return """" + s.ReplaceAll("""", """""") + """"
		  End If
		  Return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function EnsureExportsDir() As FolderItem
		  Var appFolder As FolderItem = App.ExecutableFile.Parent
		  If appFolder Is Nil Then Return Nil
		  
		  Var exportsDir As FolderItem = appFolder.Child("exports")
		  If Not exportsDir.Exists Then
		    exportsDir.CreateAsFolder
		  End If
		  
		  If exportsDir.Exists Then Return exportsDir
		  Return Nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ExportCSV(db As DBManager, tableName As String, outputPath As String) As Boolean
		  If Not db.IsOpen Then Return False
		  If outputPath = "" Then Return False
		  
		  Try
		    Var fi As New FolderItem(outputPath, FolderItem.PathModes.Native)
		    Var stream As TextOutputStream = TextOutputStream.Create(fi)
		    If stream Is Nil Then Return False
		    stream.Encoding = Encodings.UTF8
		    
		    Var rowCount As Integer = db.TableRowCount(tableName)
		    Var offset As Integer = 0
		    Var batchSize As Integer = 500
		    Var headerWritten As Boolean = False
		    
		    While offset < rowCount Or Not headerWritten
		      Var rs As RowSet = db.QueryPage(tableName, offset, batchSize)
		      If rs Is Nil Then Exit
		      
		      // Write header from first batch
		      If Not headerWritten Then
		        Var headers() As String
		        Var ci As Integer = 0
		        While ci < rs.ColumnCount
		          headers.Add(CSVQuote(rs.ColumnAt(ci).Name))
		          ci = ci + 1
		        Wend
		        stream.WriteLine(String.FromArray(headers, ","))
		        headerWritten = True
		        If rs.AfterLastRow Then
		          rs.Close
		          Exit
		        End If
		      End If
		      
		      // Write rows
		      While Not rs.AfterLastRow
		        Var values() As String
		        Var ci As Integer = 0
		        While ci < rs.ColumnCount
		          values.Add(CSVQuote(rs.ColumnAt(ci).StringValue))
		          ci = ci + 1
		        Wend
		        stream.WriteLine(String.FromArray(values, ","))
		        rs.MoveToNextRow
		        App.DoEvents(0)
		      Wend
		      rs.Close
		      
		      offset = offset + batchSize
		      If offset >= rowCount Then Exit
		    Wend
		    
		    stream.Close
		    Return True
		  Catch e As IOException
		    Return False
		  Catch e As DatabaseException
		    Return False
		  End Try
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ExportJSON(db As DBManager, tableName As String, outputPath As String) As Boolean
		  If Not db.IsOpen Then Return False
		  If outputPath = "" Then Return False
		  
		  Try
		    Var fi As New FolderItem(outputPath, FolderItem.PathModes.Native)
		    Var stream As TextOutputStream = TextOutputStream.Create(fi)
		    If stream Is Nil Then Return False
		    stream.Encoding = Encodings.UTF8
		    
		    stream.Write("[")
		    
		    Var rowCount As Integer = db.TableRowCount(tableName)
		    Var offset As Integer = 0
		    Var batchSize As Integer = 500
		    Var totalWritten As Integer = 0
		    Var columnNames() As String
		    Var headerLoaded As Boolean = False
		    
		    While offset < rowCount
		      Var rs As RowSet = db.QueryPage(tableName, offset, batchSize)
		      If rs Is Nil Then Exit
		      
		      If Not headerLoaded Then
		        Var ci As Integer = 0
		        While ci < rs.ColumnCount
		          columnNames.Add(rs.ColumnAt(ci).Name)
		          ci = ci + 1
		        Wend
		        headerLoaded = True
		      End If
		      
		      While Not rs.AfterLastRow
		        If totalWritten > 0 Then stream.Write(",")
		        stream.Write(EndOfLine + "  {")
		        
		        Var ci As Integer = 0
		        While ci < rs.ColumnCount
		          If ci > 0 Then stream.Write(",")
		          Var key As String = JSONEscape(columnNames(ci))
		          Var val As String = rs.ColumnAt(ci).StringValue
		          
		          // Try numeric detection
		          Var numVal As Double = Val(val)
		          Var isNumeric As Boolean = (val <> "" And Str(numVal) = val)
		          
		          If isNumeric Then
		            stream.Write(EndOfLine + "    """ + key + """: " + val)
		          Else
		            stream.Write(EndOfLine + "    """ + key + """: """ + JSONEscape(val) + """")
		          End If
		          ci = ci + 1
		        Wend
		        
		        stream.Write(EndOfLine + "  }")
		        totalWritten = totalWritten + 1
		        rs.MoveToNextRow
		        App.DoEvents(0)
		      Wend
		      rs.Close
		      
		      offset = offset + batchSize
		    Wend
		    
		    stream.Write(EndOfLine + "]" + EndOfLine)
		    stream.Close
		    Return True
		  Catch e As IOException
		    Return False
		  Catch e As DatabaseException
		    Return False
		  End Try
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ExportSQL(db As DBManager, scope As Integer, tableName As String, outputPath As String) As Boolean
		  // scope: 0=full DB, 1=single table
		  If Not db.IsOpen Then Return False
		  If outputPath = "" Then Return False
		  
		  Try
		    Var fi As New FolderItem(outputPath, FolderItem.PathModes.Native)
		    Var stream As TextOutputStream = TextOutputStream.Create(fi)
		    If stream Is Nil Then Return False
		    stream.Encoding = Encodings.UTF8
		    
		    stream.WriteLine("-- XjTTY SQLite Backup Export")
		    stream.WriteLine("-- Generated: " + DateTime.Now.ToString)
		    stream.WriteLine("-- Database: " + db.DatabaseFileName)
		    stream.WriteLine("")
		    
		    Var tables() As String
		    If scope = 0 Then
		      tables = db.ListTables
		    Else
		      tables.Add(tableName)
		    End If
		    
		    For i As Integer = 0 To tables.Count - 1
		      Var tbl As String = tables(i)
		      stream.WriteLine("-- Table: " + tbl)
		      
		      // CREATE TABLE
		      Var createSQL As String = GetCreateSQL(db, tbl)
		      If createSQL <> "" Then
		        stream.WriteLine(createSQL + ";")
		        stream.WriteLine("")
		      End If
		      
		      // INSERT rows in batches
		      Var rowCount As Integer = db.TableRowCount(tbl)
		      Var offset As Integer = 0
		      Var batchSize As Integer = 500
		      
		      While offset < rowCount
		        Var rs As RowSet = db.QueryPage(tbl, offset, batchSize)
		        If rs Is Nil Then Exit
		        
		        While Not rs.AfterLastRow
		          Var values() As String
		          Var ci As Integer = 0
		          While ci < rs.ColumnCount
		            Var val As String = rs.ColumnAt(ci).StringValue
		            // Escape single quotes
		            val = val.ReplaceAll("'", "''")
		            values.Add("'" + val + "'")
		            ci = ci + 1
		          Wend
		          stream.WriteLine("INSERT OR IGNORE INTO """ + tbl + """ VALUES (" + String.FromArray(values, ", ") + ");")
		          rs.MoveToNextRow
		          App.DoEvents(0)
		        Wend
		        rs.Close
		        
		        offset = offset + batchSize
		      Wend
		      
		      stream.WriteLine("")
		    Next
		    
		    stream.Close
		    Return True
		  Catch e As IOException
		    Return False
		  Catch e As DatabaseException
		    Return False
		  End Try
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetCreateSQL(db As DBManager, tableName As String) As String
		  // Get CREATE TABLE statement from sqlite_master
		  If Not db.IsOpen Then Return ""
		  
		  // We need access to the underlying DB - use a workaround via DBManager exposed method
		  // Since DBManager.mDB is private, reconstruct from PRAGMA
		  Var rs As RowSet = db.TableColumnInfo(tableName)
		  If rs Is Nil Then Return ""
		  
		  Var cols() As String
		  While Not rs.AfterLastRow
		    Var colName As String = rs.Column("name").StringValue
		    Var colType As String = rs.Column("type").StringValue
		    Var notNull As Boolean = rs.Column("notnull").IntegerValue > 0
		    Var pk As Boolean = rs.Column("pk").IntegerValue > 0
		    Var dflt As String = rs.Column("dflt_value").StringValue
		    
		    Var colDef As String = "  """ + colName + """ " + colType
		    If notNull Then colDef = colDef + " NOT NULL"
		    If pk Then colDef = colDef + " PRIMARY KEY"
		    If dflt <> "" Then colDef = colDef + " DEFAULT " + dflt
		    cols.Add(colDef)
		    rs.MoveToNextRow
		  Wend
		  rs.Close
		  
		  Return "CREATE TABLE IF NOT EXISTS """ + tableName + """ (" + EndOfLine + String.FromArray(cols, "," + EndOfLine) + EndOfLine + ")"
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function JSONEscape(s As String) As String
		  Var result As String = s
		  result = result.ReplaceAll("\", "\\")
		  result = result.ReplaceAll("""", "\""")
		  result = result.ReplaceAll(Chr(10), "\n")
		  result = result.ReplaceAll(Chr(13), "\r")
		  result = result.ReplaceAll(Chr(9), "\t")
		  Return result
		End Function
	#tag EndMethod


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
