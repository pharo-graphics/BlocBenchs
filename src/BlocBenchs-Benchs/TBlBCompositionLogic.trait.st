Trait {
	#name : #TBlBCompositionLogic,
	#category : #'BlocBenchs-Benchs'
}

{ #category : #accessing }
TBlBCompositionLogic >> figureExtent [

	^ 25 asPoint
]

{ #category : #accessing }
TBlBCompositionLogic >> layerExtent [

	^ self logicalExtent / 1.5
]

{ #category : #accessing }
TBlBCompositionLogic >> logicalExtent [

	^ 700 @ 700
]

{ #category : #hook }
TBlBCompositionLogic >> nextLocation: random [

	^ (random nextInteger: self layerExtent x - self figureExtent x)
	  @ (random nextInteger: self layerExtent y - self figureExtent y)
]

{ #category : #accessing }
TBlBCompositionLogic >> numberOfFigures [

	^ 5000
]
