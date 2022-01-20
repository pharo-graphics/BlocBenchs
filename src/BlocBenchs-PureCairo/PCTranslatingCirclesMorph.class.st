Class {
	#name : #PCTranslatingCirclesMorph,
	#superclass : #PCMorph,
	#instVars : [
		'numberOfCircles',
		'circleColors',
		'radius'
	],
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #drawing }
PCTranslatingCirclesMorph >> drawOnCairoCanvas [

	| deltaY |

	"Prepare on first draw (when nil)"
	circleColors
		ifNil: [
			deltaY := 0.
			circleColors := (1 to: numberOfCircles)
				collect: [ :each | Color random: random ] ]
		ifNotNil: [
			deltaY := 0.04 * (lastMS - startMS) ].

	"Clear background (https://www.cairographics.org/FAQ/#clear_a_surface)"
	cairoCanvas
		primSetSourceR: 1.0 g: 1.0 b: 1.0;
		primPaint.

	circleColors withIndexDo: [ :aColor :index |
		| center |
		center := radius + (index * 2 @ deltaY).
		cairoCanvas
			primSetSourceR: aColor red
				g: aColor green
				b: aColor blue;
			primArcCenterX: center x
				centerY: center y
				radius: radius x "TODO: ellipse"
				startAngle: 0.0
				endAngle: Float twoPi.

		cairoCanvas fill.
		"cairoCanvas stroke."
		"cairoCanvas fillPreserve; stroke."
		]
]

{ #category : #drawing }
PCTranslatingCirclesMorph >> initialize [

	super initialize.
	
	numberOfCircles := 50.
	radius := 50.0 asPoint.
]

{ #category : #accessing }
PCTranslatingCirclesMorph >> numberOfCircles [

	^ numberOfCircles
]

{ #category : #accessing }
PCTranslatingCirclesMorph >> numberOfCircles: anInteger [

	numberOfCircles := anInteger
]

{ #category : #accessing }
PCTranslatingCirclesMorph >> radius [

	^ radius
]

{ #category : #accessing }
PCTranslatingCirclesMorph >> radius: aPoint [

	radius := aPoint
]
