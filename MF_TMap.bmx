
Type MF_TMap

	' BodenLayer - Objekt vom Typ MF_TMapObject überdeckt diesen auf jeden Fall
	Field _groundLayer:MF_TLayer
	' Mittlerer Layer - Objekt vom Typ MF_TMapObject kann diesen überdecken, aber auch von diesem überdeckt werden
	Field _midLayer:MF_TLayer
	' Oberster Layer - Objekt vom Typ MF_TMapObject wird in jedem Fall immer von diesem überdeckt
	Field _topLayer:MF_TLayer
	
	
	Function Create:MF_TMap(x:Int, y:Int, imgTilesetGround:TImage = Null, imgTilesetMid:TImage = Null, imgTilesetTop:TImage = Null)
		Local m:MF_TMap = New MF_TMap
			
			' Layer erstellen
			m._groundLayer:MF_TLayer = MF_TLayer.Create(1, x, y, imgTilesetGround)
			m._midLayer:MF_TLayer = MF_TLayer.Create(2, x, y, imgTilesetMid)
			m._topLayer:MF_TLayer = MF_TLayer.Create(3, x, y, imgTilesetTop)
			
			m.move(x, y)
			
			Return m
	End Function

	Rem
		bbdoc: Zeichnet die Map mit allen Layern und Objekten
	End Rem
	Method Draw()
		Self._groundLayer.Draw()
		Self._midLayer.Draw()
		Self._topLayer.Draw()
	End Method
	
	Rem
		bbdoc: Aktualisiert die Map mit allen Layern und Objekten
	End Rem
	Method Update()
		Self._groundLayer.Update()
		Self._midLayer.Update()
		Self._topLayer.Update()
	End Method
	
	
	Rem
		bbdoc: Verschiebt die Map und alle Layer um X und Y
	End Rem
	Method Move(x:Int, y:Int) Final
		MF_MAPX = MF_MAPX + x
		MF_MAPY = MF_MAPY + y
	End Method
	
	
	Rem
		bbdoc: Gibt den Groundlayer zurück
	End Rem
	Method GetGroundLayer:MF_TLayer()
		Return Self._groundLayer
	End Method
	
	
	Rem
		bbdoc: Gibt den MidLayer zurück
	End Rem
	Method GetMidLayer:MF_TLayer()
		Return Self._midLayer
	End Method
	
	
	Rem
		bbdoc: Gibt den TopLayer zurück
	End Rem
	Method GetTopLayer:MF_TLayer()
		Return Self._topLayer
	End Method
	
	
	Method Destroy(handle:MF_TMap Var)
		handle = Null
		GCCollect()
	End Method

End Type








