

	Rem
		bbdoc: Herrausfinden über welchem Tile sich die Maus befindet ( x )
		returns: Die Tile-X Koordinate des Tiles, über dem sich die Maus befindet
		Befindet sich die Maus auserhalb der Map, wird -1 zurückgegeben!
		( Bei der Rückgabe handelt es sich um Iso-Koordinaten! )
	End Rem 
	Function MF_GetMousePickedX:Int(mX:Int, mY:Int)
		Return MF_GetIsoX(mX:Int, mY:Int, 1)
	End Function
	
	
	
	Rem
		bbdoc: Herrausfinden über welchem Tile sich die Maus befindet ( y )
		returns: Die Tile-Y Koordinate des Tiles, über dem sich die Maus befindet
		Befindet sich die Maus auserhalb der Map, wird -1 zurückgegeben!
		( Bei der Rückgabe handelt es sich um Iso-Koordinaten! )
	End Rem
	Function MF_GetMousePickedY:Int(mX:Int, mY:Int)
		Return MF_GetIsoY(mX:Int, mY:Int,1)
	End Function