Class {
	#name : #BlBSolidImagesRawCase,
	#superclass : #BlBRawCase,
	#traits : 'TBlBAbstractImagesLogic',
	#classTraits : 'TBlBAbstractImagesLogic classTrait',
	#instVars : [
		'patterns',
		'random',
		'deltaYPerMS'
	],
	#category : #'BlocBenchs-Benchs-Raw'
}

{ #category : #drawing }
BlBSolidImagesRawCase >> drawOnCairoSurface [

	| deltaY tmpMatrix patternStream |
	self clearCairoSurface.

	deltaY := deltaYPerMS * (lastMS - startMS).
	tmpMatrix := AeCairoMatrix new.
	patternStream := patterns readStream.

	1 to: self numberOfColumns do: [ :columnIndex |
		| positionX positionY |
		positionX := ((self figureOffset x + columnIndex) * self offsetBetweenFigures x) - 380.0. "WHY?"
		positionY := self figureOffset y + deltaY.

		1 to: self numberOfRows do: [ :rowIndex |
			| aPattern |
			positionY := positionY + self offsetBetweenFigures y.

			aPattern := patternStream next.
			"The pattern translation must be negated, as Cairo doc explains."
			tmpMatrix beTranslationByX: positionX negated y: positionY negated.
			aPattern matrix: tmpMatrix.

			cairoContext
				source: aPattern;
				paint

		]]

]

{ #category : #hook }
BlBSolidImagesRawCase >> figureOffset [

	^ 20 @ 20
]

{ #category : #drawing }
BlBSolidImagesRawCase >> setupMainTexture [ 

	super setupMainTexture.

	random := self newRandom.

	"Convert from Fraction, since Fraction>>* is slow and at the end, cairo expects a Float"
	deltaYPerMS := (self targetTranslation y / self numberOfMilliseconds) asFloat.

	patterns := Array streamContents: [ :stream |
		(self numberOfColumns * self numberOfRows) timesRepeat: [
			| aForm aPattern |
			aForm := self newFormWith: random.
			aPattern := AeCairoSurfacePattern surface: (AeCairoImageSurface fromForm: aForm).
			aPattern filter: AeCairoSamplingFilter fast.
			stream nextPut: aPattern ] ]

]

{ #category : #accessing }
BlBSolidImagesRawCase >> targetTranslation [

	^ 0 @ 200
]
