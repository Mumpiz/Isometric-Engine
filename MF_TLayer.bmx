
Private


Public
Type MF_TLayer
	Field _order:Int
	Field _imgTileset:TImage
	Field _ATile:MF_TTile[,]
	
	
	
	Rem
		bbdoc: Erstellt einen neuen Layer
		about: order gibt die Layertiefe an
		Layer werden aufsteigend gezeichnet - 0 wird zuerst gezeichnet, danach 1, danach 2 usw. .
		returns: Der erstellte Layer vom Typ MF_TLayer
	End Rem
	Function Create:MF_TLayer(order:Int, x:Int, y:Int, imgTileset:TImage = Null)
		Local l:MF_TLayer = New MF_TLayer
		l._order = order
		l._imgTileset = imgTileset
		
		' Tiles mit richtigem Versatz erstellen und im eigenen Array speichern
		l._ATile = New MF_TTile[MF_MAP_WIDTH, MF_MAP_HEIGHT]
		Local xPos:Int
		Local yPos:Int
			
		For Local ty:Int = 0 To MF_MAP_HEIGHT - 1
			For Local tx:Int = 0 To MF_MAP_WIDTH - 1
				' X Position des Tiles berechnen
				xPos = (tx * MF_TILE_WIDTH)
				' Selbe mit der Y Position, zusätzlich minus die Differenz zwischen der Teilhöhe und der Bodenteilhöhe
				' Somit kann die tatsächliche Tilehöhe variieren, ohne Einfluss auf das Zeichnen der Map zu haben
				Select order
					Case 1 ' GroundLayer
						yPos = (ty * (MF_TILE_GROUND_HEIGHT / 2)) - (MF_GROUND_LAYER_TILEHEIGHT - MF_TILE_GROUND_HEIGHT)
					Case 2 ' MidLayer
						yPos = (ty * (MF_TILE_GROUND_HEIGHT / 2)) - (MF_MID_LAYER_TILEHEIGHT - MF_TILE_GROUND_HEIGHT)
					Case 3 ' TopLayer
						yPos = (ty * (MF_TILE_GROUND_HEIGHT / 2)) - (MF_TOP_LAYER_TILEHEIGHT - MF_TILE_GROUND_HEIGHT)
				End Select
				' jede zweite Zeile einrücken
				If (ty Mod 2) xPos = xPos + (MF_TILE_WIDTH / 2)
				' Tile erstellen und im Array "._Atile[]" speichern
				l._ATile[tx, ty] = MF_TTile.Create(xPos, yPos)
			Next
		Next
		
		
		Return l
	End Function
	
	
	
	Rem
		bbdoc: Zeichnet den Layer
	End Rem
	Method Draw()
		Local indexStartY:Int = MF_GetDrawIndexY(MF_MapX, MF_MapY, 0)
		Local indexEndY:Int = MF_GetDrawIndexY(MF_MapX, MF_MapY, 1)
		
		Local indexStartX:Int = MF_GetDrawIndexX(MF_MapX, MF_MapY, 0)
		Local indexEndX:Int = MF_GetDrawIndexX(MF_MapX, MF_MapY, 1)
		
		' Zeichnen
		If Self._imgTileset <> Null
			For Local ty:Int = indexStartY To indexEndY
				For Local tx:Int = indexStartX To indexEndX
					Select Self._order
						Case 1 ' GroundLayer
							' Tiles zeichnen
							DrawImage Self._imgTileset, Self._ATile[tx, ty].GetX() + MF_MapX, Self._ATile[tx, ty].GetY() + MF_MapY, Self._ATile[tx, ty].getMaterial()
						
						Case 2 ' MidLayer
							' Tiles zeichnen
							DrawImage Self._imgTileset, Self._ATile[tx, ty].GetX() + MF_MapX, Self._ATile[tx, ty].GetY() + MF_MapY, Self._ATile[tx, ty].getMaterial()
							
							' Objekte Zeichnen
							If (tx + 1 <= indexEndX And ty + 1 <= indexEndY) And (tx - 1 >= indexStartX And ty - 1 >= indexStartY)
								For Local o:MF_TMapObject = EachIn MF_List_MapObjectsOnScreen
									If o.GetX() >= Self._ATile[tx - 1, ty].GetX() And o.GetX() <= Self._ATile[tx + 1, ty].GetX()
										If o.GetY() >= Self._ATile[tx, ty].GetY() + (MF_MID_LAYER_TILEHEIGHT - (MF_TILE_GROUND_HEIGHT / 2)) And o.GetY() <= Self._ATile[tx, ty + 1].GetY() + (MF_MID_LAYER_TILEHEIGHT - (MF_TILE_GROUND_HEIGHT / 2))
											o.DrawEx()
										End If
									EndIf
								Next
							EndIf

						Case 3 ' TopLayer
							' Tiles zeichnen
							DrawImage Self._imgTileset, Self._ATile[tx, ty].GetX() + MF_MapX, Self._ATile[tx, ty].GetY() + MF_MapY, Self._ATile[tx, ty].getMaterial()
							
					End Select
				Next
			Next
		End If
		
		DrawText "indexStartX: " + indexStartX, 0, 40
		DrawText "indexEndX: " + indexEndX, 0, 60
		DrawText "indexStartY: " + indexStartY, 0, 80
		DrawText "indexEndY: " + indexEndY, 0, 100
		
	End Method
	
	
	
	Method Update()
		Select Self._order
			Case 2 ' Midlayer
				MF_UpdateMapObjects()
		End Select
	End Method
	
	
	
	Rem
		bbdoc: Setzt die Materialnummer eines Tiles
	End Rem
	Method SetTileMaterial(iX:Int, iY:Int, tileMaterial:Short) Final
		Self._ATile[iX, iY].SetMaterial(tileMaterial)
	End Method
	
	

	Rem
		bbdoc: Gibt die Materialnummer eines Tiles zurück
	End Rem
	Method GetTileMaterial:Byte(iX:Int, iY:Int) Final
		Return Self._ATile[iX, iY].getMaterial()
	End Method
	
	
	
	Rem
		bbdoc: Setzt das Flag Walkable eines Tiles
	End Rem
	Method SetTileWalkable(iX:Int, iY:Int, walkable:Byte) Final
		Self._ATile[iX, iY].SetWalkable(walkable)
	End Method
	
	
	
	Rem
		bbdoc: Gibt das Flag Walkable eines Tiles zurück
	End Rem
	Method GetTileWalkable:Byte(iX:Int, iY:Int) Final
		Return Self._ATile[iX, iY].GetWalkable()
	End Method
	
	
	
	Rem
		bbdoc: Setzt das Flag Full eines Tiles
	End Rem
	Method SetTileFull(iX:Int, iY:Int, full:Byte) Final
		Self._ATile[iX, iY].SetFull(full)
	End Method
	
	

	Rem
		bbdoc: Gibt das Flag Full eines Tiles zurück
	End Rem
	Method GetTileFull:Byte(iX:Int, iY:Int) Final
		Return Self._ATile[iX, iY].GetFull()
	End Method
	
	
	Rem
		bbdoc: Gibt Tile X Koordinate zurück
		about: scroll True , dann wird die Koordinate mit berücksichtigung der Mapverschiebung zurückgegeben
	End Rem
	Method GetTileX:Int(iX:Int, iY:Int, scroll:Byte = False) Final
		If scroll = False
			Return Self._ATile[iX, iY].GetX()
		Else
			Return Self._ATile[iX, iY].GetX() + MF_MAPX
		End If
	End Method
	
	
	
	Rem
		bbdoc: Gibt Tile Y Koordinate zurück
		about: scroll True , dann wird die Koordinate mit berücksichtigung der Mapverschiebung zurückgegeben
	End Rem
	Method GetTileY:Int(iX:Int, iY:Int, scroll:Byte = False) Final
		If scroll = False
			Return Self._ATile[iX, iY].GetY()
		Else
			Return Self._ATile[iX, iY].GetY() + MF_MAPY
		End If
	End Method
	
End Type








