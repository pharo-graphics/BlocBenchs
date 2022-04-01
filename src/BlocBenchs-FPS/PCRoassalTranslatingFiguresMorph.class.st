Class {
	#name : #PCRoassalTranslatingFiguresMorph,
	#superclass : #PCRoassalMorph,
	#category : #'BlocBenchs-FPS'
}

{ #category : #accessing }
PCRoassalTranslatingFiguresMorph >> newShape: index [

	^ self subclassResponsibility
]

{ #category : #drawing }
PCRoassalTranslatingFiguresMorph >> prepareFirstDraw [

	| canvas aContainer offset |
	canvas := RSCanvas new.
	offset := -1 * surfaceExtent // 2.

	aContainer := RSComposite new.
	canvas addShape: aContainer.

	canvas newAnimation  
		duration: case duration;
		onStepDo: [ :t | | p |
			p := (case targetTranslation * t) + offset.
			aContainer translateTo: p ].

	1 to: case numberOfFigures do: [ :index |
		aContainer addShape: (self newShape: index) ].
	
	roassalAthensMorph := canvas createMorph.
	roassalAthensMorph extent: case surfaceExtent
]
