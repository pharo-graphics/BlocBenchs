Class {
	#name : #PCSimpleShadowedCirclesBenchCase,
	#superclass : #PCShadowedCirclesBenchCase,
	#category : #'BlocBenchs-FPS-Cases'
}

{ #category : #hook }
PCSimpleShadowedCirclesBenchCase >> newShadowColor: shadowColor offset: shadowOffset [

	^ BlSimpleShadowEffect
				color: shadowColor
				offset: shadowOffset
]

{ #category : #hook }
PCSimpleShadowedCirclesBenchCase >> numberOfFigures [

	^ 100
]
