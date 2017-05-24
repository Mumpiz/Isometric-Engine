

Rem
	bbdoc: Rechnet Pixelkoordinaten in Isokoordinaten um
	return: X-isokoordinate
End Rem
Function MF_GetIsoX:Int(pixelX:Int, pixelY:Int, scroll:Byte = 0)
	Local x:Int, y:Int, isoX:Int
	If scroll = 1
		' Map-position/verschiebung mit einkalkulieren
		pixelX = pixelX - MF_MAPX
		pixelY = pixelY - MF_MAPY
	End If
	
		x = Floor((pixelX + (pixelY - (MF_TILE_GROUND_HEIGHT / 2)) * 2) / Float(MF_TILE_WIDTH))
		y = Floor((pixelY - (pixelX - (MF_TILE_WIDTH / 2)) * 0.5) / Float(MF_TILE_GROUND_HEIGHT))
		isoX = Floor((x - y) / 2)
		' Überprüfen ob Maus sich auf der Map befindet, wenn nicht -1 zurückgeben
		If isoX >= 0 And isoX <= MF_MAP_WIDTH - 1
			Return isoX
		Else
			Return - 1
		EndIf
End Function


Rem
	bbdoc: Rechnet Pixelkoordinaten in Isokoordinaten um
	return: Y-isokoordinate
End Rem
Function MF_GetIsoY:Int(pixelX:Int, pixelY:Int, scroll:Byte = 0)
	Local x:Int, y:Int, isoY:Int
	If scroll = 1
		' Map-position/verschiebung mit einkalkulieren
		pixelX = pixelX - MF_MAPX
		pixelY = pixelY - MF_MAPY
	End If
			
		x = Floor((pixelX + (pixelY - (MF_TILE_GROUND_HEIGHT / 2)) * 2) / Float(MF_TILE_WIDTH))
		y = Floor((pixelY - (pixelX - (MF_TILE_WIDTH / 2)) * 0.5) / Float(MF_TILE_GROUND_HEIGHT))
		isoY = y + x
		' Überprüfen ob Maus sich auf der Map befindet, wenn nicht -1 zurückgeben
		If isoY >= 0 And isoY <= MF_MAP_WIDTH - 1
			Return isoY
		Else
			Return - 1
		EndIf
End Function




Rem
	bbdoc: Rechnet Isokoordinaten in Pixelkoordinaten um
	return: X-pixelkoordinate
End Rem
Function MF_GetPixelX:Int(isoX:Int, isoY:Int)
	Local pixelX:Int
	If isoY Mod 2
			pixelX = ((isoX + 1) * MF_TILE_WIDTH)
		Else
			pixelX = ((isoX + 1) * MF_TILE_WIDTH) - (MF_TILE_WIDTH / 2)
		End If
	Return pixelX
End Function



Rem
	bbdoc: Rechnet Isokoordinaten in Pixelkoordinaten um
	return: Y-pixelkoordinate
End Rem
Function MF_GetPixelY:Int(isoX:Int, isoY:Int)
	Local pixelY:Int
	pixelY = (isoY + 1) * (MF_GROUND_LAYER_TILEHEIGHT - (MF_TILE_GROUND_HEIGHT / 2))
	Return pixelY
End Function


