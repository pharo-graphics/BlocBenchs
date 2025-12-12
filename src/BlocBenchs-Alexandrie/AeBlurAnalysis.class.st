Class {
	#name : #AeBlurAnalysis,
	#superclass : #Object,
	#category : #'BlocBenchs-Alexandrie-Blur'
}

{ #category : #examples }
AeBlurAnalysis class >> example1MultipleRadius [
	"Compare along different blur radius (or sigmas), on the same figure."
	<sampleInstance>

	| circleRadius margin surfaces maxBlurSigma surfaceExtent |
	circleRadius := 45.
	maxBlurSigma := 20.
	margin := maxBlurSigma * 3.
	surfaceExtent := ((circleRadius + margin) * 2) asPoint.

	surfaces := (1 to: maxBlurSigma by: 1)
		collect: [ :blurSigma |
			| aSurface |
			aSurface := AeCairoImageSurface
				extent: surfaceExtent
				format: AeCairoSurfaceFormat a8.
			aSurface newContext
				sourceColor: Color black;
				translateBy: margin asPoint;
				circleRadius: circleRadius;
				fill.

			[ AeCairoA8GaussianBlurFilter new
					surface: aSurface;
					applySigma: blurSigma ]
							timeToRun asMilliSeconds traceCr.

			aSurface ].

"	(surfaces collect: [ :each |
		| samples |
		samples := (1 to: surfaceExtent x) collect: [ :i |
			(each colorAtX: i - 1 y: surfaceExtent y // 2) alpha ].
		RSScatterPlot x: (1 to: samples size) y: samples ]) inspect."

	^ surfaces
]

{ #category : #examples }
AeBlurAnalysis class >> example2MultiplePasses [
	"Compare along different box-blur number of passes (commonly 3 passes)"
	<sampleInstance>
	
	| lineLength blurSigma margin surfaceExtent aSurface surfaces |
	lineLength := 200.
	blurSigma := 10.
	margin := blurSigma * 3.
	surfaceExtent := (lineLength + margin) asPoint.

	surfaces := (1 to: 6) collect: [ :eachN | 
		aSurface := AeCairoImageSurface
			extent: surfaceExtent
			format: AeCairoSurfaceFormat a8.
		aSurface newContext
			sourceColor: Color black;
			strokeSize: blurSigma * 2;
			lineTo: (margin/2) asPoint;
			relativeLineTo: lineLength asPoint;
			stroke.

		[ AeCairoA8GaussianBlurFilter new
				surface: aSurface;
				applySigma: blurSigma n: eachN ]
						timeToRun asMilliSeconds traceCr.

		aSurface ].
	
	^ surfaces
]

{ #category : #examples }
AeBlurAnalysis class >> example6GaussEstimation [
	"Playing with Gaussian function to emulate the slow blur."
	<sampleInstance>

	^ (3 to: 18 by: 2) reversed collect: [ :blurSigma |
		| rectangleMiddle shadowGap aSurface samples mu sigma gauss estimated coef samplesMu |
		rectangleMiddle := 100.
		coef := Float twoPi sqrt.
		shadowGap := (blurSigma * coef) ceiling.
		aSurface :=
			AeCairoImageSurface
				extent: ((rectangleMiddle + shadowGap * 2)) asPoint
				format: AeCairoSurfaceFormat a8.
		aSurface newContext
			sourceColor: Color black;
			rectangle: (shadowGap asPoint extent: (rectangleMiddle * 2) asPoint);
			fill.

		AeCairoA8GaussianBlurFilter new
			surface: aSurface;
			applySigma: blurSigma.


		samples := (1 to: rectangleMiddle) collect: [ :i |
			(aSurface colorAtX: i-1 y: rectangleMiddle) alpha ].

		(samples first: 5) traceCr.
		samplesMu := samples detectIndex: [ :s | s > 0.99 ].
		samples := samples first: samplesMu.

		mu := samplesMu.
		sigma := blurSigma * 1.5.
		gauss := [ :x | (-0.5 * (x - mu) squared / sigma squared) exp ].
		estimated := (1 to: mu) collect: [ :i | (gauss value: i) ].
		(((RSScatterPlot x: (1 to: samples size) y: samples) color: Color black)
		+ ((RSScatterPlot x: (1 to: estimated size) y: estimated) color: Color blue)).


		"aSurface"]
]

{ #category : #examples }
AeBlurAnalysis class >> example7SigmoidEstimation [
	<sampleInstance>

	| indexOfNonZero |
	^ (3 to: 18 by: 1) collect: [ :blurSigma |
		| rectangleMiddle margin aSurface samples mu sigmoidFunction estimated indexOfMax indexOfBreak k |
		rectangleMiddle := 100.
		margin := (blurSigma * Float e) ceiling.
		aSurface :=
			AeCairoImageSurface
				extent: ((rectangleMiddle + margin * 2)) asPoint
				format: AeCairoSurfaceFormat a8.
		aSurface newContext
			sourceColor: Color black;
			rectangle: (margin asPoint extent: (rectangleMiddle * 2) asPoint);
			fill.

		AeCairoA8GaussianBlurFilter new
			surface: aSurface;
			applySigma: blurSigma.

		samples := (1 to: rectangleMiddle) collect: [ :i |
			(aSurface colorAtX: i-1 y: rectangleMiddle-1) alpha ].

		indexOfMax := samples detectIndex: [ :s | s = samples max ].
		indexOfNonZero := samples detectIndex: [ :s | s > 0.0 ].
		indexOfBreak := samples detectIndex: [ :s | s >= 0.5 ].

		{	{blurSigma. margin}.
			{indexOfNonZero. indexOfBreak. indexOfMax}.
			{samples at: indexOfNonZero. samples at: indexOfMax} } traceCr.

		mu := margin+1.
		k := 1.1* Float e sqrt / blurSigma.
		sigmoidFunction := [ :x | 1.0 / (1.0 + (((x - mu) * k negated) exp)) ].

		samples := samples first: margin*2.
		estimated := (1 to: samples size) collect: [ :i | sigmoidFunction value: i ].
		(((RSScatterPlot x: (1 to: samples size) y: samples) color: Color black)
		+ ((RSScatterPlot x: (1 to: estimated size) y: estimated) color: Color green)).

	"[|refAlpha |
	refAlpha := (aSurface colorAtX: rectangleMiddle y: mu) alpha.
	(rectangleMiddle to: 0 by: -1) detectIndex: [ :x | (aSurface colorAtX: x y: mu) alpha < refAlpha ]] value."

	"{blurSigma. (0 to: mu*2) collect: [ :x | (aSurface colorAtX: x y: mu) alpha ]}."
"	Halt if: [ blurSigma = 10 ]."
"	blurSigma -> (margin * 2)"

"	aSurface newContext
			sourceColor: Color yellow;
			strokeSize: 1;
			rectangle: (-1 asPoint corner: (2*margin) + 0.5 asPoint);
			stroke;
			rectangle: (-1 asPoint corner: ((margin*1.6) ceiling - 0.5) asPoint);
			stroke.

	aSurface"

"	'blur.csv' asFileReference ensureDelete; writeStreamDo: [ :stream |
		| writer |
		writer := NeoCSVWriter on: stream.
		writer fieldWriter: #raw.
		samples withIndexDo: [ :each :index | writer nextPut: {index. each} ] ]."

		]
]
