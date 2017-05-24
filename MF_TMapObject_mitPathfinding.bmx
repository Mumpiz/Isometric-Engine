Private
Global MF_List_MapObjectsOnScreen:TList = New TList
Global MF_List_MapObjects:TList = New TList


Public
Type MF_TMapObject
	Field _x:Int, _y:Int
	Field _nextTileX:Int = 0, _nextTileY:Int = 0, _needNextTile:Byte = 0
	Field _pf:MF_TPathfinder, _needNewPath:Byte = 1
	
	Method New() Final
		MF_List_MapObjects.AddLast Self
	End Method
	
	Method Draw() Abstract
	
	Method Update() Abstract
	
	
	Method DrawEx() Final
		Draw()	
	End Method
	

	Method UpdateEx() Final
		Update()
	End Method
	
	
	Rem
		bbdoc: Setzt ein Objekt auf ein angegebenes Tile. tileX, tileY sind die index Nummern des TileArrays!
	End Rem
	Method PutToTile(tileX:Int, tileY:Int) Final
		If tileY Mod 2
			Self._x = ((tileX + 1) * MF_TILE_WIDTH)
		Else
			Self._x = ((tileX + 1) * MF_TILE_WIDTH) - (MF_TILE_WIDTH / 2)
		End If
		Self._y = (tileY + 1) * (MF_GROUND_LAYER_TILEHEIGHT - (MF_TILE_GROUND_HEIGHT / 2))
	End Method
	
	
	Method Translate(x:Int, y:Int) Final
		Self._x = Self._x + x
		Self._y = Self._y + y
	End Method
	
	
	Method MoveToTile(tileX:Int, tileY:Int, speed:Int, layer:MF_TLayer)
		Local objIsoX:Int = MF_GetIsoX(Self._x, Self._y)
		Local objIsoY:Int = MF_GetIsoY(Self._x, Self._y)
		Local pixelX:Int
		Local pixelY:Int
		
		
			If (tileX >= 0 And tileX <= MF_MAP_WIDTH) And (tileY >= 0 And tileY <= MF_MAP_HEIGHT)
				
			If Self._needNewPath = 1
				Self._pf = MF_TPathfinder.Create(objIsoX, objIsoY, tileX, tileY, MF_MAP_WIDTH, MF_MAP_HEIGHT, 0)
				Self._pf.Search(layer)
				Self._pf.GetNextTile(Self._nextTileX, Self._nextTileY)
				Self._needNewPath = 0
			End If
			
			If (tileX = objIsoX And tileY = objIsoY)
				Self._needNewPath = 1
			End If
			
			If Self._needNextTile = 1
				Self._pf.GetNextTile(Self._nextTileX, Self._nextTileY)
				Self._needNextTile = 0
			End If
			
			If Self._nextTileX = objIsoX And Self._nextTileY = objIsoY
				Self._needNextTile = 1
			End If
			
			pixelX = MF_GetPixelX(Self._nextTileX, Self._nextTileY)
			pixelY = MF_GetPixelY(Self._nextTileX, Self._nextTileY)
		
			Local angle:Float = MF_GetPointAngle(Self._x, Self._y, pixelX, pixelY)
			Self._x = Self._x + (speed * Cos(angle))
    		Self._y = Self._y + (speed * Sin(angle))
			
			If layer.GetTileMaterial(Self._nextTileX, Self._nextTileY) = 1
				layer.SetTileMaterial(Self._nextTileX, Self._nextTileY, 2)
			Else
				layer.SetTileMaterial(Self._nextTileX, Self._nextTileY, 1)
			End If
			
			DrawText "obj " + objIsoX + " | " + objIsoY, 0, 100
			DrawText "next " + Self._nextTileX + " | " + Self._nextTileY, 0, 120
			DrawText "target " + tileX + " | " + tileY, 0, 140
			
		End If
		
	End Method
	

	Method GetX:Int()
		Return Self._x
	End Method
	
	
	Method GetY:Int()
		Return Self._y
	End Method
	

	Method SetX:Int(x:Int)
		Self._x = x
	End Method
	
	
	Method SetY:Int(y:Int)
		Self._y = y
	End Method

	
End Type



Function MF_FindPath()
	
