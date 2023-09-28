Class {
	#name : 'PCSolidImagesWindow',
	#superclass : 'PCTranslatingFiguresWindow',
	#instVars : [
		'patterns'
	],
	#category : 'BlocBenchs-FPS-Raw',
	#package : 'BlocBenchs-FPS',
	#tag : 'Raw'
}

{ #category : 'drawing' }
PCSolidImagesWindow >> drawOnCairoSurface [

	| deltaY tmpMatrix patternStream |
	super drawOnCairoSurface.

	deltaY := deltaYPerMS * (lastMS - startMS).
	tmpMatrix := AeCairoMatrix new.
	patternStream := patterns readStream.

	1 to: case numberOfColumns do: [ :columnIndex |
		| positionX positionY |
		positionX := ((case figureOffset x + columnIndex) * case offsetBetweenFigures x) - 380.0. "WHY?"
		positionY := case figureOffset y + deltaY.

		1 to: case numberOfRows do: [ :rowIndex |
			| aPattern |
			positionY := positionY + case offsetBetweenFigures y.

			aPattern := patternStream next.
			"The pattern translation must be negated, as Cairo doc explains."
			tmpMatrix beTranslationByX: positionX negated y: positionY negated.
			aPattern matrix: tmpMatrix.

			cairoContext
				source: aPattern;
				paint

		]]

]

{ #category : 'drawing' }
PCSolidImagesWindow >> resetAnimation [

	super resetAnimation.

	patterns := Array streamContents: [ :stream |
		(case numberOfColumns * case numberOfRows) timesRepeat: [
			| aForm aPattern |
			aForm := case newFormWith: random.
			aPattern := AeCairoSurfacePattern surface: (AeCairoImageSurface fromForm: aForm).
			aPattern filter: AeCairoSamplingFilter CAIRO_FILTER_FAST.
			stream nextPut: aPattern ] ]

]
