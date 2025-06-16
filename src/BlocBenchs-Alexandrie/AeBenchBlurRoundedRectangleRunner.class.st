"
Compare several implementations to paint a blurred rounded rectangle.
"
Class {
	#name : #AeBenchBlurRoundedRectangleRunner,
	#superclass : #Object,
	#traits : 'AeTBenchBlurRunner',
	#classTraits : 'AeTBenchBlurRunner classTrait',
	#instVars : [
		'mainSurface',
		'mainContext',
		'rectangle',
		'radii',
		'blurMargin',
		'blurSigma',
		'blurSides',
		'blurCorners',
		'ramp',
		'blurMargin2'
	],
	#category : #'BlocBenchs-Alexandrie-Blur'
}

{ #category : #'instance creation' }
AeBenchBlurRoundedRectangleRunner class >> new [

	^ self newFor: 7
]

{ #category : #'instance creation' }
AeBenchBlurRoundedRectangleRunner class >> newFor: aBlurSigma [

	^ self newFor: (aBlurSigma * 30) @ (aBlurSigma * 20) blurRadius: aBlurSigma
]

{ #category : #'as yet unclassified' }
AeBenchBlurRoundedRectangleRunner class >> newFor: aRectangleExtent blurRadius: aBlurSigma [

	^ self basicNew
		initializeFor: aRectangleExtent blurSigma: aBlurSigma;
		yourself
]

{ #category : #initialization }
AeBenchBlurRoundedRectangleRunner >> initializeFor: rectangleExtent blurSigma: aBlurSigma [

	| baseRadius |
	self initialize.
	
	blurSigma := aBlurSigma.

	"Estimated radius that Gaussian blur affects"
	blurMargin := (blurSigma * Float e) ceiling.
	blurMargin2 := blurMargin * 2.

	rectangle := blurMargin asPoint extent: rectangleExtent.
	baseRadius := rectangleExtent min / 2.
	"radii: topLeft, topRight, bottomRight, bottomLeft"
	radii := { baseRadius. baseRadius * 0.75. baseRadius * 0.25. 0.0 }.
"		radii := { baseRadius. baseRadius * 0.5. baseRadius * 0.5. 0.25 }."
"	radii := { baseRadius. baseRadius. baseRadius. baseRadius } * 0.5."
	
"	core := rectangle insetBy: blurMargin."
	
	mainSurface := AeCairoImageSurface
		extent: (rectangleExtent + (blurMargin2)) asIntegerPoint
		format: AeCairoSurfaceFormat argb32.
	mainContext := mainSurface newContext.

	mainContext antialias: AeCairoAntialias none. "<--- fixes gaps, and it's invisible"

	"Shared: background"
	mainContext sourceColor: Color yellow; paint.

	"The ramp defines all stops, playing with alpha channel"
	ramp := self shadowRampSize: blurMargin
]

{ #category : #running }
AeBenchBlurRoundedRectangleRunner >> runDirectNaive [
	<script: 'self new runDirectNaive inspect'>

	"-- sides --"

	blurSides := {
		{	#gradientFrom -> (0 @ (rectangle top + blurMargin)).
			#gradientTo   -> (0 @ (rectangle top - blurMargin)).
			#clipArea ->
				(Rectangle
					left:   rectangle left  + (radii first  max: blurMargin)
					right:  rectangle right - (radii second max: blurMargin)
					top:    rectangle top - blurMargin
					bottom: rectangle top + blurMargin).
			#inset -> (radii first  max: blurMargin) } asOrderedDictionary.

		{	#gradientFrom -> ((rectangle right - blurMargin) @ 0).
			#gradientTo   -> ((rectangle right + blurMargin) @ 0).
		 	#clipArea ->
				(Rectangle
					left:   rectangle right - blurMargin
					right:  rectangle right + blurMargin
					top:    rectangle top    + (radii second max: blurMargin)
					bottom: rectangle bottom - (radii third  max: blurMargin)).
			#inset -> (radii second max: blurMargin) } asOrderedDictionary.

		{	#gradientFrom -> (0 @ (rectangle bottom - blurMargin)).
			#gradientTo   -> (0 @ (rectangle bottom + blurMargin)).
		 	#clipArea ->
				(Rectangle
					left:   rectangle left  + (radii fourth max: blurMargin)
					right:  rectangle right - (radii third  max: blurMargin)
					top:    rectangle bottom - blurMargin
					bottom: rectangle bottom + blurMargin).
			#inset -> (radii third  max: blurMargin) } asOrderedDictionary.

		{	#gradientFrom -> ((rectangle left + blurMargin) @ 0).
			#gradientTo   -> ((rectangle left - blurMargin) @ 0).
		 	#clipArea ->
				(Rectangle
					left:   rectangle left - blurMargin
					right:  rectangle left + blurMargin
					top:    rectangle top    + (radii first  max: blurMargin)
					bottom: rectangle bottom - (radii fourth max: blurMargin)).
			#inset -> (radii fourth max: blurMargin) } asOrderedDictionary.
		}.

	blurSides do: [ :each |
		| aGradient |
		aGradient :=
			AeCairoLinearGradientPattern
				from: (each at: #gradientFrom)
				to: (each at: #gradientTo)
				addStopsFrom: ramp.
	
		mainContext
			sourcePattern: aGradient;
			rectangle: (each at: #clipArea);
			fillPreservingPath: false alpha: self shadowColor alpha.

		"Force free to include this time in the benchmarks"
		aGradient externallyFree ].



	"-- corners --"
	
	blurCorners := Array streamContents: [ :stream |
		| gradientCenter |

		stream nextPut: {
			gradientCenter :=
				(blurSides first at: #clipArea) left
				@ (blurSides fourth at: #clipArea) top.
			blurSides first at: #inset.
			Rectangle
				left: rectangle left - blurMargin
				right: gradientCenter x
				top: rectangle top - blurMargin
				bottom: gradientCenter y }.

		stream nextPut: {
			gradientCenter :=
				(blurSides first at: #clipArea) right
				@ (blurSides second at: #clipArea) top.
			blurSides second at: #inset.
			Rectangle
				left: gradientCenter x
				right: rectangle right + blurMargin
				top: rectangle top - blurMargin
				bottom: gradientCenter y }.

		stream nextPut: {
			gradientCenter :=
				(blurSides third at: #clipArea) right
				@ (blurSides second at: #clipArea) bottom.
			blurSides third at: #inset.
			Rectangle
				left: gradientCenter x
				right: rectangle right + blurMargin
				top: gradientCenter y
				bottom: rectangle bottom + blurMargin }.

		stream nextPut: {
			gradientCenter :=
				(blurSides third at: #clipArea) left
				@ (blurSides fourth at: #clipArea) bottom.
			blurSides fourth at: #inset.
			Rectangle
				left: rectangle left - blurMargin
				right: gradientCenter x
				top: gradientCenter y
				bottom: rectangle bottom + blurMargin }.

		].
		
	blurCorners do: [ :each |
		| aGradient |
		aGradient := AeCairoRadialGradientPattern
			center: each first
			innerRadius: each second - blurMargin
			outerRadius: each second + blurMargin.
		aGradient addStopsFrom: ramp.

		mainContext
			sourcePattern: aGradient;
			rectangle: each third;
			fillPreservingPath: false alpha: self shadowColor alpha.

		"Force free to include this time in the benchmarks"
		aGradient externallyFree ].


	"-- core --"

	mainContext
		sourceColor: self shadowColor;

		moveTo: blurCorners first first;
		lineTo: (blurSides first at: #clipArea) bottomLeft;
		lineTo: (blurSides first at: #clipArea) bottomRight;

		lineTo: blurCorners second first;
		lineTo: (blurSides second at: #clipArea) topLeft;
		lineTo: (blurSides second at: #clipArea) bottomLeft;

		lineTo: blurCorners third first;
		lineTo: (blurSides third at: #clipArea) topRight;
		lineTo: (blurSides third at: #clipArea) topLeft;

		lineTo: blurCorners fourth first;
		lineTo: (blurSides fourth at: #clipArea) bottomRight;
		lineTo: (blurSides fourth at: #clipArea) topRight;
		closePath;

		fill.


	^ mainSurface
]

{ #category : #running }
AeBenchBlurRoundedRectangleRunner >> runFilter [
	<script: 'self new runFilter inspect'>

	mainContext restoreStateAfter: [
	
		AeRoundedRectangleGradientBlurFilter new
			initializeFor: mainContext
			rectangle: rectangle
			radii: radii
			sigma: blurSigma
			color: self shadowColor;
			draw ].

	^ mainSurface
]

{ #category : #running }
AeBenchBlurRoundedRectangleRunner >> runGaussian [
	<script: 'self new runGaussian inspect'>

	| maskSurface maskContext |
	maskSurface := AeCairoImageSurface
		                 extent: mainSurface extent
		                 format: AeCairoSurfaceFormat a8.

	maskContext := maskSurface newContext.
	maskContext
		matrix: mainContext matrix;
		sourceColor: Color black;
		roundedRectangleLeft: rectangle left
			top: rectangle top
			right: rectangle right
			bottom: rectangle bottom
			tl: radii first
			tr: radii second
			br: radii third
			bl: radii fourth;
		fill.

	AeCairoA8FastGaussianBlurFilter new
		surface: maskSurface;
		applySigma: blurSigma.

	mainContext
		sourceColor: self shadowColor;
		maskSurface: maskSurface.

	maskContext externallyFree.
	maskSurface externallyFree.

	^ mainSurface
]
