

Rem
	bbdoc: Berechnet den Winkel zwischen 2 Punkten
	about:
	Ausgehen davon, dass 0° Oben ist, und 180° unten,
	wird der Drehwinkel berechnet, den Punkt x1,y1 bräuchte,
	um seine Blickrichtung auf Punkt x2,y2 zu richten.
	returns: Einen Winkel zwischen 0 und 360 Grad
End Rem
Function MF_GetViewAngle:Float(x1:Int, y1:Int, x2:Int, y2:Int)
	Local angle:Float = (-ATan2(x1 - x2, y1 - y2))
	If angle < 0 angle:+360
	If angle >= 360 angle:-360
	Return angle
EndFunction