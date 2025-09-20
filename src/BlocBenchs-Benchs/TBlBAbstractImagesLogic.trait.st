Trait {
	#name : #TBlBAbstractImagesLogic,
	#category : #'BlocBenchs-Benchs'
}

{ #category : #hook }
TBlBAbstractImagesLogic >> newFormWith: random [

	^ Smalltalk ui icons icons atRandom: random
]

{ #category : #accessing }
TBlBAbstractImagesLogic >> numberOfColumns [

	^ 30
]

{ #category : #accessing }
TBlBAbstractImagesLogic >> numberOfFigures [

	^ self numberOfColumns
]

{ #category : #accessing }
TBlBAbstractImagesLogic >> numberOfRows [

	^ 20
]

{ #category : #hook }
TBlBAbstractImagesLogic >> offsetBetweenFigures [

	^ 20 @ 10
]

{ #category : #hook }
TBlBAbstractImagesLogic >> spaceExtent [

	^ 700 @ 700
]