End Function



Function MF_SortTileCostArray(array:Int[,] Var)
	Local tmp0:Int = 0
	Local tmp1:Int = 0
	Local swap:Int = 0
	Local depht:Int = 0
	Repeat
		swap = 0
		For Local i:Int = 0 To 3 - 1 - depht
			If array[i, 0] > array[i + 1, 0]
				tmp0 = array[i, 0]
				tmp1 = array[i, 1]
				array[i, 0] = array[i + 1, 0]
				array[i, 1] = array[i + 1, 1]
				array[i + 1, 0] = tmp0
				array[i + 1, 1] = tmp1
				swap = 1
			End If
		Next
		depht = depht + 1
	Until swap = 0
End Function


Function MF_FindNextFreeNearestTile(objIsoX:Int, objIsoY:Int, nextTileX:Int Var, nextTileY:Int Var, targetTileX:Int, targetTileY:Int, layer:MF_TLayer)
	If ((nextTileX = objIsoX) And (nextTileY = objIsoY))
	Local tileCost:Int[4, 2]
	'Tile "UpRight"
	tileCost[0, 0] = Abs((objIsoX + objIsoY - 1) - (targetTileX + targetTileY))
	tileCost[0, 1] = 0
	
	'Tile "DownRight"
	tileCost[1, 0] = Abs((objIsoX + 1 + objIsoY + 1) - (targetTileX + targetTileY))
	tileCost[1, 1] = 1
	
	'Tile "DownLeft"
	tileCost[2, 0] = Abs((objIsoX - 1 + objIsoY + 1) - (targetTileX + targetTileY))
	tileCost[2, 1] = 2
	
	'Tile "UpLeft"
	tileCost[3, 0] = Abs((objIsoX - 1 + objIsoY - 1) - (targetTileX + targetTileY))
	tileCost[3, 1] = 3
	
	
	MF_SortTileCostArray(tileCost)
	
	For Local j:Int = 0 To 3
		DrawText tileCost[j, 1] + "  " + tileCost[j, 0], 0, 160 + (20 * j)
	Next
	
	For Local i:Int = 0 To 3
	
	Select tileCost[i, 1]
		'Tile "UpRight"
		Case 0
			If MF_ObjectCanMove:Byte(objIsoX, objIsoY, "UpRight", layer) = 1
				nextTileX = objIsoX
				nextTileY = objIsoY - 1
				Exit
			Else
				Continue
			EndIf
			
		'Tile "DownRight"
		Case 1
			If MF_ObjectCanMove:Byte(objIsoX, objIsoY, "DownRight", layer) = 1
				nextTileX = objIsoX + 1
				nextTileY = objIsoY + 1
				Exit
			Else
				Continue
			End If
			
		'Tile "DownLeft"
		Case 2
			If MF_ObjectCanMove:Byte(objIsoX, objIsoY, "DownLeft", layer) = 1
				nextTileX = objIsoX - 1
				nextTileY = objIsoY + 1
				Exit
			Else
				Continue
			End If
			
		'Tile "UpLeft"
		Case 3
			If MF_ObjectCanMove:Byte(objIsoX, objIsoY, "UpLeft", layer) = 1
				nextTileX = objIsoX - 1
				nextTileY = objIsoY - 1
				Exit
			Else
				Continue
			End If
			
	End Select
	Next
	End If
End Function


