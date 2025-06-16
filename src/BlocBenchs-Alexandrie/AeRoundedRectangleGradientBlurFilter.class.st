Class {
	#name : #AeRoundedRectangleGradientBlurFilter,
	#superclass : #AeGradientBlurFilter,
	#instVars : [
		'radii',
		'blurSides',
		'blurCorners',
		'rectangle'
	],
	#category : #'BlocBenchs-Alexandrie-Blur'
}

{ #category : #drawing }
AeRoundedRectangleGradientBlurFilter >> draw [

	context saveState.
	context antialias: AeCairoAntialias none.

	self drawSides.
	self drawCorners.
	self drawCore.
	
	context restoreState
	

]

{ #category : #private }
AeRoundedRectangleGradientBlurFilter >> drawCore [

	context
		sourceColor: color;

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

		fill
]

{ #category : #private }
AeRoundedRectangleGradientBlurFilter >> drawCorners [

	blurCorners do: [ :each |
		| aGradient |
		aGradient := AeCairoRadialGradientPattern
			center: each first
			innerRadius: each second - blurMargin
			outerRadius: each second + blurMargin.
		aGradient addStopsFrom: ramp.

		context
			sourcePattern: aGradient;
			rectangle: each third;
			fillPreservingPath: false alpha: color alpha.

		"Force free to include this time in the benchmarks"
		aGradient externallyFree ]
]

{ #category : #private }
AeRoundedRectangleGradientBlurFilter >> drawSides [

	blurSides do: [ :each |
		| aGradient |
		aGradient :=
			AeCairoLinearGradientPattern
				from: (each at: #gradientFrom)
				to: (each at: #gradientTo)
				addStopsFrom: ramp.
	
		context
			sourcePattern: aGradient;
			rectangle: (each at: #clipArea);
			fillPreservingPath: false alpha: color alpha.

		"Force free to include this time in the benchmarks"
		aGradient externallyFree ]
]

{ #category : #initialization }
AeRoundedRectangleGradientBlurFilter >> initializeFor: aContext rectangle: aRectangle radii: anArray sigma: aBlurSigma color: aColor [

	self initialize.

	context := aContext.
	color := aColor.
	rectangle := aRectangle.
	radii := anArray.


	"Estimated radius that Gaussian blur affects"
	blurMargin := (aBlurSigma * Float e) ceiling.

	"The ramp defines all stops, playing with alpha channel"
	ramp := AeBenchBlurRoundedRectangleRunner basicNew shadowRampSize: blurMargin.


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
]
