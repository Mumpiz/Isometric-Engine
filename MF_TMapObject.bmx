Private
Global MF_List_MapObjectsOnScreen:TList = New TList
Global MF_List_MapObjects:TList = New TList


Public
Type MF_TMapObject
	Field _x:Int, _y:Int
	Field _nextTileX:Int = 0, _nextTileY:Int = 0, _needNextTile:Byte = True
	Field _firstLastTileX:Int, _firstLastTileY:Int, _secondLastTileX:Int, _secondLastTileY:Int
	Field _alpha:Float
	
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
	
	
	Method MoveToTile:Byte(targetTileX:Int, targetTileY:Int, speed:Int, layer:MF_TLayer, tileBound:Byte = True, onlyOnScreen:Byte = True)
		Local objIsoX:Int = MF_GetIsoX(Self._x, Self._y)
		Local objIsoY:Int = MF_GetIsoY(Self._x, Self._y)
		
		Local indexStartY:Int = MF_GetDrawIndexY(MF_MapX, MF_MapY, 0)
		Local indexEndY:Int = MF_GetDrawIndexY(MF_MapX, MF_MapY, 1)
		
		Local indexStartX:Int = MF_GetDrawIndexX(MF_MapX, MF_MapY, 0)
		Local indexEndX:Int = MF_GetDrawIndexX(MF_MapX, MF_MapY, 1)
		
		If onlyOnScreen = True
			If (objIsoX >= indexStartX And objIsoX <= indexEndX) And (objIsoY >= indexStartY And objIsoY <= indexEndY)
				If (targetTileX >= 0 And targetTileX <= MF_MAP_WIDTH) And (targetTileY >= 0 And targetTileY <= MF_MAP_HEIGHT)
					If layer.GetTileFull(targetTileX, targetTileY) = False And layer.GetTileWalkable(targetTileX, targetTileY) = True
						If tileBound = True
							FindPath(objIsoX, objIsoY, targetTileX, targetTileY, speed, layer)
							If layer.GetTileWalkable(objIsoX, objIsoY) = True And layer.GetTileFull(objIsoX, objIsoY) = False
								Return True
							Else
								Return False
							End If
						Else
							Local pixelX:Int = MF_GetPixelX(targetTileX, targetTileY)
							Local pixelY:Int = MF_GetPixelY(targetTileX, targetTileY)
							Local angle:Float = MF_GetViewAngle(Self._x, Self._y, pixelX, pixelY)
							Self._x = Self._x + (speed * Cos(angle - 90))
		    				Self._y = Self._y + (speed * Sin(angle - 90))
							If layer.GetTileWalkable(objIsoX, objIsoY) = True And layer.GetTileFull(objIsoX, objIsoY) = False
								Return True
							Else
								Return False
							End If
						End If
					End If
				End If
			End If
		Else
			If (targetTileX >= 0 And targetTileX <= MF_MAP_WIDTH) And (targetTileY >= 0 And targetTileY <= MF_MAP_HEIGHT)
					If layer.GetTileFull(targetTileX, targetTileY) = False And layer.GetTileWalkable(targetTileX, targetTileY) = True
						If tileBound = True
							FindPath(objIsoX, objIsoY, targetTileX, targetTileY, speed, layer)
							If layer.GetTileWalkable(objIsoX, objIsoY) = True And layer.GetTileFull(objIsoX, objIsoY) = False
								Return True
							Else
								Return False
							End If
						Else
							Local pixelX:Int = MF_GetPixelX(targetTileX, targetTileY)
							Local pixelY:Int = MF_GetPixelY(targetTileX, targetTileY)
							Local angle:Float = MF_GetViewAngle(Self._x, Self._y, pixelX, pixelY)
							Self._x = Self._x + (speed * Cos(angle - 90))
		    				Self._y = Self._y + (speed * Sin(angle - 90))
							If layer.GetTileWalkable(objIsoX, objIsoY) = True And layer.GetTileFull(objIsoX, objIsoY) = False
								Return True
							Else
								Return False
							End If
						End If
					End If
			End If
		End If
		
	End Method
	
	
	Method FindPath(objIsoX:Int, objIsoY:Int, targetTileX:Int, targetTileY:Int, speed:Int, layer:MF_TLayer)
		
		Local pixelX:Int
		Local pixelY:Int
		
		If (targetTileX = objIsoX And targetTileY = objIsoY)
				Self._needNextTile = False
			End If
			
			If Self._needNextTile = True
				MF_FindNextFreeNearestTile(objIsoX, objIsoY, Self._nextTileX, Self._nextTileY, targetTileX:Int, targetTileY:Int, layer)
				layer.SetTileFull(Self._nextTileX, Self._nextTileY, 1)
				Self._needNextTile = False
				rem
				If layer.GetTileMaterial(Self._nextTileX, Self._nextTileY) = 1
					layer.SetTileMaterial(Self._nextTileX, Self._nextTileY, 2)
				Else
					layer.SetTileMaterial(Self._nextTileX, Self._nextTileY, 1)
				End If
				End Rem
			End If
			
			If Self._nextTileX = objIsoX And Self._nextTileY = objIsoY
				' Setze das vorvorletze Tile auf nicht besetzt
				layer.SetTileFull(Self._secondLastTileX, Self._secondLastTileY, 0)
				Self._secondLastTileX = Self._firstLastTileX
				Self._secondLastTileY = Self._firstLastTileY
				' Hole das letze Tile
				Self._firstLastTileX = Self._nextTileX
				Self._firstLastTileY = Self._nextTileY
				' Und setze es auf besetzt
				layer.SetTileFull(Self._firstLastTileX, Self._firstLastTileY, 1)
				' Bescheidgeben das ein neues Tile gesucht werden soll
				Self._needNextTile = True
			End If
			
			pixelX = MF_GetPixelX(Self._nextTileX, Self._nextTileY)
			pixelY = MF_GetPixelY(Self._nextTileX, Self._nextTileY)
		
			Local angle:Float = MF_GetViewAngle(Self._x, Self._y, pixelX, pixelY)
			Self._x = Self._x + (speed * Cos(angle - 90))
    		Self._y = Self._y + (speed * Sin(angle - 90))
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


