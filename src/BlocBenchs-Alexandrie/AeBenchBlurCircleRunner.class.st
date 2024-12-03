"
Compare several implementations to paint a blurred circle.
"
Class {
	#name : #AeBenchBlurCircleRunner,
	#superclass : #Object,
	#traits : 'AeTBenchBlurRunner',
	#classTraits : 'AeTBenchBlurRunner classTrait',
	#instVars : [
		'mainSurface',
		'mainContext',
		'shadowColor',
		'shadowRamp',
		'blurRadius',
		'circleRadius',
		'circleCenter',
		'changedRadius',
		'centerOffset',
		'zoom'
	],
	#category : #'BlocBenchs-Alexandrie-Blur'
}

{ #category : #'instance creation' }
AeBenchBlurCircleRunner class >> new [

	^ self newFor: 17
]

{ #category : #'as yet unclassified' }
AeBenchBlurCircleRunner class >> newFor: aBlurRadius [

	^ self newFor: aBlurRadius blurRadius: aBlurRadius
]

{ #category : #'as yet unclassified' }
AeBenchBlurCircleRunner class >> newFor: aCircleRadius blurRadius: aBlurRadius [

	^ self basicNew
		initializeFor: aCircleRadius blurRadius: aBlurRadius;
		yourself
]

{ #category : #initialization }
AeBenchBlurCircleRunner >> initializeFor: aCircleRadius blurRadius: aBlurRadius [

	self initialize.

	circleRadius := aCircleRadius.
	blurRadius := aBlurRadius.

	"Margin for the blur"
	changedRadius := blurRadius * 1.5.

	circleCenter := (circleRadius + changedRadius) asPoint.

	zoom := 2.
	mainSurface := AeCairoImageSurface
		extent: (circleCenter * 2) ceiling * zoom
		format: AeCairoSurfaceFormat argb32.
	mainSurface deviceScale: zoom asPoint.
	mainContext := mainSurface newContext.

	"Background is same for all runs"
	mainContext sourceColor: Color yellow; paint.

	"The ramp defines all stops, playing with alpha channel"
	shadowColor := Color blue.
	shadowRamp := Array streamContents: [ :stream |
		self
			rampSize: changedRadius asInteger
			stopsAndAlphasDo: [ :eachStop :eachAlpha |
				stream nextPut:
					(eachStop -> (shadowColor alpha: eachAlpha)) ] ]
]

{ #category : #printing }
AeBenchBlurCircleRunner >> printOn: aStream [
	"Generate a string representation of the receiver based on its instance variables."

	super printOn: aStream.
	aStream
		nextPutAll: '(blurRadius: ';
		print: blurRadius;
		nextPutAll: ' rampSize: ';
		print: shadowRamp size;
		nextPutAll: ' surfaceExtent: ';
		print: mainSurface extent;
		nextPut: $)
]

{ #category : #'as yet unclassified' }
AeBenchBlurCircleRunner >> rampFunctionAt: x [
	"Answer the evaluation of a number scaled by 4.0 in a Gaussian function with mu=0.0 and sigma=1.0, whoose peak a 0.0 results in 1.0."

	^ ((4.0 * x) squared * -0.5) exp
]

{ #category : #'as yet unclassified' }
AeBenchBlurCircleRunner >> rampSize: rampSize stopsAndAlphasDo: aBlock [

	aBlock value: 0.0 value: 1.0.

	1 to: rampSize - 2 do: [ :i |
		| stop |
		stop := i / (rampSize - 1) asFloat.
		aBlock
			value: stop
			value: (self rampFunctionAt: stop) ].

	aBlock value: 1.0 value: 0.0
]

{ #category : #'as yet unclassified' }
AeBenchBlurCircleRunner >> runDirect [
	<script: 'self new runDirect inspect'>

	| aGradient |
	aGradient := AeCairoRadialGradientPattern
		innerCenter: circleCenter
		innerRadius: circleRadius - (blurRadius / 1.5)
		outerCenter: circleCenter
		outerRadius: circleRadius + changedRadius.
	aGradient addStopsFrom: shadowRamp.

	mainContext source: aGradient; paint.

	"Force free to include this time in the benchmarks"
	aGradient externallyFree.


	^ mainSurface
]

{ #category : #'as yet unclassified' }
AeBenchBlurCircleRunner >> runGaussian [
	<script: 'self new runGaussian inspect'>

	| shadowSurface |
	shadowSurface := AeCairoImageSurface
		extent: mainSurface extent
		format: AeCairoSurfaceFormat a8.

	shadowSurface newContext
		sourceColor: Color black;
		circleCenter: circleCenter radius: circleRadius;
		fill.

	AeCairoA8FastGaussianBlurFilter new
		surface: shadowSurface;
		applyRadius: blurRadius.

	mainSurface newContext
		sourceColor: shadowColor;
		maskSurface: shadowSurface x: 0.0 y: 0.0.
	
	^ mainSurface
]

{ #category : #'as yet unclassified' }
AeBenchBlurCircleRunner >> runMaskFull [
	<script: 'self new runMaskFull inspect'>

	| shadowSurface shadowContext aGradient |
	shadowSurface := AeCairoImageSurface
		extent: (circleCenter * 2) ceiling * zoom
		format: AeCairoSurfaceFormat a8.
	shadowSurface deviceScale: zoom asPoint.
	shadowContext := shadowSurface newContext.

	aGradient := AeCairoRadialGradientPattern
		innerCenter: circleCenter
		innerRadius: circleRadius - (blurRadius / 1.5)
		outerCenter: circleCenter
		outerRadius: circleRadius + changedRadius.
	aGradient addStopsFrom: shadowRamp.
	shadowContext
		source: aGradient;
		paint.

	mainContext
		sourceColor: shadowColor;
		maskSurface: shadowSurface x: 0.0 y: 0.0.

	"Force free to include this time in the benchmarks"
	aGradient externallyFree.
	shadowContext externallyFree.
	shadowSurface externallyFree.


	^ mainSurface
]

{ #category : #'as yet unclassified' }
AeBenchBlurCircleRunner >> runMaskQuadrantClipping [
	<script: 'self new runMaskQuadrantClipping inspect'>

	| shadowSurface shadowContext aGradient aMatrix matrixBlocks quadrantExtent fix rects |
	quadrantExtent := circleCenter ceiling.
	fix := (quadrantExtent - circleCenter) ceiling. "A point with 0 or 1 coordinates"

	shadowSurface := AeCairoImageSurface
		extent: quadrantExtent * zoom
		format: AeCairoSurfaceFormat a8.
	shadowSurface deviceScale: zoom asPoint.
	shadowContext := shadowSurface newContext.

	aGradient := AeCairoRadialGradientPattern
		innerCenter: fix
		innerRadius: circleRadius - (blurRadius / 1.5)
		outerCenter: fix
		outerRadius: circleRadius + changedRadius.
	aGradient addStopsFrom: shadowRamp.
	shadowContext
		source: aGradient;
		paint.

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
		quadrantExtent x @ 0 extent: quadrantExtent.
		}.

	mainContext sourceColor: shadowColor.
	matrixBlocks with: rects do: [ :eachMatrixBlock :rect |
		eachMatrixBlock value.
		mainContext
			saveState;
			rectangle: rect; clip;
			matrix: aMatrix;
			maskSurface: shadowSurface x: 0.0 y: 0.0;
			restoreState ].

	"Force free to include this time in the benchmarks"
	aMatrix free.
	aGradient externallyFree.
	shadowContext externallyFree.
	shadowSurface externallyFree.


	^ mainSurface
]

{ #category : #'as yet unclassified' }
AeBenchBlurCircleRunner >> runPaintQuadrantReflected [
	<script: 'self new runPaintQuadrantReflected inspect'>

	| shadowSurface shadowContext aGradient |
	shadowSurface := AeCairoImageSurface
		extent: circleCenter ceiling * zoom
		format: AeCairoSurfaceFormat argb32.
	shadowSurface deviceScale: zoom asPoint.
	shadowContext := shadowSurface newContext.

	aGradient := AeCairoRadialGradientPattern
		innerCenter: circleCenter
		innerRadius: circleRadius - (blurRadius / 1.5)
		outerCenter: circleCenter
		outerRadius: circleRadius + changedRadius.
	aGradient addStopsFrom: shadowRamp.
	shadowContext
		source: aGradient;
		paint.

	mainContext sourceSurface: shadowSurface.
	mainContext source extend: AeCairoExtendMode reflect.
	mainContext paint.

	"Force free to include this time in the benchmarks"
	aGradient externallyFree.
	shadowContext externallyFree.
	shadowSurface externallyFree.


	^ mainSurface
]
