Class {
	#name : #PCRoassalSolidCirclesMorph,
	#superclass : #PCRoassalCirclesMorph,
	#category : #'BlocBenchs-FPS-RawMorph'
}

{ #category : #'instance creation' }
PCRoassalSolidCirclesMorph >> prepareCircle: aCircleShape [

	aCircleShape color: (Color random: random)
]
