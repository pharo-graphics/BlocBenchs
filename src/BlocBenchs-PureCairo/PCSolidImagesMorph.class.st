Class {
	#name : #PCSolidImagesMorph,
	#superclass : #PCTranslatingFiguresMorph,
	#instVars : [
		'surfaces',
		'extents'
	],
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #drawing }
PCSolidImagesMorph >> drawOnCairoCanvas [

	| index deltaY |
	self clearCairoCanvas.

	deltaY := deltaYPerMS * (lastMS - startMS).
	index := 1.

	1 to: case numberOfColumns do: [ :col |
		| positionX |
		positionX := case figureOffset x + col * case horizontalSeparation - 380.0. "WHY?"

		1 to: case numberOfRows do: [ :row |

			| positionY extent |
			positionY := case figureOffset y + (row * case horizontalSeparation) + deltaY.
			extent := extents at: index.

			cairoCanvas
				primSetSourceSurface: (surfaces at: index)
					x: positionX
					y: positionY;
				primRectangleX: positionX
					y: positionY
					width: extent x
					height: extent y;
				fill.

			index := index + 1 ]]

]

{ #category : #drawing }
PCSolidImagesMorph >> prepareFirstDraw [

	super prepareFirstDraw.

	surfaces := OrderedCollection new.
	extents := OrderedCollection new.
	1 to: case numberOfColumns * case numberOfRows do: [ :each | 
		| aForm |
		aForm := case newFormWith: random.
		surfaces add: (AthensCairoSurface fromForm: aForm).
		extents add: aForm extent ].
	surfaces := surfaces asArray.
	extents := extents asArray.

]
