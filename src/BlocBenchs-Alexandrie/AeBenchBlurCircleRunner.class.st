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
		'circleRadius',
		'circleCenter',
		'centerOffset',
		'zoom',
		'blurSigma',
		'margin'
	],
	#category : #'BlocBenchs-Alexandrie-Blur'
}

{ #category : #'instance creation' }
AeBenchBlurCircleRunner class >> new [

	^ self newFor: 10
]

{ #category : #'instance creation' }
AeBenchBlurCircleRunner class >> newFor: aBlurSigma [

	"See margin at instance initialization"
	^ self newFor: aBlurSigma * Float pi + 1 blurSigma: aBlurSigma
]

{ #category : #'instance creation' }
AeBenchBlurCircleRunner class >> newFor: aCircleRadius blurSigma: aBlurSigma [

	^ self basicNew
		initializeFor: aCircleRadius blurSigma: aBlurSigma;
		yourself
]

{ #category : #debugging }
AeBenchBlurCircleRunner >> diffsBySigmas [
	<script: 'self new diffsBySigmas inspect'>

	| dict |
	dict := OrderedDictionary new.

	2 to: 15 by: 1 do: [ :sigma |
		dict
			at: sigma
			put:
				(AePixelComparison
					expectedForm: ((self class newFor: sigma) runGaussian) asForm 
					actualForm: ((self class newFor: sigma) runDirect) asForm
					label: '') ].
	^ dict
]

{ #category : #initialization }
AeBenchBlurCircleRunner >> initializeFor: aCircleRadius blurSigma: aSigma [

	self initialize.

	circleRadius := aCircleRadius.
	blurSigma := aSigma.
	margin := (blurSigma * Float pi) ceiling."floor."

	circleCenter := (circleRadius + margin) asPoint.

	zoom := 1.
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
			rampSize: margin asInteger
			stopsAndAlphasDo: [ :eachStop :eachAlpha |
				stream nextPut:
					(eachStop -> (shadowColor alpha: eachAlpha)) ] ]
]

{ #category : #debugging }
AeBenchBlurCircleRunner >> plotsBySigmas [
	<script: 'self new plotsBySigmas inspect'>

	| dict |
	dict := OrderedDictionary new.

	2 to: 20 by: 2 do: [ :sigma |
		dict
			at: sigma
			put:
				(AePixelComparison
					expectedForm: ((self class newFor: sigma) runGaussian) asForm 
					actualForm: ((self class newFor: sigma) runDirect) asForm
					label: '') ].

	^ dict collect: [ :each |
		| halfW halfH sampleActual sampleExpected indexOfMax |
		halfW := each comparableWidth // 2.
		halfH := each comparableHeight // 2.

		sampleActual := (1 to: halfW) collect: [ :x |
			(each actualForm colorAt: x-1 @ halfH) blue ].
		sampleExpected := (1 to: halfW) collect: [ :x |
			(each expectedForm colorAt: x-1 @ halfH) blue ].
		indexOfMax := sampleExpected
			detectIndex: [ :s | s = sampleExpected max ].
		sampleActual := sampleActual first: indexOfMax.
		sampleExpected := sampleExpected first: indexOfMax.

		((RSScatterPlot x: (1 to: sampleExpected size) y: sampleExpected ) color: Color black)
		+ ((RSScatterPlot x: (1 to: sampleActual size) y: sampleActual ) color: Color green) ]
]

{ #category : #printing }
AeBenchBlurCircleRunner >> printOn: aStream [
	"Generate a string representation of the receiver based on its instance variables."

	super printOn: aStream.
	aStream
		nextPutAll: '(blurRadius: ';
		print: blurSigma;
		nextPutAll: ' rampSize: ';
		print: shadowRamp size;
		nextPutAll: ' surfaceExtent: ';
		print: mainSurface extent;
		nextPut: $)
]

{ #category : #initialization }
AeBenchBlurCircleRunner >> rampFunctionAt: x [
	"Evaluate 1.0 minus a sigmoid (logistic) function, with mu and sigma determined manually by try and error."

	^ 1.0 - (1.0 / (1.0 + (((x - 0.475) * -10.0) exp)))
]

{ #category : #initialization }
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

{ #category : #running }
AeBenchBlurCircleRunner >> runDirect [
	<script: 'self new runDirect inspect'>

	| aGradient |
	aGradient := AeCairoRadialGradientPattern
		innerCenter: circleCenter
		innerRadius: circleRadius - margin
		outerCenter: circleCenter
		outerRadius: circleRadius + margin.
	aGradient addStopsFrom: shadowRamp.

	mainContext source: aGradient; paint.

	"Force free to include this time in the benchmarks"
	aGradient externallyFree.


	^ mainSurface
]

{ #category : #running }
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
		applySigma: blurSigma.

	mainSurface newContext
		sourceColor: shadowColor;
		maskSurface: shadowSurface.
	
	^ mainSurface
]

{ #category : #running }
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
		innerRadius: circleRadius - margin
		outerCenter: circleCenter
		outerRadius: circleRadius + margin.
	aGradient addStopsFrom: shadowRamp.
	
	shadowContext source: aGradient; paint.

	mainContext
		sourceColor: shadowColor;
		maskSurface: shadowSurface.

	"Force free to include this time in the benchmarks"
	aGradient externallyFree.
	shadowContext externallyFree.
	shadowSurface externallyFree.


	^ mainSurface
]

{ #category : #running }
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
		innerRadius: circleRadius - margin
		outerCenter: fix
		outerRadius: circleRadius + margin.
	aGradient addStopsFrom: shadowRamp.
	
	shadowContext source: aGradient; paint.

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

	mainContext sourceColor: shadowColor.
	matrixBlocks with: rects do: [ :eachMatrixBlock :rect |
		eachMatrixBlock value.
		mainContext
			saveState;
			rectangle: rect; clip;
			matrix: aMatrix;
			maskSurface: shadowSurface;
			restoreState ].

	"Force free to include this time in the benchmarks"
	aMatrix free.
	aGradient externallyFree.
	shadowContext externallyFree.
	shadowSurface externallyFree.


	^ mainSurface
]

{ #category : #running }
AeBenchBlurCircleRunner >> runPaintQuadrantReflected [
	<script: 'self new runPaintQuadrantReflected inspect'>

	| shadowSurface shadowContext aGradient |
	shadowSurface := AeCairoImageSurface
		extent: circleCenter floor * zoom
		format: AeCairoSurfaceFormat argb32.
	shadowSurface deviceScale: zoom asPoint.
	shadowContext := shadowSurface newContext.

	aGradient := AeCairoRadialGradientPattern
		innerCenter: circleCenter
		innerRadius: circleRadius - margin
		outerCenter: circleCenter
		outerRadius: circleRadius + margin.
	aGradient addStopsFrom: shadowRamp.
	
	shadowContext source: aGradient; paint.

	mainContext sourceSurface: shadowSurface.
	mainContext source extend: AeCairoExtendMode reflect.
	mainContext paint.

	"Force free to include this time in the benchmarks"
	aGradient externallyFree.
	shadowContext externallyFree.
	shadowSurface externallyFree.


	^ mainSurface
]