Function MF_ObjectCanMove:Byte(objIsoX:Int, objIsoY:Int, direction:String, layer:MF_TLayer, moveThroughDiagonals:Byte = 0, notedFlags:Byte = 1)
	Select direction
		Case "Up"
			If MF_GetTileRelativToObjectWalkable(objIsoX, objIsoY, "UpLeft", layer) = 1
				If MF_GetTileRelativToObjectWalkable(objIsoX, objIsoY, "Up", layer) = 1
					If MF_GetTileRelativToObjectWalkable(objIsoX, objIsoY, "UpRight", layer) = 1
						Return 1	
					End If
				End If
			End If
			
		Case "UpRight"
			If MF_GetTileRelativToObjectWalkable(objIsoX, objIsoY, "Up", layer) = 1
				If MF_GetTileRelativToObjectWalkable(objIsoX, objIsoY, "UpRight", layer) = 1
					If MF_GetTileRelativToObjectWalkable(objIsoX, objIsoY, "Right", layer) = 1
						Return 1
					End If
				End If
			End If
		
		Case "Right"
			If MF_GetTileRelativToObjectWalkable(objIsoX, objIsoY, "UpRight", layer) = 1
				If MF_GetTileRelativToObjectWalkable(objIsoX, objIsoY, "Right", layer) = 1
					If MF_GetTileRelativToObjectWalkable(objIsoX, objIsoY, "DownRight", layer) = 1
						Return 1
					End If
				End If
			End If
			
		Case "DownRight"
			If MF_GetTileRelativToObjectWalkable(objIsoX, objIsoY, "Right", layer) = 1
				If MF_GetTileRelativToObjectWalkable(objIsoX, objIsoY, "DownRight", layer) = 1
					If MF_GetTileRelativToObjectWalkable(objIsoX, objIsoY, "Down", layer) = 1
						Return 1
					End If
				End If
			End If
		
		Case "Down"
			If MF_GetTileRelativToObjectWalkable(objIsoX, objIsoY, "DownRight", layer) = 1
				If MF_GetTileRelativToObjectWalkable(objIsoX, objIsoY, "Down", layer) = 1
					If MF_GetTileRelativToObjectWalkable(objIsoX, objIsoY, "DownLeft", layer) = 1
						Return 1
					End If
				End If
			End If
		
		Case "DownLeft"
			If MF_GetTileRelativToObjectWalkable(objIsoX, objIsoY, "Down", layer) = 1
				If MF_GetTileRelativToObjectWalkable(objIsoX, objIsoY, "DownLeft", layer) = 1
					If MF_GetTileRelativToObjectWalkable(objIsoX, objIsoY, "Left", layer) = 1
						Return 1
					End If
				End If
			End If
		
		Case "Left"
			If MF_GetTileRelativToObjectWalkable(objIsoX, objIsoY, "DownLeft", layer) = 1
				If MF_GetTileRelativToObjectWalkable(objIsoX, objIsoY, "Left", layer) = 1
					If MF_GetTileRelativToObjectWalkable(objIsoX, objIsoY, "UpLeft", layer) = 1
						Return 1
					End If
				End If
			End If
		
		Case "UpLeft"
			If MF_GetTileRelativToObjectWalkable(objIsoX, objIsoY, "Left", layer) = 1
				If MF_GetTileRelativToObjectWalkable(objIsoX, objIsoY, "UpLeft", layer) = 1
					If MF_GetTileRelativToObjectWalkable(objIsoX, objIsoY, "Up", layer) = 1
						Return 1
					End If
				End If
			End If
		
	End Select
End Function



Rem
	bbdoc: Gibt das Flag Walkable des benachbarten Tiles zurück.
	about: Welches Tile, ist abhängig von der Objektposition (objX:Int, objY:Int) und der angegebenen Richtung (direction
	"Up" "UpRight" "Right" "DownRight" "Down" "DownLeft" "Left" und "UpLeft" )
	return: flag Walkable des angebenen Tiles
