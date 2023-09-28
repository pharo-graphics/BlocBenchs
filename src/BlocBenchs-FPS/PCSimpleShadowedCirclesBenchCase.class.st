Class {
	#name : 'PCSimpleShadowedCirclesBenchCase',
	#superclass : 'PCShadowedCirclesBenchCase',
	#category : 'BlocBenchs-FPS-Cases',
	#package : 'BlocBenchs-FPS',
	#tag : 'Cases'
}

{ #category : 'hook' }
PCSimpleShadowedCirclesBenchCase >> newShadowColor: shadowColor offset: shadowOffset [

	^ BlSimpleShadowEffect
				color: shadowColor
				offset: shadowOffset
]

{ #category : 'hook' }
PCSimpleShadowedCirclesBenchCase >> numberOfFigures [

	^ 100
]
