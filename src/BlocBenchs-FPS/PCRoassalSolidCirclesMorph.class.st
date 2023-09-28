Class {
	#name : 'PCRoassalSolidCirclesMorph',
	#superclass : 'PCRoassalCirclesMorph',
	#category : 'BlocBenchs-FPS-RawMorph-Old',
	#package : 'BlocBenchs-FPS',
	#tag : 'RawMorph-Old'
}

{ #category : 'instance creation' }
PCRoassalSolidCirclesMorph >> prepareCircle: aCircleShape [

	aCircleShape color: (Color random: random)
]
