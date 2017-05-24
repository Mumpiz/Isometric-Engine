
Rem
	bbdoc: Berechnet die Distanz zwischen 2 Punkten
	returns: Die Distanz als Float, zwischen 2 Punkten in Pixeln.
End Rem
Function MF_GetDistance:Float(x1:Float, y1:Float, x2:Float, y2:Float)
	Return Sqr((x1 - x2)^2 + (y1-y2)^2)
EndFunction