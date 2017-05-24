
Rem
	bbdoc: Klasse zum ermitteln der Bilder Pro Sekunde
End Rem 
Type MF_TFps

   Field _old:Int
   Field _fps:Int

   Field _count:Int
   Field _time:Int
   
   Field _timer:TTimer

	Rem
		bbdoc: Erstellt einen neuen Fps-Zähler
		about: Beispiel: Global MyFps:MF_TFps = MF_TFps.Create()
	End Rem 
   Function Create:MF_TFps()
   		Local n:MF_TFps = New MF_TFps
        	n._timer = CreateTimer(1)
      	Return n
   EndFunction
   
   	Rem
		bbdoc: Setzt den Fps-Zähler zurück
	End Rem 
   Method Reset()
    	Self._time = 0
    	Self._count = 0
    	Self._fps = 0
    	Self._old = 0
   EndMethod
   
   	Rem
		bbdoc: Aktualiert den Fps-Zähler
		about: Beispiel: MyFps.Update()
		Der Fps-Zähler muss einmal pro durchlauf in der Hauptschleife aktualisiert werden
	End Rem
   Method Update()
   		Self._count = Self._count + 1
   		Self._time = TimerTicks(Self._timer) Mod 2
      	If Self._time <> Self._old Then
         	Self._fps = Self._count
         	Self._count = 0
         	Self._old = Self._time
      	EndIf
   EndMethod
   
   	Rem
		bbdoc: Gibt die aktuelle Anzahl an Bilder pro Sekunde zurück
	End Rem 
   Method Get:Int()
      	Return Self._fps
   EndMethod

EndType