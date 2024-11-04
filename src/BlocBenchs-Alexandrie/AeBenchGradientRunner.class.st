"
Compare several implementations to paint corners of a shadow.

**1st question**: which implementation is faster in general?

On large shadow sizes, such as 100, the benchmark difference is not significant. The number of pixels in those cases becomes far more relevant than the implementation variants in this class.

On smaller shadow sizes such as 20 is then the implementation shows relevant differences in the benchmark: ""sharing gradient"" which only mutates the matrix, is faster.

On a Macbook 2018:
1) runSharingGradient: 9461 per second
2) runMask: 8339 per second
3) runNewCenteredGradients: 8155 per second

**2nd question**: how much ""ramp size"" impacts performance?
A ramp size of 10 was 18% faster than a ramp size of 20 (with shadow size of 20).
"
Class {
	#name : #AeBenchGradientRunner,
	#superclass : #Object,
	#instVars : [
		'shadowRadius',
		'mainSurface',
		'mainContext',
		'shadowCorners',
		'shadowColor',
		'shadowRamp'
	],
	#category : #'BlocBenchs-Alexandrie'
}

{ #category : #running }
AeBenchGradientRunner class >> example [

	self className traceCr.

	#(runNewCenteredGradients runSharingGradient runMask) do: [ :each |
		| instance |
		each traceCr.
		instance := self new.
		[ instance perform: each ] bench traceCr ]

]

{ #category : #'instance creation' }
AeBenchGradientRunner class >> new [

	^ self newFor: 20 rampSize: 10
]

{ #category : #'instance creation' }
AeBenchGradientRunner class >> newFor: shadowSize rampSize: shadowRampSize [

	^ self basicNew
		initializeFor: shadowSize shadowRampSize: shadowRampSize;
		yourself
]

{ #category : #enumerating }
AeBenchGradientRunner >> alphaBellFunctionAt: x [
	"Answer the evaluation of a number in a Gaussian bell function with mean=0.0 and stdev=1.0, whose peak a 0.0 results in 1.0."

	^ (x squared * -0.5) exp
]

{ #category : #initialization }
AeBenchGradientRunner >> initializeFor: shadowSize shadowRampSize: shadowRampSize [

	| rectangleExtent rectangle |
	self initialize.
	
	shadowRadius := shadowSize * 1.5. "Estimate the radius that a Gaussian shadows affects"
	shadowColor := Color blue.
	rectangleExtent := (shadowRadius*2) @ (shadowRadius). "make it non-squared for fun"
	rectangle := shadowRadius asPoint extent: rectangleExtent.
	
	mainSurface := AeCairoImageSurface
		extent: (rectangleExtent + (shadowRadius*2)) asIntegerPoint
		format: AeCairoSurfaceFormat argb32.
	mainContext := mainSurface newContext.
	mainContext sourceColor: Color yellow; paint. "Background"

	"The ramp defines all stops, playing with alpha channel"
	shadowRamp := Array streamContents: [ :stream |
		self
			rampSize: shadowRampSize
			stopsAndAlphasDo: [ :eachStop :eachAlpha |
				stream nextPut:
					(eachStop -> (shadowColor alpha: eachAlpha)) ] ].

	shadowCorners := {
		rectangle topLeft -> (Rectangle
			left: rectangle left - shadowRadius
			right: rectangle left
			top: rectangle top - shadowRadius
			bottom: rectangle top).
		rectangle topRight -> (Rectangle
			left: rectangle right
			right: rectangle right + shadowRadius
			top: rectangle top - shadowRadius
			bottom: rectangle top).
		rectangle bottomRight -> (Rectangle
			left: rectangle right
			right: rectangle right + shadowRadius
			top: rectangle bottom
			bottom: rectangle bottom + shadowRadius).
		rectangle bottomLeft -> (Rectangle
			left: rectangle left - shadowRadius
			right: rectangle left
			top: rectangle bottom
			bottom: rectangle bottom + shadowRadius).
		}
]

{ #category : #enumerating }
AeBenchGradientRunner >> rampSize: rampSize stopsAndAlphasDo: aBlock [

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
AeBenchGradientRunner >> runMask [
	<script: 'self new runMask inspect'>

  	"Prepare radial gradient in a separate surface"
	| aGradient shadowSurface shadowContext |
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
		"We need to restore from clip"
		mainContext
			saveState;
			rectangle: each value;
			clip;
			maskSurface: shadowSurface
				x: each key x - shadowRadius
				y: each key y - shadowRadius;
			restoreState ].

	"Force free to include this time in the benchmarks"
	aGradient externallyFree.
	shadowContext externallyFree.
	shadowSurface externallyFree.

	^ mainSurface
]

{ #category : #running }
AeBenchGradientRunner >> runNewCenteredGradients [
	<script: 'self new runNewCenteredGradients inspect'>

	shadowCorners do: [ :each |
		| aGradient |
		aGradient := AeCairoRadialGradientPattern
			innerCenter: each key
			innerRadius: 0.0
			outerCenter: each key
			outerRadius: shadowRadius.
		aGradient addStopsFrom: shadowRamp.

		mainContext
			source: aGradient;
			rectangle: each value;
			fill.

		"Force free to include this time in the benchmarks"
		aGradient externallyFree ].

	^ mainSurface
]

{ #category : #running }
AeBenchGradientRunner >> runSharingGradient [
	<script: 'self new runSharingGradient inspect'>

	| aGradient aMatrix |
	aGradient := (AeCairoRadialGradientPattern
		innerCenter: 0@0
		innerRadius: 0
		outerCenter: 0@0
		outerRadius: shadowRadius)
			addStopsFrom: shadowRamp;
			yourself.
	mainContext source: aGradient.

	aMatrix := AeCairoMatrix newIdentity.

	shadowCorners do: [ :each |
		aMatrix beTranslationBy: each key negated.
		aGradient matrix: aMatrix.
		mainContext
			rectangle: each value;
			fill ].

	"Force free to include this time in the benchmarks"
	aGradient externallyFree.
	aMatrix free.
	
	^ mainSurface
]
