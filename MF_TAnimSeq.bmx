

Public
Type MF_TAnimSeq
   
   	Field _timer:Int
   	Field _ms:Int

   	Field _totalFrames:Int
   
   	Field _currentFrame:Int
   	Field _startFrame:Int
   	Field _endFrame:Int
   	Field _animSpeed:Int
   
   
   	Function Create:MF_TAnimSeq(startFrame:Int, endFrame:Int, animSpeed:Int) Final
      	Local n:MF_TAnimSeq = New MF_TAnimSeq
         	n._totalFrames = endFrame - startFrame
         	n._currentFrame = Rand(startFrame, endFrame)
         	n._startFrame = startFrame
         	n._endFrame = endFrame
		 	n._animSpeed = animSpeed
      	Return n
   	EndFunction
   
   
   Method Play(image:TImage, x:Int, y:Int) Final
   	Self._ms = MilliSecs()
      	If Self._currentFrame < Self._endFrame Then
         	If Self._timer + Self._animSpeed < Self._ms Then
            	Self._currentFrame = Self._currentFrame + 1
            	If Self._currentFrame >= Self._endFrame Then Self._currentFrame = Self._startFrame
				Self._timer = Self._ms
         	EndIf
            DrawImage image, x, y, Self._currentFrame
      EndIf
   EndMethod
   
   Method SetAnimSpeed(animSpeed:Int)
   		Self._animSpeed = animSpeed
   End Method
   
EndType 