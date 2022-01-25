Class {
	#name : #PCTranslatingCirclesMorph,
	#superclass : #PCMorph,
	#instVars : [
		'radius',
		'numberOfFigures',
		'backgroundColors',
		'figureOffset',
		'windowColor'
	],
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #drawing }
PCTranslatingCirclesMorph >> drawOnCairoCanvas [


	"Prepare on first draw (when nil)"
	backgroundColors ifNil: [
		windowColor := PCFloatColor newFrom: Color white.
		backgroundColors := (1 to: numberOfFigures)
			collect: [ :each | PCFloatColor newRandom: random ] ].


	"Clear background (https://www.cairographics.org/FAQ/#clear_a_surface)"
	cairoCanvas
		primSetSourceRGBColor: windowColor;
		primPaint.

	backgroundColors withIndexDo: [ :aColor :index |
		self setBackgroundPathOnCairoCanvasIndex: index.

		cairoCanvas
			primSetSourceRGBColor: aColor;
			fill
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
PCTranslatingCirclesMorph >> setBackgroundPathOnCairoCanvasIndex: index [

	| center deltaY |
	deltaY := 0.04 * (lastMS - startMS).
	center := figureOffset + radius + (index * 2 @ deltaY).

	cairoCanvas
		primArcCenterX: center x
			centerY: center y
			radius: radius x "TODO: non-circular ellipse"
			startAngle: 0.0
			endAngle: Float twoPi.

]
