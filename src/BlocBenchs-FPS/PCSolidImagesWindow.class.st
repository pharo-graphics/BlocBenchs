Class {
	#name : #PCSolidImagesWindow,
	#superclass : #PCTranslatingFiguresWindow,
	#instVars : [
		'surfaces',
		'extents'
	],
	#category : #'BlocBenchs-FPS-Raw'
}

{ #category : #drawing }
PCSolidImagesWindow >> drawOnCairoSurface [

	| index deltaY |
	super drawOnCairoSurface.

	deltaY := deltaYPerMS * (lastMS - startMS).
	index := 1.

	1 to: case numberOfColumns do: [ :col |
		| positionX |
		positionX := case figureOffset x + col * case horizontalSeparation - 380.0. "WHY?"

		1 to: case numberOfRows do: [ :row |

			| positionY extent |
			positionY := case figureOffset y + (row * case horizontalSeparation) + deltaY.
			extent := extents at: index.

			cairoContext
				primSetSourceSurface: (surfaces at: index)
					x: positionX
					y: positionY;
				primRectangleX: positionX
					y: positionY
					width: extent x
					height: extent y;
				primFill.

			index := index + 1 ]]

]

{ #category : #drawing }
PCSolidImagesWindow >> resetAnimation [

	super resetAnimation.

	surfaces := OrderedCollection new.
	extents := OrderedCollection new.
	1 to: case numberOfColumns * case numberOfRows do: [ :each | 
		| aForm |
		aForm := case newFormWith: random.
		surfaces add: (AeCairoImageSurface fromForm: aForm).
		extents add: aForm extent ].
	surfaces := surfaces asArray.
	extents := extents asArray.

]