End Rem
Function MF_GetTileRelativToObjectWalkable:Byte(objIsoX:Int, objIsoY:Int, direction:String, layer:MF_TLayer)
	
	If (objIsoX >= 0 And objIsoX <= MF_MAP_WIDTH) And (objIsoY >= 0 And objIsoY <= MF_MAP_HEIGHT)
		Select direction
			Case "Up"
				' Existiert ein Tile über dem Objekt?
				If objIsoY - 2 >= 0 And objIsoY <= MF_MAP_HEIGHT
					' Ja, dann gib Flag walkable zurück
					Return layer.GetTileWalkable(objIsoX, objIsoY - 2)
				End If
				
			Case "UpRight"
				' Existiert ein Tile schräg rechts über dem Objekt?
				If objIsoY - 1 >= 0 And objIsoY <= MF_MAP_HEIGHT
					' Ja, dann gib Flag walkable zurück
					Return layer.GetTileWalkable(objIsoX, objIsoY - 1)
				End If
				
			Case "Right"
				' Existiert ein Tile rechts neben dem Objekt?
				If objIsoX + 1 >= 0 And objIsoX <= MF_MAP_WIDTH
					' Ja, dann gib Flag walkable zurück
					Return layer.GetTileWalkable(objIsoX + 1, objIsoY)
				End If
				
			Case "DownRight"
				' Existiert ein Tile schräg rechts unter dem Objekt?
				If (objIsoY + 1 >= 0 And objIsoY <= MF_MAP_HEIGHT) And (objIsoX + 1 >= 0 And objIsoX <= MF_MAP_WIDTH)
					' Ja, dann gib Flag walkable zurück
					Return layer.GetTileWalkable(objIsoX + 1, objIsoY + 1)
				End If
				
			Case "Down"
				' Existiert ein Tile unter dem Objekt?
				If objIsoY + 2 >= 0 And objIsoY <= MF_MAP_HEIGHT
					' Ja, dann gib Flag walkable zurück
					Return layer.GetTileWalkable(objIsoX, objIsoY + 2)
				End If
				
			Case "DownLeft"
				' Existiert ein Tile schräg links unter dem Objekt?
				If (objIsoY + 1 >= 0 And objIsoY <= MF_MAP_HEIGHT) And (objIsoX - 1 >= 0 And objIsoX <= MF_MAP_WIDTH)
					' Ja, dann gib Flag walkable zurück
					Return layer.GetTileWalkable(objIsoX - 1, objIsoY + 1)
				End If
				
			Case "Left"
				' Existiert ein Tile links neben dem Objekt?
				If objIsoX - 1 >= 0 And objIsoX <= MF_MAP_WIDTH
					' Ja, dann gib Flag walkable zurück
					Return layer.GetTileWalkable(objIsoX - 1, objIsoY)
				End If
				
			Case "UpLeft"
				' Existiert ein Tile schräg links über dem Objekt?
				If (objIsoY - 1 >= 0 And objIsoY <= MF_MAP_HEIGHT) And (objIsoX - 1 >= 0 And objIsoX <= MF_MAP_WIDTH)
					' Ja, dann gib Flag walkable zurück
					Return layer.GetTileWalkable(objIsoX - 1, objIsoY - 1)
				End If
		End Select
	End If
End Function



Function MF_GetObjectView:String(angle:Float)
	' View Up
	If (angle < 22.5 And angle >= 0) Or (angle < 360 And angle > 337.5) Then Return "Up"
	' View UpRight
	If angle >= 22.5 And angle < 67.5 Then Return "UpRight"
	' View Right
	If angle >= 67.5 And angle < 112.5 Then Return "Right"
	' View DownRight
	If angle >= 112.5 And angle < 157.5 Then Return "DownRight"
	' View Down
	If angle >= 157.5 And angle < 202.5 Then Return "Down"
	' View DownLeft
	If angle >= 202.5 And angle < 247.5 Then Return "DownLeft"
	' View Left
	If angle >= 247.5 And angle < 292.5 Then Return "Left"
	' View UpLeft
	If angle >= 292.5 And angle <= 337.5 Then Return "UpLeft"
End Function



Function MF_UpdateMapObjects()
	For Local o:MF_TMapObject = EachIn MF_List_MapObjects
		' Befindet sich das Objekt auf dem Bildschirm?
		If o._x + MF_MapX >= 0 And o._x + MF_MapX <= GraphicsWidth()
			If o._y + MF_MapY >= 0 And o._y + MF_MapY <= GraphicsHeight()
				' Ja, dann in die Liste einzuzeichnender Objekte eintragen
				If Not MF_List_MapObjectsOnScreen.Contains(o)
					MF_List_MapObjectsOnScreen.AddLast(o)
				End If
				' und auch gleich die UpdateEx() Methode aufrufen
				o.UpdateEx()

			Else ' Nein, dann aus Liste einzuzeichnender Objekte löschen
				If MF_List_MapObjectsOnScreen.Contains(o)
					MF_List_MapObjectsOnScreen.Remove(o)
				End If
			End If
		Else ' Nein, dann aus Liste einzuzeichnender Objekte löschen
			If MF_List_MapObjectsOnScreen.Contains(o)
				MF_List_MapObjectsOnScreen.Remove(o)
			End If
		End If
	Next
End Function