Private
Function MF_SortTileCostArray(array:Int[,] Var)
	Local tmp0:Int = 0
	Local tmp1:Int = 0
	Local swap:Int = 0
	Local depht:Int = 0
	Repeat
		swap = 0
		For Local i:Int = 0 To 7 - 1 - depht
			If array[i, 0] = array[i + 1, 0]
				If i Mod 2
					tmp0 = array[i, 0]
					tmp1 = array[i, 1]
					array[i, 0] = array[i + 1, 0]
					array[i, 1] = array[i + 1, 1]
					array[i + 1, 0] = tmp0
					array[i + 1, 1] = tmp1
				End If
			End If
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

Private
Function MF_FindNextFreeNearestTile(objIsoX:Int, objIsoY:Int, nextTileX:Int Var, nextTileY:Int Var, targetTileX:Int, targetTileY:Int, layer:MF_TLayer)
	Local targetTilePixelX:Int = MF_GetPixelX(targetTileX, targetTileY)
	Local targetTilePixelY:Int = MF_GetPixelY(targetTileX, targetTileY)
	
	Local objPixelX:Int = MF_GetPixelX(objIsoX, objIsoY)
	Local objPixelY:Int = MF_GetPixelY(objIsoX, objIsoY)
	
	Local objPixelXp1:Int = MF_GetPixelX(objIsoX + 1, objIsoY)
	Local objPixelYp1:Int = MF_GetPixelY(objIsoX, objIsoY + 1)

	Local objPixelYp2:Int = MF_GetPixelY(objIsoX, objIsoY + 2)
	
	Local objPixelXm1:Int = MF_GetPixelX(objIsoX - 1, objIsoY)
	Local objPixelYm1:Int = MF_GetPixelY(objIsoX, objIsoY - 1)
	
	Local objPixelYm2:Int = MF_GetPixelY(objIsoX, objIsoY - 2)
	
	Local tileCost:Int[8, 2]
	
	'Tile "Up"
	tileCost[0, 0] = MF_GetDistance(layer.GetTileX(targetTileX, targetTileY), layer.GetTileY(targetTileX, targetTileY), layer.GetTileX(objIsoX, objIsoY - 2), layer.GetTileY(objIsoX, objIsoY - 2)) + 16
	tileCost[0, 1] = 0
	
	
	'Tile "UpRight"
	If objIsoY Mod 2
		tileCost[1, 0] = MF_GetDistance(layer.GetTileX(targetTileX, targetTileY), layer.GetTileY(targetTileX, targetTileY), layer.GetTileX(objIsoX + 1, objIsoY - 1), layer.GetTileY(objIsoX + 1, objIsoY - 1))
	Else
		tileCost[1, 0] = MF_GetDistance(layer.GetTileX(targetTileX, targetTileY), layer.GetTileY(targetTileX, targetTileY), layer.GetTileX(objIsoX, objIsoY - 1), layer.GetTileY(objIsoX, objIsoY - 1))
	End If
	tileCost[1, 1] = 1
	
	
	'Tile "Right"
	tileCost[2, 0] = MF_GetDistance(layer.GetTileX(targetTileX, targetTileY), layer.GetTileY(targetTileX, targetTileY), layer.GetTileX(objIsoX + 1, objIsoY), layer.GetTileY(objIsoX + 1, objIsoY)) + 16
	tileCost[2, 1] = 2
	
	
	'Tile "DownRight"
	If objIsoY Mod 2
		tileCost[3, 0] = MF_GetDistance(layer.GetTileX(targetTileX, targetTileY), layer.GetTileY(targetTileX, targetTileY), layer.GetTileX(objIsoX + 1, objIsoY + 1), layer.GetTileY(objIsoX + 1, objIsoY + 1))
	Else
		tileCost[3, 0] = MF_GetDistance(layer.GetTileX(targetTileX, targetTileY), layer.GetTileY(targetTileX, targetTileY), layer.GetTileX(objIsoX, objIsoY + 1), layer.GetTileY(objIsoX, objIsoY + 1))
	End If
	tileCost[3, 1] = 3
	
	
	' Tile "Down"
	tileCost[4, 0] = MF_GetDistance(layer.GetTileX(targetTileX, targetTileY), layer.GetTileY(targetTileX, targetTileY), layer.GetTileX(objIsoX, objIsoY + 2), layer.GetTileY(objIsoX, objIsoY + 2)) + 16
	tileCost[4, 1] = 4

	
	'Tile "DownLeft"
	If objIsoY Mod 2
		tileCost[5, 0] = MF_GetDistance(layer.GetTileX(targetTileX, targetTileY), layer.GetTileY(targetTileX, targetTileY), layer.GetTileX(objIsoX, objIsoY + 1), layer.GetTileY(objIsoX, objIsoY + 1))
	Else
		tileCost[5, 0] = MF_GetDistance(layer.GetTileX(targetTileX, targetTileY), layer.GetTileY(targetTileX, targetTileY), layer.GetTileX(objIsoX - 1, objIsoY + 1), layer.GetTileY(objIsoX - 1, objIsoY + 1))
	End If
	tileCost[5, 1] = 5
	
	
	'Tile "Left"
	tileCost[6, 0] = MF_GetDistance(layer.GetTileX(targetTileX, targetTileY), layer.GetTileY(targetTileX, targetTileY), layer.GetTileX(objIsoX - 1, objIsoY), layer.GetTileY(objIsoX - 1, objIsoY)) + 16
	tileCost[6, 1] = 6
	
	
	'Tile "UpLeft"
	If objIsoY Mod 2
		tileCost[7, 0] = MF_GetDistance(layer.GetTileX(targetTileX, targetTileY), layer.GetTileY(targetTileX, targetTileY), layer.GetTileX(objIsoX, objIsoY - 1), layer.GetTileY(objIsoX, objIsoY - 1))
	Else
		tileCost[7, 0] = MF_GetDistance(layer.GetTileX(targetTileX, targetTileY), layer.GetTileY(targetTileX, targetTileY), layer.GetTileX(objIsoX - 1, objIsoY - 1), layer.GetTileY(objIsoX - 1, objIsoY - 1))
	End If
	
	tileCost[7, 1] = 7
	
	MF_SortTileCostArray(tileCost)
	
	For Local i:Int = 0 To 7
		Select tileCost[i, 1]
		
			' Tile "Up"
			Case 0
				If MF_ObjectCanMove:Byte(objIsoX, objIsoY, "Up", layer) = True
					nextTileX = objIsoX
					nextTileY = objIsoY - 2
					Exit
				Else
					Continue
				End If
		
			'Tile "UpRight"
			Case 1
				If MF_ObjectCanMove:Byte(objIsoX, objIsoY, "UpRight", layer) = True
					If objIsoY Mod 2
						nextTileX = objIsoX + 1
						nextTileY = objIsoY - 1
						Exit
					Else
						nextTileX = objIsoX
						nextTileY = objIsoY - 1
						Exit
					End If
				Else
					Continue
				EndIf
			
			' Tile "Right"
			Case 2
				If MF_ObjectCanMove:Byte(objIsoX, objIsoY, "Right", layer) = True
					nextTileX = objIsoX + 1
					nextTileY = objIsoY
					Exit
				Else
					Continue
				End If
			
			
			
			'Tile "DownRight"
			Case 3
				If MF_ObjectCanMove:Byte(objIsoX, objIsoY, "DownRight", layer) = True
					If objIsoY Mod 2
						nextTileX = objIsoX + 1
						nextTileY = objIsoY + 1
						Exit
					Else
						nextTileX = objIsoX
						nextTileY = objIsoY + 1
						Exit
					End If
				Else
					Continue
				End If
			
			
			' Tile "Down"
			Case 4
				If MF_ObjectCanMove:Byte(objIsoX, objIsoY, "Down", layer) = True
					nextTileX = objIsoX
					nextTileY = objIsoY + 2
					Exit
				Else
					Continue
				End If
				
			
			
			'Tile "DownLeft"
			Case 5
				If MF_ObjectCanMove:Byte(objIsoX, objIsoY, "DownLeft", layer) = True
					If objIsoY Mod 2
						nextTileX = objIsoX
						nextTileY = objIsoY + 1
						Exit
					Else
						nextTileX = objIsoX - 1
						nextTileY = objIsoY + 1
						Exit
					End If
				Else
					Continue
				End If
			
			
			' Tile "Left"
			Case 6
				If MF_ObjectCanMove:Byte(objIsoX, objIsoY, "Left", layer) = True
					nextTileX = objIsoX - 1
					nextTileY = objIsoY
					Exit
				Else
					Continue
				End If
				
				
			'Tile "UpLeft"
			Case 7
				If MF_ObjectCanMove:Byte(objIsoX, objIsoY, "UpLeft", layer) = True
					If objIsoY Mod 2
						nextTileX = objIsoX
						nextTileY = objIsoY - 1
						Exit
					Else
						nextTileX = objIsoX - 1
						nextTileY = objIsoY - 1
						Exit
					End If
				Else
					Continue
				End If
			
		End Select
	Next
