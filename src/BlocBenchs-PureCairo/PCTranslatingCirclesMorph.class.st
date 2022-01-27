Class {
	#name : #PCTranslatingCirclesMorph,
	#superclass : #PCMorph,
	#instVars : [
		'backgroundColors',
		'windowColor'
	],
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #drawing }
PCTranslatingCirclesMorph >> drawOnCairoCanvas [


	"Prepare on first draw (when nil)"
	backgroundColors ifNil: [
		windowColor := PCFloatColor newFrom: Color white.
		backgroundColors := (1 to: case numberOfFigures)
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

{ #category : #drawing }
PCTranslatingCirclesMorph >> setBackgroundPathOnCairoCanvasIndex: index [

	| center deltaY |
	deltaY := 0.04 * (lastMS - startMS).
	center := case figureOffset + case radius + (index * 2 @ deltaY).

	cairoCanvas
		primArcCenterX: center x
			centerY: center y
			radius: case radius x "TODO: non-circular ellipse"
			startAngle: 0.0
			endAngle: Float twoPi.

]
