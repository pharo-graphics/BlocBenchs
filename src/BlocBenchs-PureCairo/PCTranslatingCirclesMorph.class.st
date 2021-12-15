Class {
	#name : #PCTranslatingCirclesMorph,
	#superclass : #PCMorph,
	#instVars : [
		'lastMS',
		'numberOfCircles',
		'deltaY',
		'circleColors',
		'radius',
		'transform',
		'pathBuilder'
	],
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #drawing }
PCTranslatingCirclesMorph >> drawOnAthensCanvas: aCanvas [

	circleColors
		ifNil: [
			"Prepare on first draw"
			deltaY := 0.
			circleColors := (1 to: numberOfCircles)
				collect: [ :each | Color random: random ].
			transform := AthensCairoTransform for: aCanvas.
			pathBuilder := AthensCairoPathBuilder new.
			pathBuilder context: aCanvas ]
		ifNotNil: [
			"Already prepared"
			deltaY := deltaY + (0.04 * (Time millisecondClockValue - lastMS)) ].
	lastMS := Time millisecondClockValue.

	"Clear background (https://www.cairographics.org/FAQ/#clear_a_surface)"
	aCanvas
		primSaveState;
		primSetSourceR: 1 g: 1 b: 1 a: 1;
		primPaint;
		primRestoreState.
"	surface clear: Color white."

	circleColors withIndexDo: [ :aColor :index | 
		aCanvas primSaveState.

		transform translateBy: radius asPoint + (index * 2 @ deltaY).
		aCanvas
			primSetSourceR: aColor red
			g: aColor green
			b: aColor blue
			a: 1.
		pathBuilder
			arcCenterX: 0.0
			centerY: 0.0
			radius: radius
			startAngle: 0.0
			endAngle: Float twoPi.
		aCanvas fill.

		aCanvas primRestoreState ]
]

{ #category : #drawing }
PCTranslatingCirclesMorph >> initialize [

	super initialize.
	
	numberOfCircles := 50.
	radius := 50.0.
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
PCTranslatingCirclesMorph >> radius: anObject [

	radius := anObject
]
