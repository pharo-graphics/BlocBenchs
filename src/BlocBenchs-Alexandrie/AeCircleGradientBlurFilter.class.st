Class {
	#name : #AeCircleGradientBlurFilter,
	#superclass : #AeGradientBlurFilter,
	#instVars : [
		'circleCenter',
		'circleRadius',
		'zoom'
	],
	#category : #'BlocBenchs-Alexandrie-Blur'
}

{ #category : #initialization }
AeCircleGradientBlurFilter >> draw [

	| maskSurface maskContext aGradient aMatrix matrixBlocks quadrantExtent fix rects |
	quadrantExtent := circleCenter ceiling.
	fix := (quadrantExtent - circleCenter) ceiling. "A point with 0 or 1 coordinates"

	maskSurface := AeCairoImageSurface
		extent: quadrantExtent * zoom
		format: AeCairoSurfaceFormat a8.
	maskSurface deviceScale: zoom asPoint.
	maskContext := maskSurface newContext.

	aGradient := AeCairoRadialGradientPattern
		center: fix
		innerRadius: circleRadius - blurMargin
		outerRadius: circleRadius + blurMargin.
	aGradient addStopsFrom: ramp.
	
	maskContext sourcePattern: aGradient; paint.

	aMatrix := AeCairoMatrix new.
	matrixBlocks := {
		[ aMatrix
			beTranslationByX: circleCenter x - fix x y: circleCenter y - fix y ].
		[ aMatrix
			beFlipHorizontallyAround: 0.0;
			translateByX: circleCenter x negated - fix x y: circleCenter y - fix y ].
		[ aMatrix
			beFlipBothAroundX: 0.0 y: 0.0;
			translateByX: circleCenter x negated - fix x y: circleCenter y negated - fix y ].
		[ aMatrix
			beFlipVerticallyAround: 0.0;
			translateByX: circleCenter x - fix x  y: circleCenter y negated - fix y ] }.

	rects := {
		quadrantExtent extent: quadrantExtent.
		0 @ quadrantExtent y extent: quadrantExtent.
		0 @ 0 extent: quadrantExtent.
		quadrantExtent x @ 0 extent: quadrantExtent }.

	context sourceColor: color.
	matrixBlocks with: rects do: [ :eachMatrixBlock :rect |
		eachMatrixBlock value.
		context
			saveState;
			rectangle: rect; clip;
			matrix: aMatrix;
			maskSurface: maskSurface;
			restoreState ].

	"Force free to include this time in the benchmarks"
	aMatrix free.
	aGradient externallyFree.
	maskContext externallyFree.
	maskSurface externallyFree
]

{ #category : #initialization }
AeCircleGradientBlurFilter >> initializeFor: aContext center: aPoint radius: aCircleRadius sigma: aSigma color: aColor [

	self initialize.

	context := aContext.
	color := aColor.
	
	blurMargin := (aSigma * Float pi) ceiling.

	zoom := 1.0. "Should be context actual zoom i.e. scale * deviceScale"
	
	circleCenter := aPoint.
	circleRadius := aCircleRadius.

	"The ramp defines all stops, playing with alpha channel"
	ramp := AeBenchBlurCircleRunner basicNew shadowRampSize: blurMargin
]
