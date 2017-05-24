


Rem
		bbdoc: Ermittelt anhand der Grafikeinstellungen, wievieles Tiles im X gezeichnet und berechnet werden müssen
		about: Xpos und Ypos sollten i.d.R. MF_MAPX und MF_MAPY übergeben werden.
		returns: Wenn startOrEnd:Byte = 0 Wird der StartIndex zurückgegeben
		Wenn startOrEnd:Byte = 1 Wird der EndIndex zurückgegeben
	End Rem
	Function MF_GetDrawIndexX:Int(Xpos:Int, Ypos:Int, startOrEnd:Byte = 0)
		Local x:Int, y:Int, tileX:Int
		x = Floor((Xpos + (Ypos - (MF_TILE_GROUND_HEIGHT / 2)) * 2) / Float(MF_TILE_WIDTH))
		y = Floor((Ypos - (Xpos - (MF_TILE_WIDTH / 2)) * 0.5) / Float(MF_TILE_GROUND_HEIGHT))
		tileX = Floor((x - y) / 2)
		
		Local tilesInRow:Short = GraphicsWidth() / MF_TILE_WIDTH + 1
		Local indexStartX:Int, indexEndX:Int
		Local startX:Int = tileX
		
		If startX < - 2
			indexStartX = Abs(startX) - 2
		Else 
			indexStartX = 0
		EndIf

		Local endX:Int = MF_MAP_WIDTH - 1
		
		If Abs(startX) + tilesInRow < endX
			indexEndX = Abs(startX) + tilesInRow 
		Else 
			indexEndX = endX
		EndIf
		
		If startOrEnd = 0
			Return indexStartX
		Else
			Return indexEndX
		End If
		
	End Function
	
	
	
	Rem
		bbdoc: Ermittelt anhand der Grafikeinstellungen, wievieles Tiles im Y gezeichnet und berechnet werden müssen
		about: Xpos und Ypos sollten i.d.R. MF_MAPX und MF_MAPY übergeben werden.
		returns: Wenn startOrEnd:Byte = 0 Wird der StartIndex zurückgegeben
		Wenn startOrEnd:Byte = 1 Wird der EndIndex zurückgegeben
	End Rem
	Function MF_GetDrawIndexY:Int(Xpos:Int, Ypos:Int, startOrEnd:Byte = 0)
		Local x:Int, y:Int, tileY:Int
		x = Floor((Xpos + (Ypos - (MF_TILE_GROUND_HEIGHT / 2)) * 2) / Float(MF_TILE_WIDTH))
		y = Floor((Ypos - (Xpos - (MF_TILE_WIDTH / 2)) * 0.5) / Float(MF_TILE_GROUND_HEIGHT))
		tileY = y + x
		
		Local tilesInCol:Short = GraphicsHeight() / (MF_TILE_GROUND_HEIGHT / 2) + 1
		Local indexStartY:Int, indexEndY:Int
		Local startY:Int = tileY
		
		If startY < - 4
			indexStartY = Abs(startY) - 4
		Else 
			indexStartY = 0
		EndIf
		
		Local endY:Int = MF_MAP_HEIGHT - 1
		
		If Abs(startY) + tilesInCol < endY
			indexEndY = Abs(startY) + tilesInCol 
		Else 
			indexEndY = endY
		EndIf
		
		If startOrEnd = 0
			Return indexStartY
		Else
			Return indexEndY
		End If
		
	End Function