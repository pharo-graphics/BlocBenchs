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
		'circleRadius',
		'circleCenter',
		'zoom',
		'blurSigma',
		'blurMargin',
		'ramp'
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
	blurMargin := (blurSigma * Float pi) ceiling.

	circleCenter := (circleRadius + blurMargin) asPoint.

	zoom := 1.
	mainSurface := AeCairoImageSurface
		extent: (circleCenter * 2) ceiling * zoom
		format: AeCairoSurfaceFormat argb32.
	mainSurface deviceScale: zoom asPoint.
	mainContext := mainSurface newContext.

	"Background is same for all runs"
	mainContext sourceColor: Color yellow; paint.

	"The ramp defines all stops, playing with alpha channel"
	ramp := self shadowRampSize: blurMargin
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
		nextPutAll: '(blurSigma: ';
		print: blurSigma;
		nextPutAll: ' surfaceExtent: ';
		print: mainSurface extent;
		nextPut: $)
]

{ #category : #running }
AeBenchBlurCircleRunner >> runDirect [
	<script: 'self new runDirect inspect'>

	| aGradient |
	aGradient := AeCairoRadialGradientPattern
		center: circleCenter
		innerRadius: circleRadius - blurMargin
		outerRadius: circleRadius + blurMargin.
	aGradient addStopsFrom: ramp.

	mainContext
		sourcePattern: aGradient;
		paintWithAlpha: self shadowColor alpha.

	"Force free to include this time in the benchmarks"
	aGradient externallyFree.


	^ mainSurface
]

{ #category : #running }
AeBenchBlurCircleRunner >> runFilter [
	<script: 'self new runFilter inspect'>

	AeCircleGradientBlurFilter new
		blurSigma: blurSigma color: self shadowColor;
		center: circleCenter radius: circleRadius;
		drawOn: mainContext.

	^ mainSurface
]

{ #category : #running }
AeBenchBlurCircleRunner >> runGaussian [
	<script: 'self new runGaussian inspect'>

	| blurSurface |
	blurSurface := AeCairoImageSurface
		extent: mainSurface extent
		format: AeCairoSurfaceFormat a8.

	blurSurface newContext
		matrix: mainContext matrix;
		sourceColor: Color black;
		circleCenter: circleCenter radius: circleRadius;
		fill.

	AeCairoA8FastGaussianBlurFilter new
		surface: blurSurface;
		applySigma: blurSigma.

	mainSurface newContext
		sourceColor: self shadowColor;
		maskSurface: blurSurface.
	
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
		center: circleCenter
		innerRadius: circleRadius - blurMargin
		outerRadius: circleRadius + blurMargin.
	aGradient addStopsFrom: ramp.
	
	shadowContext
		sourcePattern: aGradient;
		paintWithAlpha: self shadowColor alpha.

	mainContext
		sourceColor: (self shadowColor alpha: 1.0); "alpha is already in the ramp"
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

	mainContext sourceColor: self shadowColor.
	matrixBlocks with: rects do: [ :eachMatrixBlock :rect |
		eachMatrixBlock value.
		mainContext
			saveState;
			rectangle: rect; clip;
			matrix: aMatrix;
			maskSurface: maskSurface;
			restoreState ].

	"Force free to include this time in the benchmarks"
	aMatrix free.
	aGradient externallyFree.
	maskContext externallyFree.
	maskSurface externallyFree.


	^ mainSurface
]

{ #category : #running }
AeBenchBlurCircleRunner >> runPaintQuadrantReflected [
	<script: 'self new runPaintQuadrantReflected inspect'>

	| blurSurface blurContext aGradient |
	blurSurface := AeCairoImageSurface
		extent: circleCenter floor * zoom
		format: AeCairoSurfaceFormat argb32.
	blurSurface deviceScale: zoom asPoint.
	blurContext := blurSurface newContext.

	aGradient := AeCairoRadialGradientPattern
		center: circleCenter
		innerRadius: circleRadius - blurMargin
		outerRadius: circleRadius + blurMargin.
	aGradient addStopsFrom: ramp.
	
	blurContext
		sourcePattern: aGradient;
		paintWithAlpha: self shadowColor alpha.

	mainContext sourceSurface: blurSurface.
	mainContext source extend: AeCairoExtendMode reflect.
	mainContext paint.

	"Force free to include this time in the benchmarks"
	aGradient externallyFree.
	blurContext externallyFree.
	blurSurface externallyFree.


	^ mainSurface
]
