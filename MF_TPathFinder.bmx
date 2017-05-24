



Type MF_TPathfinder
	Field _startX:Int, _startY:Int
	Field _endX:Int, _endY:Int
	Field _mapData:Byte[,]
	Field _BFS:TBFS
	Field _allowDiagonals:Byte
	Field _pathList:TList

	
	Function Create:MF_TPathfinder(startX:Int, startY:Int, endX:Int, endY:Int, mapW:Int, mapH:Int, allowDiagonals:Byte)
		Local pf:MF_TPathfinder = New MF_TPathfinder
		pf._startX = startX
		pf._startY = startY
		pf._endX = endX
		pf._endY = endY
		pf._mapData = New Byte[mapW, mapH]
		pf._BFS = New TBFS.Create(pf._mapData)
		pf._allowDiagonals = allowDiagonals
		pf._pathList = New TList
		Return pf
	End Function
	
	Method Search()
		Local node:TBFSNode = Self._BFS.Search(Self._startX, Self._startY, Self._endX, Self._endY, Self._allowDiagonals, layer)
		While node
			Self._pathList.AddFirst node
			node = node._pred
		Wend
	End Method

	
	Method GetNextTile(tileX:Int Var, tileY:Int Var)
		For Local nextTile:TBFSNode = EachIn Self._pathList
			tileX = nextTile._x
			tileY = nextTile._y
			Self._pathList.RemoveFirst()
		Next
	End Method

End Type



Extern
	Function Memset(Dest:Byte Ptr, Value:Int, Count:Int) = "memset"
EndExtern


Type TBFS
	Field _workList:TList
	
	Field _mapW:Int
	Field _mapH:Int
	
	Field _mapData:Byte[,]
	Field _visited:Byte[,]
	
	
	Method Create:TBFS(mapData:Byte[,])
		Self._workList = New TList
		
		Self._mapData = mapData
		
		Local dimensions:Int[] = Self._mapData.Dimensions()
		Self._mapW = dimensions[0]
		Self._mapH = dimensions[1]
		
		Self._visited = New Byte[Self._mapW, Self._mapH]
		
		Return Self
	End Method
	
	
	Method Search:TBFSNode(startX:Int, startY:Int, endX:Int, endY:Int, allowDiagonals:Byte, layer:MF_TLayer)
		Memset(Varptr Self._visited[0, 0], 0, Self._mapW * Self._mapH)
		Self._workList.Clear()
		
		Self._visited[startX, startY] = True
		Self._workList.AddLast(New TBFSNode.Create(startX, startY, Null))
		
		Local dirX:Int[] = [- 1, 0, 1, 0, -1, -1, 1, 1]
		Local dirY:Int[] = [0, 1, 0, -1, -1, 1, -1, 1]
		
		While Not Self._workList.IsEmpty()
			Local node:TBFSNode = TBFSNode(Self._workList.RemoveFirst())
			
			If node._x = endX And node._y = endY Then Return node
			
			For Local i:Int = 0 Until 4 + 4 * allowDiagonals
				Local x:Int = node._x + dirX[i]
				Local y:Int = node._y + dirY[i]
				
				If x >= 0 And y >= 0 And x < Self._mapW And y < Self._mapH And Not Self._mapData[x, y] And Not Self._visited[x, y] And layer.GetTileWalkable(x, y) = 1 Then
					Self._workList.AddLast(New TBFSNode.Create(x, y, node))
					Self._visited[x, y] = True
				EndIf
			Next
		Wend
		
		Return Null
	End Method
End Type


Type TBFSNode
	Field _x:Int
	Field _y:Int
	Field _pred:TBFSNode
	
	Method Create:TBFSNode(x:Int, y:Int, pred:TBFSNode)
		Self._x = x
		Self._y = y
		Self._pred = pred
		
		Return Self
	End Method
End Type