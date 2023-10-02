Class {
	#name : #PCShadowedCirclesBenchCase,
	#superclass : #PCCirclesBenchCase,
	#instVars : [
		'isTranslucent',
		'maximumOffset'
	],
	#category : 'BlocBenchs-FPS-Cases'
}

{ #category : #initialization }
PCShadowedCirclesBenchCase >> initialize [

	super initialize.
	
	isTranslucent := true.
	maximumOffset := 20 @ 20.
]

{ #category : #accessing }
PCShadowedCirclesBenchCase >> isTranslucent [

	^ isTranslucent
]

{ #category : #accessing }
PCShadowedCirclesBenchCase >> isTranslucent: aBoolean [

	isTranslucent := aBoolean
]

{ #category : #accessing }
PCShadowedCirclesBenchCase >> maximumOffset [

	^ maximumOffset
]

{ #category : #accessing }
PCShadowedCirclesBenchCase >> maximumOffset: anObject [

	maximumOffset := anObject
]

{ #category : #hook }
PCShadowedCirclesBenchCase >> newShadowColor: shadowColor offset: shadowOffset [

	^ self subclassResponsibility
]

{ #category : #hook }
PCShadowedCirclesBenchCase >> prepare: anElement with: random [

	| shadowColor shadowOffset |
	shadowColor := Color random: random.
	isTranslucent ifTrue: [ shadowColor := shadowColor translucent ].

	shadowOffset := random nextBetween: 2 and: maximumOffset.

	anElement
		background: (Color random: random);
		effect:
			(self
				newShadowColor: shadowColor
				offset: shadowOffset)
]
