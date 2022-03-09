Class {
	#name : #PCRoassalSolidBorderCirclesMorph,
	#superclass : #PCRoassalCirclesMorph,
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #'instance creation' }
PCRoassalSolidBorderCirclesMorph >> prepareCircle: aCircleShape [

	aCircleShape
		color: Color transparent;
		border:
		(RSBorder new
			 color: (Color random: random);
			 width: case borderWidth)

]
