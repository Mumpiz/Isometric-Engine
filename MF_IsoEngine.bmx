

Include "MF_TFps.bmx"
Include "MF_TTile.bmx"
Include "MF_TLayer.bmx"
Include "MF_TMap.bmx"
Include "MF_TAnimSeq.bmx"
Include "MF_TMapObject.bmx"
Include "MF_TPathfinder.bmx"
Include "MF_TLight.bmx"

Include "MF_GetIsoCoords.bmx"
Include "MF_GetMousePicked.bmx"
Include "MF_GetDrawIndex.bmx"
Include "MF_GetViewAngle.bmx"
Include "MF_GetDistance.bmx"

Private
Global MF_MAPX:Int
Global MF_MAPY:Int
Global MF_MAP_WIDTH:Int
Global MF_MAP_HEIGHT:Int
Global MF_TILE_WIDTH:Int
Global MF_TILE_GROUND_HEIGHT:Int
Global MF_GROUND_LAYER_TILEHEIGHT:Int
Global MF_MID_LAYER_TILEHEIGHT:Int
Global MF_TOP_LAYER_TILEHEIGHT:Int

Public
Function MF_IsoEngineInit ..
	( ..
		mapWidth:Int, mapHeight:Int,  ..
		tileWidth:Int, tileGroundHeight:Int,  ..
		groundLayerTileHeight:Int, midLayerTileHeight:Int, topLayerTileHeight:Int ..
	)
	
	MF_MAP_WIDTH = mapWidth
	MF_MAP_HEIGHT = mapHeight
	MF_TILE_WIDTH = tileWidth
	MF_TILE_GROUND_HEIGHT = tileGroundHeight
	MF_GROUND_LAYER_TILEHEIGHT = groundLayerTileHeight
	MF_MID_LAYER_TILEHEIGHT = midLayerTileHeight
	MF_TOP_LAYER_TILEHEIGHT = topLayerTileHeight
End Function


Function MF_GetMapX:Int()
	Return MF_MAPX
End Function

Function MF_GetMapY:Int()
	Return MF_MAPY
End Function


Global MF_Fps:MF_TFps = MF_TFps.Create()
Global MF_Debug:Byte