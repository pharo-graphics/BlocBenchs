"
Compare several implementations to paint a blurred rectangle.

**1st question**: Which implementation is faster?

The best was `runSharingGradient`. 

On large shadow sizes such as 100, the difference is not significant. The number of pixels to process becomes more important.

On smaller shadow sizes, the differences are more relevant, in favor of `runSharingGradient`.


**2nd question**: How much faster is the shadow emulation with gradients?

The slowest implementation of shadows were 17x faster than `runGaussian` with blurRadius of 20 (from 4ms to 0.23ms). The improvement was 30x with blurRadius of 100 (from 117ms to 3.92ms).

**3nd question**: How much ""ramp size"" impacts performance?

A ramp size of 10 was 18% faster than a ramp size of 20 (with shadow size of 20).


Results for 1st and 2nd question. Run on a Macbook 2018 with cairo v1.17.4:
```
--- 20 blur radius ---
an AeBenchGradientRunner(blurRadius: 20 rampSize: 20 surfaceExtent: (120@90))
## runGaussian
average ms: 4
iterations: 213
## runMask
0.21ms ±0.00
## runNewCenteredGradients
0.23ms ±0.00
## runSharingGradient
0.17ms ±0.00

--- 100 blur radius ---
an AeBenchGradientRunner(blurRadius: 100 rampSize: 100 surfaceExtent: (600@450))
## runGaussian
average ms: 117
iterations: 9
## runMask
3.92ms ±0.07
## runNewCenteredGradients
3.73ms ±0.04
## runSharingGradient
3.47ms ±0.03
```

"
Class {
	#name : #AeBenchBlurRectangleRunner,
	#superclass : #Object,
	#traits : 'AeTBenchBlurRunner',
	#classTraits : 'AeTBenchBlurRunner classTrait',
	#instVars : [
		'mainSurface',
		'mainContext',
		'zoom',
		'blurSigma',
		'blurMargin',
		'rectangle',
		'core',
		'blurMargin2',
		'ramp',
		'rampMu',
		'rampK',
		'blurCorners',
		'blurSides'
	],
	#category : #'BlocBenchs-Alexandrie-Blur'
}

