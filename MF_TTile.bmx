


Rem
	bbdoc: Basisklasse für Tiles
End Rem 
Type MF_TTile Final
	
	Field _x:Int, _y:Int
	Field _material:Int, _walkable:Byte, _full:Byte
	Field _alpha:Float

	Function Create:MF_Ttile(x:Int, y:Int, material:Short = 0, walkable:Byte = 1, full:Byte = 0) Final
		Local t:MF_Ttile = New MF_Ttile
			t._x = x
			t._y = y
			t._material = material
			t._walkable = walkable
			t._full = full
			Return t
	End Function
	
	
	Rem
		bbdoc: Erhöt X um einen bestimmten Betrag
	End Rem
	Method AddX(x:Int) Final
		Self._x = Self._x + x
	End Method
	
	
	Rem
		bbdoc: Erhöt Y um einen bestimmten Betrag
	End Rem
	Method AddY(y:Int) Final
		Self._y = Self._y + y
	End Method
	
	
	Rem
		bbdoc: Gibt die X-Koordinate des Tiles zurück
	End Rem
	Method GetX:Int() Final
		Return Self._x
	End Method
	
	
	Rem
		bbdoc: Gibt die Y-Koordinate des Tiles zurück
	End Rem
	Method GetY:Int() Final
		Return Self._y
	End Method
	
	
	Rem
		bbdoc: Gibt die Materialnummer des Tiles zurück
	End Rem
	Method GetMaterial:Short() Final
		Return Self._material
	End Method
	
	
	Rem
		bbdoc: Gibt das Flag "Walkable"(begehbar) des Tiles zurück
	End Rem
	Method GetWalkable:Byte() Final
		Return Self._walkable
	End Method
	
	
	Rem
		bbdoc: Gibt das Flag "full"(besetzt) des Tiles zurück
	End Rem
	Method GetFull:Byte() Final
		Return Self._full
	End Method
	
	
	Rem
		bbdoc: Setzt die Materialnummer des Tiles
	End Rem
	Method SetMaterial(material:Short) Final
		Self._material = material
	End Method
	
	
	Rem
		bbdoc: Setzt das Flag "Walkable"(begehbar) des Tiles
	End Rem
	Method SetWalkable(walkable:Byte) Final
		Self._walkable = walkable
	End Method
	
	
	Rem
		bbdoc: Setzt das Flag "full"(besetzt) des Tiles
	End Rem
	Method SetFull(full:Byte) Final
		Self._full = full
	End Method
	
	
End Type




