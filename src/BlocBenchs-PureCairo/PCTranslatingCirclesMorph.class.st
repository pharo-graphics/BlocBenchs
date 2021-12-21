Class {
	#name : #PCTranslatingCirclesMorph,
	#superclass : #PCMorph,
	#instVars : [
		'lastMS',
		'numberOfCircles',
		'deltaY',
		'circleColors',
		'transform',
		'pathBuilder',
		'radius'
	],
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #drawing }
PCTranslatingCirclesMorph >> drawOnAthensCanvas: aCanvas [

	"Prepare on first draw (when nil)"
	circleColors
		ifNil: [
			deltaY := 0.
			circleColors := (1 to: numberOfCircles)
				collect: [ :each | Color random: random ].
			"transform := AthensCairoTransform for: aCanvas." ]
		ifNotNil: [
			deltaY := deltaY + (0.04 * (Time millisecondClockValue - lastMS)) ].
	lastMS := Time millisecondClockValue.

	"Clear background (https://www.cairographics.org/FAQ/#clear_a_surface)"
	aCanvas
		primSetSourceR: 1.0 g: 1.0 b: 1.0;
		primPaint.

	circleColors withIndexDo: [ :aColor :index |
		| center |
		aCanvas primSaveState.

		"transform translateBy: "
		center := radius + (index * 2 @ deltaY).
		aCanvas
			primSetSourceR: aColor red
				g: aColor green
				b: aColor blue;
			primArcCenterX: center x
				centerY: center y
				radius: radius x "todo: ellipse"
				startAngle: 0.0
				endAngle: Float twoPi.

		aCanvas fill.
		"aCanvas stroke."
		"aCanvas fillPreserve; stroke."

		aCanvas primRestoreState ]
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