{ #category : #'instance creation' }
AeBenchBlurRectangleRunner class >> new [

	^ self newFor: 6
]

{ #category : #'instance creation' }
AeBenchBlurRectangleRunner class >> newFor: aBlurSigma [

	^ self basicNew
		initializeFor: aBlurSigma;
		yourself
]

{ #category : #initialization }
AeBenchBlurRectangleRunner >> initializeFor: aBlurSigma [

	| rectangleExtent |
	self initialize.

	blurSigma := aBlurSigma.
	blurMargin := (blurSigma * Float e) ceiling.
	blurMargin2 := blurMargin * 2.

	rectangleExtent := (blurMargin * 6) @ (blurMargin * 3). "make it non-squared for fun"
	rectangle := blurMargin asPoint extent: rectangleExtent. "This is the real ractangle that runGaussian blurs"
	core := rectangle insetBy: blurMargin "(blurMargin * 0.9) ceiling".
	rampMu := 0.475.
	rampK := -10.

	"blurMargin factor. inset. rampMu. rampK
	pi. 0.85. 0.45. .10.
	e. 
	
	"	
	zoom := 1.
	mainSurface := AeCairoImageSurface
		extent: (rectangleExtent + blurMargin2) * zoom
		format: AeCairoSurfaceFormat argb32.
	mainSurface deviceScale: zoom asPoint.
	mainContext := mainSurface newContext.
"	mainContext matrix: (AeCairoMatrix newIdentity shx: (-15 degreesToRadians tan); yourself)."
"	mainContext matrix: (AeCairoMatrix newIdentity
		rotateByRadians: 10 degreesToRadians center: mainSurface extent / 2;
		yourself)."
	mainContext antialias: AeCairoAntialias none. "<--- fixes gaps, and it's invisible"

	"Shared"
	mainContext sourceColor: Color yellow; paint. "Background"

	"The ramp defines all stops, playing with alpha channel"
	ramp := self shadowRampSize: blurMargin.

	blurCorners := {
		{	core topLeft.
			Rectangle
				left: core left - blurMargin2
				right: core left
				top: core top - blurMargin2
				bottom: core top }.
		{	core topRight.
			Rectangle
				left: core right
				right: core right + blurMargin2
				top: core top - blurMargin2
				bottom: core top }.
		{	core bottomRight.
			Rectangle
				left: core right
				right: core right + blurMargin2
				top: core bottom
				bottom: core bottom + blurMargin2 }.
		{	core bottomLeft.
			Rectangle
				left: core left - blurMargin2
				right: core left
				top: core bottom
				bottom: core bottom + blurMargin2 }.
		}.
	
	blurSides := {
		{	0 @ core top.
			0 @ (core top - blurMargin2).
		 	(Rectangle
				left: core left
				right: core right
				top: core top - blurMargin2
				bottom: core top) }.
		{	core right @ 0.
			(core right + blurMargin2) @ 0.
		 	(Rectangle
				left: core right
				right: core right + blurMargin2
				top: core top
				bottom: core bottom) }.
		{	0 @ core bottom.
			0 @ (core bottom + blurMargin2).
		 	(Rectangle
				left: core left
				right: core right
				top: core bottom
				bottom: core bottom + blurMargin2) }.
		{	core left @ 0.
			(core left - blurMargin2) @ 0.
		 	(Rectangle
				left: core left - blurMargin2
				right: core left
				top: core top
				bottom: core bottom) }.
		}
]

{ #category : #printing }
AeBenchBlurRectangleRunner >> printOn: aStream [
	"Generate a string representation of the receiver based on its instance variables."

	super printOn: aStream.
	aStream
		nextPutAll: '(blurSigma: ';
		print: blurSigma;
		nextPutAll: ' surfaceExtent: ';
		print: mainSurface extent;
		nextPut: $)
]

{ #category : #initialization }
AeBenchBlurRectangleRunner >> rampFunctionAt: x [
	"Evaluate 1.0 minus a sigmoid (logistic) function, with mu and sigma determined manually by try and error."

	^ 1.0 - (1.0 / (1.0 + (((x - rampMu) * rampK) exp)))
]

{ #category : #running }
AeBenchBlurRectangleRunner >> runDirectNaive [
	<script: 'self new runDirectNaive inspect'>

	"-- core --"

	mainContext sourceColor: self shadowColor; rectangle: core; fill.


	"-- corners --"

	blurCorners do: [ :each |
		| aGradient |
		aGradient := AeCairoRadialGradientPattern
			center: each first
			innerRadius: 0.0
			outerRadius: blurMargin2.
		aGradient addStopsFrom: ramp.

		mainContext
			source: aGradient;
			rectangle: each second;
			fillPreservingPath: false alpha: self shadowColor alpha.

		"Force free to include this time in the benchmarks"
		aGradient externallyFree ].


	"-- sides --"

	blurSides do: [ :each |
		| aGradient |
		aGradient :=
			AeCairoLinearGradientPattern
				from: each first
				to: each second
				addStopsFrom: ramp.
	
		mainContext
			source: aGradient;
			rectangle: each third;
			fillPreservingPath: false alpha: self shadowColor alpha.

		"Force free to include this time in the benchmarks"
		aGradient externallyFree ].

	^ mainSurface
]

{ #category : #'as yet unclassified' }
AeBenchBlurRectangleRunner >> runDirectReusingGradient [
	<script: 'self new runDirectReusingGradient inspect'>

	| cornerGradient aMatrix sideGradient matrixBlocks |

	"-- core --"

	mainContext sourceColor: self shadowColor; rectangle: core; fill.


	"-- corners --"

	cornerGradient :=
		AeCairoRadialGradientPattern
			center: 0.0 @ 0.0
			innerRadius: 0.0
			outerRadius: blurMargin2.
	cornerGradient addStopsFrom: ramp.
	mainContext source: cornerGradient.

	aMatrix := AeCairoMatrix newIdentity.
	blurCorners do: [ :each |
		aMatrix beTranslationBy: each first negated.
		cornerGradient matrix: aMatrix.
		mainContext
			rectangle: each second;
			fillPreservingPath: false
			alpha: self shadowColor alpha ].

	"-- sides --"

	sideGradient := 
		AeCairoLinearGradientPattern
			from: 0.0 @ blurMargin2
			to:   0.0 @ 0.0
			addStopsFrom: ramp.
	mainContext source: sideGradient.

	matrixBlocks := {
		[ aMatrix beIdentity ].
		[ aMatrix beRotationByQuadrants: -1 around: core topRight ].
		[ aMatrix beFlipVerticallyAround: (core top + core bottom) / 2.0 ].
		[ aMatrix beRotationByQuadrants: 1 around: core topLeft ].
		}.

	blurSides with: matrixBlocks do: [ :eachSide :eachMatrixBlock |
		eachMatrixBlock value.
		sideGradient matrix: aMatrix.
		mainContext
			rectangle: eachSide third;
			fillPreservingPath: false
			alpha: self shadowColor alpha ].


	"Force free to include this time in the benchmarks"
	cornerGradient externallyFree.
	sideGradient externallyFree.
	aMatrix free.
	
	^ mainSurface
]

{ #category : #running }
AeBenchBlurRectangleRunner >> runGaussian [
	<script: 'self new runGaussian inspect'>

	| maskSurface |
	maskSurface := AeCairoImageSurface
		extent: mainSurface extent
		format: AeCairoSurfaceFormat a8.

	maskSurface newContext
		sourceColor: Color black;
		matrix: mainContext matrix;
		rectangle: rectangle;
		fill.

	AeCairoA8FastGaussianBlurFilter new
		surface: maskSurface;
		applySigma: blurSigma.

	mainContext
		sourceColor: self shadowColor;
		maskSurface: maskSurface.

	
	^ mainSurface
]

{ #category : #'as yet unclassified' }
AeBenchBlurRectangleRunner >> runMaskFull [
	<script: 'self new runMaskFull inspect'>

	| aGradient maskSurface maskContext matrixBlocks aMatrix |

	"-- core --"

	mainContext sourceColor: self shadowColor; rectangle: core; fill.

	"-- corners --"

	maskSurface := AeCairoImageSurface
		extent: 2 * blurMargin2 asPoint
		format: AeCairoSurfaceFormat a8.
	maskContext := maskSurface newContext.
	aGradient := AeCairoRadialGradientPattern
		center: blurMargin2 asPoint
		innerRadius: 0.0
		outerRadius: blurMargin2.
	aGradient addStopsFrom: ramp.
	maskContext source: aGradient; paint.

	mainContext sourceColor: self shadowColor.

	blurCorners do: [ :each |
		"We must restore clipping area after mask"
		mainContext
			saveState;
			rectangle: each second;
			clip;
			maskSurface: maskSurface
				x: each first x - blurMargin2
				y: each first y - blurMargin2;
			restoreState ].

	"Force free to include this time in the benchmarks"
	aGradient externallyFree.
	maskContext externallyFree.
	maskSurface externallyFree.


	"-- sides --"
	maskSurface := AeCairoImageSurface
		extent: (core extent max @ blurMargin2)
		format: AeCairoSurfaceFormat a8.
	maskContext := maskSurface newContext.

	aGradient :=
		AeCairoLinearGradientPattern
			from: 0.0 @ blurMargin2
			to:   0.0 @ 0.0
			addStopsFrom: ramp.
	maskContext source: aGradient; paint.

	aMatrix := AeCairoMatrix new.
	matrixBlocks := {
		[ aMatrix
			beTranslationByX: core left
			y: core top - blurMargin2 ].
		[ aMatrix
			beRotationByQuadrants: 1 around: core topLeft;
			translateByX: 0 y: core width negated ].
		[ aMatrix
			beFlipVerticallyAround: (core top + core bottom) / 2.0;
			translateByX: core left y: 0 ].
		[ aMatrix beRotationByQuadrants: -1 around: core topLeft ] }.

	blurSides with: matrixBlocks do: [ :eachSide :eachMatrixBlock |
		eachMatrixBlock value.

		"We must restore clipping area after mask"
		mainContext
			saveState;
			rectangle: eachSide third;
			clip;
			matrix: aMatrix;
			maskSurface: maskSurface;
			restoreState ].

	"Free manually"
	aMatrix free.

	^ mainSurface
]

{ #category : #'as yet unclassified' }
AeBenchBlurRectangleRunner >> runMaskQuadrant [
	<script: 'self new runMaskQuadrant inspect'>

	| aGradient maskSurface maskContext matrixBlocks aMatrix center |

	"-- core --"

	mainContext sourceColor: self shadowColor; rectangle: core; fill.

	"-- corners --"

	maskSurface := AeCairoImageSurface
		extent: blurMargin2 asPoint
		format: AeCairoSurfaceFormat a8.
	maskContext := maskSurface newContext.

	aGradient := AeCairoRadialGradientPattern
		center: blurMargin2 asPoint
		innerRadius: 0.0
		outerRadius: blurMargin2.
	aGradient addStopsFrom: ramp.
	maskContext source: aGradient; paint.

	aMatrix := AeCairoMatrix new.
	center := (core topLeft + core bottomRight ) / 2.0.
	matrixBlocks := {
		[ aMatrix beIdentity ].
		[ aMatrix beFlipHorizontallyAround: center x ].
		[ aMatrix beRotationByQuadrants: 2 around: center ].
		[ aMatrix beFlipVerticallyAround: center y ] }.

	mainContext sourceColor: self shadowColor.
	blurCorners with: matrixBlocks do: [ :eachArray :eachMatrixBlock |
		eachMatrixBlock value.
		mainContext
			matrix: aMatrix;
			maskSurface: maskSurface ].
	mainContext setIdentityMatrix.

	"Force free to include this time in the benchmarks"
	aGradient externallyFree.
	maskContext externallyFree.
	maskSurface externallyFree.



	"-- sides --"

	maskSurface := AeCairoImageSurface
		extent: core extent max @ blurMargin2
		format: AeCairoSurfaceFormat a8.
	maskContext := maskSurface newContext.

	aGradient :=
		AeCairoLinearGradientPattern
			from: 0.0 @ blurMargin2
			to:   0.0 @ 0.0
			addStopsFrom: ramp.
	maskContext source: aGradient; paint.

	matrixBlocks := {
		[ aMatrix
			beTranslationByX: core left
			y: core top - blurMargin2 ].
		[ aMatrix
			beRotationByQuadrants: 1 around: core topLeft;
			translateByX: 0 y: core width negated ].
		[ aMatrix
			beFlipVerticallyAround: (core top + core bottom) / 2;
			translateByX: core left y: 0 ].
		[ aMatrix beRotationByQuadrants: -1 around: core topLeft ] }.

	blurSides with: matrixBlocks do: [ :eachSide :eachMatrixBlock |
		eachMatrixBlock value.

		"We must restore clipping area after mask"
		mainContext
			saveState;
			rectangle: eachSide third;
			clip;
			matrix: aMatrix;
			maskSurface: maskSurface;
			restoreState ].

	"Free manually"
	aMatrix free.
	maskContext externallyFree.
	maskSurface externallyFree.

	^ mainSurface
]

{ #category : #'as yet unclassified' }
AeBenchBlurRectangleRunner >> runMaskQuadrant2 [
	<script: 'self new runMaskQuadrant2 inspect'>

	| aGradient maskSurface maskContext matrixBlocks aMatrix center |

	"-- core --"

	mainContext sourceColor: self shadowColor; rectangle: core; fill.

	"-- corners --"

	maskSurface := AeCairoImageSurface
		extent: blurMargin2 asPoint
		format: AeCairoSurfaceFormat a8.
	maskContext := maskSurface newContext.

	aGradient := AeCairoRadialGradientPattern
		center: blurMargin2 asPoint
		innerRadius: 0.0
		outerRadius: blurMargin2.
	aGradient addStopsFrom: ramp.
	maskContext source: aGradient; paint.

	aMatrix := AeCairoMatrix new.
	center := (core topLeft + core bottomRight ) / 2.0.
	matrixBlocks := {
		[ aMatrix beIdentity ].
		[ aMatrix beFlipHorizontallyAround: center x ].
		[ aMatrix beRotationByQuadrants: 2 around: center ].
		[ aMatrix beFlipVerticallyAround: center y ] }.

	mainContext sourceColor: self shadowColor.
	blurCorners with: matrixBlocks do: [ :eachArray :eachMatrixBlock |
		eachMatrixBlock value.
		mainContext
			matrix: aMatrix;
			maskSurface: maskSurface ].

	"Force free to include this time in the benchmarks"
	aGradient externallyFree.
	maskContext externallyFree.
	maskSurface externallyFree.


	"-- horizontal sides --"
	maskSurface := AeCairoImageSurface
		extent: core width @ blurMargin2
		format: AeCairoSurfaceFormat a8.
	maskContext := maskSurface newContext.

	aGradient :=
		AeCairoLinearGradientPattern
			from: 0.0 @ blurMargin2
			to:   0.0 @ 0.0
			addStopsFrom: ramp.
	maskContext source: aGradient; paint.

	mainContext
		setIdentityMatrix;
		maskSurface: maskSurface x: core left y: core top - blurMargin2.
	aMatrix beFlipVerticallyAround: center y.
	mainContext
		matrix: aMatrix;
		maskSurface: maskSurface x: core left y: 0.0.

	"Free manually"
	maskContext externallyFree.
	maskSurface externallyFree.


	"-- vertical sides --"

	maskSurface := AeCairoImageSurface
		extent: blurMargin2 @ core height
		format: AeCairoSurfaceFormat a8.
	maskContext := maskSurface newContext.
	aMatrix beRotationByQuadrants: 1 around: core topLeft.
	aGradient matrix: aMatrix.
	maskContext source: aGradient; paint.

	mainContext
		setIdentityMatrix;
		maskSurface: maskSurface x: core left - blurMargin2 y: core top.
	aMatrix beFlipHorizontallyAround: center x.
	mainContext
		matrix: aMatrix;
		maskSurface: maskSurface x: 0.0 y: core top.

	"Free manually"
	maskContext externallyFree.
	maskSurface externallyFree.

	aGradient externallyFree.
	aMatrix free.

	^ mainSurface
]
