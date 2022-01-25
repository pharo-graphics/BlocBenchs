Extension { #name : #AthensCairoMatrix }

{ #category : #'*BlocBenchs-PCRenderer' }
AthensCairoMatrix class >> fromSpartaMatrix: aSpartaMatrix [

	^ self new
		  initx: aSpartaMatrix x
		  y: aSpartaMatrix y
		  sx: aSpartaMatrix sx
		  sy: aSpartaMatrix sy
		  shx: aSpartaMatrix shx
		  shy: aSpartaMatrix shy;
		  yourself
]
