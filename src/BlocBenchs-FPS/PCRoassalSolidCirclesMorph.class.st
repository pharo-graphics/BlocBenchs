Class {
	#name : #PCRoassalSolidCirclesMorph,
	#superclass : #PCRoassalCirclesMorph,
	#category : #'BlocBenchs-FPS'
}

{ #category : #'instance creation' }
PCRoassalSolidCirclesMorph >> prepareCircle: aCircleShape [

	aCircleShape color: (Color random: random)
]
