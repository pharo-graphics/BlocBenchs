"
Compare several implementations to paint the shadow of a rectangle.

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
	#name : #AeBenchRectangleShadowRunner,
	#superclass : #Object,
	#instVars : [
		'shadowRadius',
		'mainSurface',
		'mainContext',
		'shadowCorners',
		'shadowColor',
		'shadowRamp',
		'shadowSides',
		'rectangle',
		'blurRadius'
	],
	#category : #'BlocBenchs-Alexandrie'
}

{ #category : #running }
AeBenchRectangleShadowRunner class >> exampleRun [

	| instance repeatCount benchResult |
	
	"Gaussian shadow serves as a baseline reference"
	instance := self new.
	benchResult := [ instance runGaussian ] benchFor: 1 second.

	'------' traceCr.
	instance traceCr.
	'## runGaussian' traceCr.
	'average ms: ' trace. benchResult period asMilliSeconds traceCr.
	'iterations: ' trace. benchResult iterations traceCr.	

	"Run same number of iterations but emulated"
	repeatCount := benchResult iterations.

	#(runMask runNewCenteredGradients runSharingGradient) do: [ :eachSelector |
		| allMs |
		'## ' trace.
		eachSelector traceCr.

		allMs := Array streamContents: [ :msStream |
			50 timesRepeat: [
				instance := self new.
				msStream nextPut: ([
					repeatCount timesRepeat: [
						instance perform: eachSelector ]
					] timeToRun asMilliSeconds / repeatCount) ] ].

		"Print collected ms nicely"
		MeanConfidenceIntervalPrinter new
			unitString: 'ms';
			fixedDecimalPlaces: 2;
			print: allMs on: Transcript.
		Transcript cr; flush ]
]