End Function

Private
Function MF_ObjectCanMove:Byte(objIsoX:Int, objIsoY:Int, direction:String, layer:MF_TLayer)
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
			'If MF_GetTileRelativToObjectWalkable(objIsoX, objIsoY, "Up", layer) = 1
				If MF_GetTileRelativToObjectWalkable(objIsoX, objIsoY, "UpRight", layer) = 1
					'If MF_GetTileRelativToObjectWalkable(objIsoX, objIsoY, "Right", layer) = 1
						Return 1
					'End If
				End If
			'End If
		
		Case "Right"
			If MF_GetTileRelativToObjectWalkable(objIsoX, objIsoY, "UpRight", layer) = 1
				If MF_GetTileRelativToObjectWalkable(objIsoX, objIsoY, "Right", layer) = 1
					If MF_GetTileRelativToObjectWalkable(objIsoX, objIsoY, "DownRight", layer) = 1
						Return 1
					End If
				End If
			End If
			
		Case "DownRight"
			'If MF_GetTileRelativToObjectWalkable(objIsoX, objIsoY, "Right", layer) = 1
				If MF_GetTileRelativToObjectWalkable(objIsoX, objIsoY, "DownRight", layer) = 1
					'If MF_GetTileRelativToObjectWalkable(objIsoX, objIsoY, "Down", layer) = 1
						Return 1
					'End If
				End If
			'End If
		
		Case "Down"
			If MF_GetTileRelativToObjectWalkable(objIsoX, objIsoY, "DownRight", layer) = 1
				If MF_GetTileRelativToObjectWalkable(objIsoX, objIsoY, "Down", layer) = 1
					If MF_GetTileRelativToObjectWalkable(objIsoX, objIsoY, "DownLeft", layer) = 1
						Return 1
					End If
				End If
			End If
		
		Case "DownLeft"
			'If MF_GetTileRelativToObjectWalkable(objIsoX, objIsoY, "Down", layer) = 1
				If MF_GetTileRelativToObjectWalkable(objIsoX, objIsoY, "DownLeft", layer) = 1
					'If MF_GetTileRelativToObjectWalkable(objIsoX, objIsoY, "Left", layer) = 1
						Return 1
					'End If
				End If
			'End If
		
		Case "Left"
			If MF_GetTileRelativToObjectWalkable(objIsoX, objIsoY, "DownLeft", layer) = 1
				If MF_GetTileRelativToObjectWalkable(objIsoX, objIsoY, "Left", layer) = 1
					If MF_GetTileRelativToObjectWalkable(objIsoX, objIsoY, "UpLeft", layer) = 1
						Return 1
					End If
				End If
			End If
		
		Case "UpLeft"
			'If MF_GetTileRelativToObjectWalkable(objIsoX, objIsoY, "Left", layer) = 1
				If MF_GetTileRelativToObjectWalkable(objIsoX, objIsoY, "UpLeft", layer) = 1
					'If MF_GetTileRelativToObjectWalkable(objIsoX, objIsoY, "Up", layer) = 1
						Return 1
					'End If
				End If
			'End If
		
	End Select
