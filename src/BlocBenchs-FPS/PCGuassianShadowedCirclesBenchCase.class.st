Class {
	#name : #PCGuassianShadowedCirclesBenchCase,
	#superclass : #PCShadowedCirclesBenchCase,
	#category : 'BlocBenchs-FPS-Cases'
}

{ #category : #hook }
PCGuassianShadowedCirclesBenchCase >> newShadowColor: shadowColor offset: shadowOffset [

	^ BlGaussianShadowEffect
				color: shadowColor
				width: 10
				offset: shadowOffset
]

{ #category : #hook }
PCGuassianShadowedCirclesBenchCase >> numberOfFigures [

	^ 100
]