{ #category : #'instance creation' }
AeBenchRectangleShadowRunner class >> new [

	^ self newFor: 20
]

{ #category : #'instance creation' }
AeBenchRectangleShadowRunner class >> newFor: shadowSize [

	^ self newFor: shadowSize rampSize: shadowSize
]

{ #category : #'instance creation' }
AeBenchRectangleShadowRunner class >> newFor: shadowSize rampSize: shadowRampSize [

	^ self basicNew
		initializeFor: shadowSize shadowRampSize: shadowRampSize;
		yourself
]

{ #category : #enumerating }
AeBenchRectangleShadowRunner >> alphaBellFunctionAt: x [
	"Answer the evaluation of a number in a Gaussian bell function with mean=0.0 and stdev=1.0, whose peak a 0.0 results in 1.0."

	^ (x squared * -0.5) exp
]

{ #category : #initialization }
AeBenchRectangleShadowRunner >> initializeFor: aBlurRadius shadowRampSize: shadowRampSize [

	| rectangleExtent |
	self initialize.
	
	blurRadius := aBlurRadius.
	shadowRadius := blurRadius * 1.5. "Estimate the radius that a Gaussian shadows affects"
	shadowColor := Color blue.
	rectangleExtent := (shadowRadius*2) @ (shadowRadius). "make it non-squared for fun"
	rectangle := shadowRadius asPoint extent: rectangleExtent.
	
	mainSurface := AeCairoImageSurface
		extent: (rectangleExtent + (shadowRadius*2)) asIntegerPoint
		format: AeCairoSurfaceFormat argb32.
	mainContext := mainSurface newContext.

	"Shared"
	mainContext sourceColor: Color yellow; paint. "Background"

	"The ramp defines all stops, playing with alpha channel"
	shadowRamp := Array streamContents: [ :stream |
		self
			rampSize: shadowRampSize
			stopsAndAlphasDo: [ :eachStop :eachAlpha |
				stream nextPut:
					(eachStop -> (shadowColor alpha: eachAlpha)) ] ].

	shadowCorners := {
		{	rectangle topLeft.
			Rectangle
				left: rectangle left - shadowRadius
				right: rectangle left
				top: rectangle top - shadowRadius
				bottom: rectangle top }.
		{	rectangle topRight.
			Rectangle
				left: rectangle right
				right: rectangle right + shadowRadius
				top: rectangle top - shadowRadius
				bottom: rectangle top }.
		{	rectangle bottomRight.
			Rectangle
				left: rectangle right
				right: rectangle right + shadowRadius
				top: rectangle bottom
				bottom: rectangle bottom + shadowRadius }.
		{	rectangle bottomLeft.
			Rectangle
				left: rectangle left - shadowRadius
				right: rectangle left
				top: rectangle bottom
				bottom: rectangle bottom + shadowRadius }.
		}.
	
	shadowSides := {
		{	0 @ rectangle top.
			0 @ (rectangle top - shadowRadius).
		 	(Rectangle
				left: rectangle left
				right: rectangle right
				top: rectangle top - shadowRadius
				bottom: rectangle top) }.
		{	rectangle right @ 0.
			(rectangle right + shadowRadius) @ 0.
		 	(Rectangle
				left: rectangle right
				right: rectangle right + shadowRadius
				top: rectangle top
				bottom: rectangle bottom) }.
		{	0 @ rectangle bottom.
			0 @ (rectangle bottom + shadowRadius).
		 	(Rectangle
				left: rectangle left
				right: rectangle right
				top: rectangle bottom
				bottom: rectangle bottom + shadowRadius) }.
		{	rectangle left @ 0.
			(rectangle left - shadowRadius) @ 0.
		 	(Rectangle
				left: rectangle left - shadowRadius
				right: rectangle left
				top: rectangle top
				bottom: rectangle bottom) }.
		}
]

{ #category : #printing }
AeBenchRectangleShadowRunner >> printOn: aStream [
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

{ #category : #enumerating }
AeBenchRectangleShadowRunner >> rampSize: rampSize stopsAndAlphasDo: aBlock [

	aBlock value: 0.0 value: 1.0.

	1 to: rampSize - 2 do: [ :i |
		| stop |
		stop := i / (rampSize - 1) asFloat.
		aBlock
			value: stop
			value: (self alphaBellFunctionAt: stop * 4.0) ].

	aBlock value: 1.0 value: 0.0
]

{ #category : #running }
AeBenchRectangleShadowRunner >> runGaussian [
	<script: 'self new runGaussian inspect'>

	| shadowSurface |
	shadowSurface := AeCairoImageSurface
		extent: mainSurface extent
		format: AeCairoSurfaceFormat a8.

	shadowSurface newContext
		sourceColor: Color black;
		rectangle: (rectangle expandBy: blurRadius/2); "<---- why?"
		fill.
	shadowSurface flush.

	AeCairoA8FastGaussianBlurFilter new
		surface: shadowSurface;
		applyRadius: blurRadius / 1.5. "<---- why?"

	mainSurface newContext
		sourceColor: shadowColor;
		maskSurface: shadowSurface x: 0.0 y: 0.0.
	
	^ mainSurface
]

{ #category : #running }
AeBenchRectangleShadowRunner >> runMask [
	<script: 'self new runMask inspect'>

	| aGradient shadowSurface shadowContext matrixBlocks aMatrix |

	"-- core --"

	mainContext sourceColor: shadowColor; rectangle: rectangle; fill.

	"-- corners --"

	shadowSurface := AeCairoImageSurface
		extent: (shadowRadius * 2) asPoint
		format: AeCairoSurfaceFormat a8.
	shadowContext := shadowSurface newContext.

	aGradient := AeCairoRadialGradientPattern
		innerCenter: shadowRadius asPoint
		innerRadius: 0
		outerCenter: shadowRadius asPoint
		outerRadius: shadowRadius.
	aGradient addStopsFrom: shadowRamp.
	shadowContext
		source: aGradient;
		paint.

	mainContext sourceColor: shadowColor.

	shadowCorners do: [ :each |
		"We must restore clipping area after mask"
		mainContext
			saveState;
			rectangle: each second;
			clip;
			maskSurface: shadowSurface
				x: each first x - shadowRadius
				y: each first y - shadowRadius;
			restoreState ].

	"Force free to include this time in the benchmarks"
	aGradient externallyFree.
	shadowContext externallyFree.
	shadowSurface externallyFree.


	"-- sides --"
	shadowSurface := AeCairoImageSurface
		extent: rectangle extent max @ shadowRadius
		format: AeCairoSurfaceFormat a8.
	shadowContext := shadowSurface newContext.

	aGradient :=
		AeCairoLinearGradientPattern
			from: 0.0 @ shadowRadius
			to:   0.0 @ 0.0
			addStopsFrom: shadowRamp.
	shadowContext source: aGradient; paint.

	aMatrix := AeCairoMatrix new.
	matrixBlocks := {
		[ aMatrix
			beTranslationByX: rectangle left
			y: rectangle top - shadowRadius ].
		[ aMatrix
			beRotationByQuadrants: 1 around: rectangle topLeft;
			translateByX: 0 y: rectangle width negated ].
		[ aMatrix
			beFlipVerticallyAround: (rectangle top + rectangle bottom) / 2;
			translateByX: rectangle left y: 0 ].
		[ aMatrix beRotationByQuadrants: -1 around: rectangle topLeft ] }.

	shadowSides with: matrixBlocks do: [ :eachSide :eachMatrixBlock |
		eachMatrixBlock value.

		"We must restore clipping area after mask"
		mainContext
			saveState;
			rectangle: eachSide third;
			clip;
			matrix: aMatrix;
			maskSurface: shadowSurface x: 0.0 y: 0.0;
			restoreState ].

	"Free manually"
	aMatrix free.

	^ mainSurface
]

{ #category : #running }
AeBenchRectangleShadowRunner >> runNewCenteredGradients [
	<script: 'self new runNewCenteredGradients inspect'>

	"-- core --"

	mainContext sourceColor: shadowColor; rectangle: rectangle; fill.


	"-- corners --"

	shadowCorners do: [ :each |
		| aGradient |
		aGradient := AeCairoRadialGradientPattern
			innerCenter: each first
			innerRadius: 0.0
			outerCenter: each first
			outerRadius: shadowRadius.
		aGradient addStopsFrom: shadowRamp.

		mainContext
			source: aGradient;
			rectangle: each second;
			fill.

		"Force free to include this time in the benchmarks"
		aGradient externallyFree ].


	"-- sides --"

	shadowSides do: [ :each |
		| aGradient |
		aGradient :=
			AeCairoLinearGradientPattern
				from: each first
				to: each second
				addStopsFrom: shadowRamp.
	
		mainContext
			source: aGradient;
			rectangle: each third;
			fill.

		"Force free to include this time in the benchmarks"
		aGradient externallyFree ].

	^ mainSurface
]

{ #category : #running }
AeBenchRectangleShadowRunner >> runSharingGradient [
	<script: 'self new runSharingGradient inspect'>

	| cornerGradient aMatrix sideGradient matrices |

	"-- core --"

	mainContext sourceColor: shadowColor; rectangle: rectangle; fill.


	"-- corners --"

	cornerGradient :=
		AeCairoRadialGradientPattern
			innerCenter: 0@0
			innerRadius: 0
			outerCenter: 0@0
			outerRadius: shadowRadius
			addStopsFrom: shadowRamp.
	mainContext source: cornerGradient.

	aMatrix := AeCairoMatrix newIdentity.
	shadowCorners do: [ :each |
		aMatrix beTranslationBy: each first negated.
		cornerGradient matrix: aMatrix.
		mainContext rectangle: each second; fill ].

	"-- sides --"

	sideGradient := 
		AeCairoLinearGradientPattern
			from: 0.0 @ shadowRadius
			to:   0.0 @ 0.0
			addStopsFrom: shadowRamp.
	mainContext source: sideGradient.

	matrices := {
		[ aMatrix beIdentity ].
		[ aMatrix beRotationByQuadrants: -1 around: rectangle topRight ].
		[ aMatrix beFlipVerticallyAround: (rectangle top + rectangle bottom) / 2 ].
		[ aMatrix beRotationByQuadrants: 1 around: rectangle topLeft ].
		}.

	shadowSides with: matrices do: [ :eachSide :eachMatrixBlock |
		eachMatrixBlock value.
		sideGradient matrix: aMatrix.
		mainContext rectangle: eachSide third; fill ].


	"Force free to include this time in the benchmarks"
	cornerGradient externallyFree.
	sideGradient externallyFree.
	aMatrix free.
	
	^ mainSurface
]