End Function



Private
Rem
	bbdoc: Überprüft das angebene Tile auf begehbarkeit. Welches ist abhängig von der übergebenen Richtung und der Übergebenen Objektposition.
	about: Welches Tile, ist abhängig von der Objektposition (objX:Int, objY:Int) und der angegebenen Richtung (direction
	"Up" "UpRight" "Right" "DownRight" "Down" "DownLeft" "Left" und "UpLeft" )
	return:
		True: wenn das Tileflag "Walkable" True ist und das Tileflag "Full" False ist
		False: wenn das Tileflag "Walkable" False ist oder das Tileflag "Full" True ist
End Rem
Function MF_GetTileRelativToObjectWalkable:Byte(objIsoX:Int, objIsoY:Int, direction:String, layer:MF_TLayer)
	
	If (objIsoX >= 0 And objIsoX <= MF_MAP_WIDTH) And (objIsoY >= 0 And objIsoY <= MF_MAP_HEIGHT)
		Select direction
		
			Case "Up"
				' Existiert ein Tile über dem Objekt?
				If objIsoY - 2 >= 0 And objIsoY <= MF_MAP_HEIGHT
					' Ja, dann überprüfe auf begehbarkeit
					If (layer.GetTileWalkable(objIsoX, objIsoY - 2) = True And layer.GetTileFull(objIsoX, objIsoY - 2) = False)
						Return True
					Else
						Return False
					End If
				End If
				

			Case "UpRight"
				If objIsoY Mod 2
					' Existiert ein Tile schräg rechts über dem Objekt?
					If (objIsoX + 1 >= 0 And objIsoX <= MF_MAP_WIDTH) And (objIsoY - 1 >= 0 And objIsoY <= MF_MAP_HEIGHT)
						' Ja, dann überprüfe auf begehbarkeit
						If (layer.GetTileWalkable(objIsoX + 1, objIsoY - 1) = True And layer.GetTileFull(objIsoX + 1, objIsoY - 1) = False)
							Return True
						Else
							Return False
						End If
					End If
				Else
					' Existiert ein Tile schräg rechts über dem Objekt?
					If objIsoY - 1 >= 0 And objIsoY <= MF_MAP_HEIGHT
						' Ja, dann überprüfe auf begehbarkeit
						If (layer.GetTileWalkable(objIsoX, objIsoY - 1) = True And layer.GetTileFull(objIsoX, objIsoY - 1) = False)
							Return True
						Else
							Return False
						End If
					End If
				End If
				
				
			Case "Right"
				' Existiert ein Tile rechts neben dem Objekt?
				If objIsoX + 1 >= 0 And objIsoX <= MF_MAP_WIDTH
					' Ja, dann überprüfe auf begehbarkeit
					If (layer.GetTileWalkable(objIsoX + 1, objIsoY) = True And layer.GetTileFull(objIsoX + 1, objIsoY) = False)
						Return True
					Else
						Return False
					End If
				End If
				
				
			Case "DownRight"
				If objIsoY Mod 2
					' Existiert ein Tile schräg rechts unter dem Objekt?
					If (objIsoX + 1 >= 0 And objIsoX <= MF_MAP_WIDTH) And (objIsoY + 1 >= 0 And objIsoY <= MF_MAP_HEIGHT)
						' Ja, dann überprüfe auf begehbarkeit
						If (layer.GetTileWalkable(objIsoX + 1, objIsoY + 1) = True And layer.GetTileFull(objIsoX + 1, objIsoY + 1) = False)
							Return True
						Else
							Return False
						End If
					End If
				Else
					' Existiert ein Tile schräg rechts unter dem Objekt?
					If (objIsoY + 1 >= 0 And objIsoY <= MF_MAP_HEIGHT)
						' Ja, dann überprüfe auf begehbarkeit
						If (layer.GetTileWalkable(objIsoX, objIsoY + 1) = True And layer.GetTileFull(objIsoX, objIsoY + 1) = False)
							Return True
						Else
							Return False
						End If
					End If
				End If
				
				
			Case "Down"
				' Existiert ein Tile unter dem Objekt?
				If objIsoY + 2 >= 0 And objIsoY <= MF_MAP_HEIGHT
					' Ja, dann überprüfe auf begehbarkeit
					If (layer.GetTileWalkable(objIsoX, objIsoY + 2) = True And layer.GetTileFull(objIsoX, objIsoY + 2) = False)
						Return True
					Else
						Return False
					End If
				End If
				
				
				
			Case "DownLeft"
				If objIsoY Mod 2
					' Existiert ein Tile schräg rechts unter dem Objekt?
					If objIsoY + 1 >= 0 And objIsoY <= MF_MAP_HEIGHT
						' Ja, dann überprüfe auf begehbarkeit
						If (layer.GetTileWalkable(objIsoX, objIsoY + 1) = True And layer.GetTileFull(objIsoX, objIsoY + 1) = False)
							Return True
						Else
							Return False
						End If
					End If
				Else
					' Existiert ein Tile schräg links unter dem Objekt?
					If (objIsoX - 1 >= 0 And objIsoX <= MF_MAP_WIDTH) And (objIsoY + 1 >= 0 And objIsoY <= MF_MAP_HEIGHT)
						' Ja, dann überprüfe auf begehbarkeit
						If (layer.GetTileWalkable(objIsoX - 1, objIsoY + 1) = True And layer.GetTileFull(objIsoX - 1, objIsoY + 1) = False)
							Return True
						Else
							Return False
						End If
					End If
				End If
				
				
			Case "Left"
				' Existiert ein Tile links neben dem Objekt?
				If objIsoX - 1 >= 0 And objIsoX <= MF_MAP_WIDTH
					' Ja, dann überprüfe auf begehbarkeit
					If (layer.GetTileWalkable(objIsoX - 1, objIsoY) = True And layer.GetTileFull(objIsoX - 1, objIsoY) = False)
						Return True
					Else
						Return False
					End If
				End If
				
				
				
			Case "UpLeft"
				If objIsoY Mod 2
					' Existiert ein Tile schräg rechts unter dem Objekt?
					If objIsoY - 1 >= 0 And objIsoY <= MF_MAP_HEIGHT
						' Ja, dann überprüfe auf begehbarkeit
						If (layer.GetTileWalkable(objIsoX, objIsoY - 1) = True And layer.GetTileFull(objIsoX, objIsoY - 1) = False)
							Return True
						Else
							Return False
						End If
					End If
				Else
					' Existiert ein Tile schräg links über dem Objekt?
					If (objIsoX - 1 >= 0 And objIsoX <= MF_MAP_WIDTH) And (objIsoY - 1 >= 0 And objIsoY <= MF_MAP_HEIGHT)
						' Ja, dann überprüfe auf begehbarkeit
						If (layer.GetTileWalkable(objIsoX - 1, objIsoY - 1) = True And layer.GetTileFull(objIsoX - 1, objIsoY - 1) = False)
							Return True
						Else
							Return False
						End If
					End If
				End If
		End Select
	End If
End Function


Private
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


Private
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




