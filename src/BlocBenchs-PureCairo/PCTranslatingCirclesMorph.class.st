Class {
	#name : #PCTranslatingCirclesMorph,
	#superclass : #PCMorph,
	#instVars : [
		'radius',
		'numberOfFigures',
		'backgroundColors',
		'figureOffset'
	],
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #drawing }
PCTranslatingCirclesMorph >> drawOnCairoCanvas [

	| deltaY |

	"Prepare on first draw (when nil)"
	backgroundColors
		ifNil: [
			deltaY := 0.
			backgroundColors := (1 to: numberOfFigures)
				collect: [ :each | Color random: random ] ]
		ifNotNil: [
			deltaY := 0.04 * (lastMS - startMS) ].

	"Clear background (https://www.cairographics.org/FAQ/#clear_a_surface)"
	cairoCanvas
		primSetSourceR: 1.0 g: 1.0 b: 1.0;
		primPaint.

	backgroundColors withIndexDo: [ :aColor :index |
		self setBackgroundPathOnCairoCanvasIndex: index deltaY: deltaY.

		cairoCanvas
			primSetSourceR: aColor red
				g: aColor green
				b: aColor blue.
		cairoCanvas fill.
		"cairoCanvas stroke."
"		cairoCanvas fillPreserve; stroke."
		]
]

{ #category : #accessing }
PCTranslatingCirclesMorph >> figureOffset [

	^ figureOffset
]

{ #category : #accessing }
PCTranslatingCirclesMorph >> figureOffset: anObject [

	figureOffset := anObject
]

{ #category : #accessing }
PCTranslatingCirclesMorph >> numberOfFigures [

	^ numberOfFigures
]

{ #category : #accessing }
PCTranslatingCirclesMorph >> numberOfFigures: anInteger [

	numberOfFigures := anInteger
]

{ #category : #accessing }
PCTranslatingCirclesMorph >> radius [

	^ radius
]

{ #category : #accessing }
PCTranslatingCirclesMorph >> radius: aPoint [

	radius := aPoint
]

{ #category : #drawing }
PCTranslatingCirclesMorph >> setBackgroundPathOnCairoCanvasIndex: index deltaY: deltaY [

		| center |
		center := figureOffset + radius + (index * 2 @ deltaY).
		cairoCanvas
			primArcCenterX: center x
				centerY: center y
				radius: radius x "TODO: non-circular ellipse"
				startAngle: 0.0
				endAngle: Float twoPi.

]
