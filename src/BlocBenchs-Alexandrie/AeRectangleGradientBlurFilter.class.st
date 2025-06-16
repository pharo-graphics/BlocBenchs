Class {
	#name : #AeRectangleGradientBlurFilter,
	#superclass : #AeGradientBlurFilter,
	#instVars : [
		'rectangle',
		'core',
		'blurMargin2',
		'blurCorners',
		'blurSides'
	],
	#category : #'BlocBenchs-Alexandrie-Blur'
}

{ #category : #drawing }
AeRectangleGradientBlurFilter >> draw [

	| aGradient maskSurface maskContext matrixBlocks aMatrix center |

	"-- core --"

	context sourceColor: color; rectangle: core; fill.

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
	maskContext sourcePattern: aGradient; paint.

	aMatrix := AeCairoMatrix new.
	center := (core topLeft + core bottomRight ) / 2.0.
	matrixBlocks := {
		[ aMatrix beIdentity ].
		[ aMatrix beFlipHorizontallyAround: center x ].
		[ aMatrix beRotationByQuadrants: 2 around: center ].
		[ aMatrix beFlipVerticallyAround: center y ] }.

	context sourceColor: color.
	blurCorners with: matrixBlocks do: [ :eachArray :eachMatrixBlock |
		eachMatrixBlock value.
		context
			matrix: aMatrix;
			maskSurface: maskSurface ].
	context setIdentityMatrix.

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
	maskContext sourcePattern: aGradient; paint.

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
		context
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

]

{ #category : #initialization }
AeRectangleGradientBlurFilter >> initializeFor: aContext rectangle: aRectangle sigma: aBlurSigma color: aColor [

	self initialize.

	color := aColor.
	context := aContext.
	
	blurMargin := (aBlurSigma * Float e) ceiling.
	blurMargin2 := blurMargin * 2.

	rectangle := aRectangle.
	core := rectangle insetBy: blurMargin.
"	rampMu := 0.475.
	rampK := -10."


	"The ramp defines all stops, playing with alpha channel"
	ramp := AeBenchBlurRoundedRectangleRunner basicNew  shadowRampSize: blurMargin.

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
