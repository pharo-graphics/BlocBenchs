"
I'm useful to run micro benchmarks on a SpartaCanvas.

"
Class {
	#name : #SpartaBenchmarkRunner,
	#superclass : #Object,
	#instVars : [
		'canvasClass',
		'selector',
		'canvas',
		'result'
	],
	#category : #'BlocBenchs-Old-SpartaMicroBenchs'
}

{ #category : #examples }
SpartaBenchmarkRunner class >> exampleInspect [

	^ self new
		selector: #benchmarkClipRectangle;
		canvasClass: SpartaCairoCanvas;
		run;
		inspect
]

{ #category : #accessing }
SpartaBenchmarkRunner class >> prefixOfBenchmarkSelectors [

	^ 'benchmark'
]

{ #category : #accessing }
SpartaBenchmarkRunner class >> selectorsForBenchmarks [

	^ self selectors select: [ :each | 
		  each beginsWith: self prefixOfBenchmarkSelectors ]
]

{ #category : #benchmarks }
SpartaBenchmarkRunner >> benchmarkClipRectangle [

	| aRectangle |

	canvas := canvasClass extent: 300@200.
	canvas fill
		path: canvas bounds;
		paint: Color white;
		draw.

	aRectangle := 50@50 corner: 250@150.
	
	self doBenchmark: [
		canvas clip
			by: aRectangle
			during: [  ] ]

]

{ #category : #benchmarks }
SpartaBenchmarkRunner >> benchmarkClipSubRectangle [

	| aRectangle aSubRectangle |

	canvas := canvasClass extent: 300@200.
	canvas fill
		path: canvas bounds;
		paint: Color white;
		draw.

	aRectangle := 50@50 corner: 250@150.
	aSubRectangle := 100@100 corner: 400@300.
		
	self doBenchmark: [
		canvas clip
			by: aRectangle
			during: [
				canvas clip
					by: aSubRectangle
					during: [  ] ] ]

]

{ #category : #benchmarks }
SpartaBenchmarkRunner >> benchmarkDrawTextAtRandomLocations [

	| extent amount points words font |

	extent := 1000@1000.
	amount := 500.

	points := amount timesCollect: [ (10@30) + ((extent x - 50) atRandom @ (extent y - 50) atRandom) ].
	words := amount timesCollect: [ ((4 + 10 atRandom) timesCollect: [ ($a to: $z) atRandom ]) as: String ].

	canvas := canvasClass extent: 1000@1000.

	font := canvas font
		named: 'Source Code Pro';
		size: 14;
		build.

	self doBenchmark: [
			words with: points do: [ :word :point |
				canvas text
					font: font;
					string: word;
					baseline: point;
					draw ] ]

]

{ #category : #benchmarks }
SpartaBenchmarkRunner >> benchmarkDrawTextWithBlackColor [

	| aFont aText |

	canvas := canvasClass extent: 300@200.
	canvas fill
		path: canvas bounds;
		paint: Color white;
		draw.

	aFont := canvas font build.

	aText := canvas text
		font: aFont;
		string: 'Hello world! Hello world! Hello world!';
		textRun.
		
	self doBenchmark: [
		canvas text
			baseline: 10@50;
			font: aFont;
			text: aText;
			paint: Color black;
			draw ]

]

{ #category : #benchmarks }
SpartaBenchmarkRunner >> benchmarkDrawTextWithOpaqueColor [

	| aFont aText |

	canvas := canvasClass extent: 300@200.
	canvas fill
		path: canvas bounds;
		paint: Color white;
		draw.

	aFont := canvas font build.

	aText := canvas text
		font: aFont;
		string: 'Hello world! Hello world! Hello world!';
		textRun.
		
	self doBenchmark: [
		canvas text
			baseline: 10@50;
			font: aFont;
			text: aText;
			paint: (Color brown);
			draw ]

]

{ #category : #benchmarks }
SpartaBenchmarkRunner >> benchmarkDrawTextWithSemiTransparentColor [

	| aFont aText |

	canvas := canvasClass extent: 300@200.
	canvas fill
		path: canvas bounds;
		paint: Color white;
		draw.

	aFont := canvas font build.

	aText := canvas text
		font: aFont;
		string: 'Hello world! Hello world! Hello world!';
		textRun.
	
	self doBenchmark: [
		canvas text
			baseline: 10@50;
			font: aFont;
			text: aText;
			paint: (Color red alpha: 0.4);
			draw ]

]

{ #category : #benchmarks }
SpartaBenchmarkRunner >> benchmarkFillRectangleWithBlackColor [

	| aRectangle aColor |

	canvas := canvasClass extent: 300@200.
	canvas fill
		path: canvas bounds;
		paint: Color white;
		draw.

	aRectangle := 50@50 corner: 250@150.
	aColor := Color black.
		
	self doBenchmark: [
		canvas fill
			path: aRectangle;
			paint: aColor;
			draw ]

]

{ #category : #benchmarks }
SpartaBenchmarkRunner >> benchmarkFillRectangleWithForm [

	| aRectangle aForm |
	
	canvas := canvasClass extent: 300@200.
	canvas fill
		path: canvas bounds;
		paint: Color white;
		draw.
	
	aRectangle := 50@50 corner: 250@150.
	
	aForm := Form extent: aRectangle extent depth: 32.
	aForm fillColor: Color veryLightGray.
	aForm fill: (aForm boundingBox insetBy: 25) fillColor: Color gray.	
		
	self doBenchmark: [
		canvas fill
			path: aRectangle;
			paint: aForm;
			draw ]

]

{ #category : #benchmarks }
SpartaBenchmarkRunner >> benchmarkFillRectangleWithOpaqueColor [

	| aRectangle aColor |

	canvas := canvasClass extent: 300@200.
	canvas fill
		path: canvas bounds;
		paint: Color white;
		draw.
		
	aRectangle := 50@50 corner: 250@150.
	aColor := Color brown.
		
	self doBenchmark: [
		canvas fill
			path: aRectangle;
			paint: aColor;
			draw ]

]

{ #category : #benchmarks }
SpartaBenchmarkRunner >> benchmarkFillRectangleWithWhiteColor [

	| aRectangle aColor |

	canvas := canvasClass extent: 300@200.
	canvas fill
		path: canvas bounds;
		paint: Color white;
		draw.
		
	aRectangle := 50@50 corner: 250@150.
	aColor := Color white.
		
	self doBenchmark: [
		canvas fill
			path: aRectangle;
			paint: aColor;
			draw ]

]

{ #category : #benchmarks }
SpartaBenchmarkRunner >> benchmarkFillRoundedRectangleWithOpaqueColorNoPathCache [

	| aRectangle aColor |

	canvas := canvasClass extent: 300@200.
	canvas fill
		path: canvas bounds;
		paint: Color white;
		draw.
		
	aRectangle := 50@50 corner: 250@150.
	aColor := Color brown.
		
	self doBenchmark: [
		canvas fill
			path: (canvas shape roundedRectangle: aRectangle radii: #(20 30 40 50));
			paint: aColor;
			draw ]

]

{ #category : #benchmarks }
SpartaBenchmarkRunner >> benchmarkFillSimpleRoundedRectangleWithOpaqueColor [

	| aRectangle aColor |

	canvas := canvasClass extent: 300@200.
	canvas fill
		path: canvas bounds;
		paint: Color white;
		draw.
		
	aRectangle := canvas shape roundedRectangle: (50@50 corner: 250@150) radii: #(20 20 20 20).
	aColor := Color brown.
	
	self doBenchmark: [
		canvas fill
			path: aRectangle;
			paint: aColor;
			draw ]

]

{ #category : #benchmarks }
SpartaBenchmarkRunner >> benchmarkFillSimpleRoundedRectangleWithOpaqueColorNoPathCache [

	| aRectangle aColor |

	canvas := canvasClass extent: 300@200.
	canvas fill
		path: canvas bounds;
		paint: Color white;
		draw.
		
	aRectangle := 50@50 corner: 250@150.
	aColor := Color brown.
		
	self doBenchmark: [
		canvas fill
			path: (canvas shape roundedRectangle: aRectangle radii: #(20 20 20 20));
			paint: aColor;
			draw ]

]

{ #category : #benchmarks }
SpartaBenchmarkRunner >> benchmarkRectangleFigureWithoutBorder [

	| aRectangle aColor |

	canvas := canvasClass extent: 300@200.
	canvas fill
		path: canvas bounds;
		paint: Color white;
		draw.
		
	aRectangle := 50@50 corner: 250@150.
	aColor := Color brown.
		
	self doBenchmark: [
		canvas figure
			path: aRectangle;
			background: aColor;
			backgroundAlpha: 1.0;
			border: Color transparent;
			borderAlpha: 1.0;
			width: 0.0;
			draw ]

]

{ #category : #benchmarks }
SpartaBenchmarkRunner >> benchmarkTextRunWithMetrics [

	| aFont aString |

	canvas := canvasClass extent: 300@200.
	aFont := canvas font build.
	aString := 'Hello world!'.
	
	self doBenchmark: [
		| aTextPainter |
		aTextPainter := canvas text font: aFont; string: aString.
		aTextPainter textRunWithMetrics: aTextPainter metrics ]

]

{ #category : #benchmarks }
SpartaBenchmarkRunner >> benchmarkTransformCurrentMatrix [

	canvas := canvasClass extent: 300@200.

	self doBenchmark: [ canvas transform current ]

]

{ #category : #benchmarks }
SpartaBenchmarkRunner >> benchmarkTransformTranslateBy [

	| aDelta |

	canvas := canvasClass extent: 300@200.
	canvas fill
		path: canvas bounds;
		paint: Color white;
		draw.

	aDelta := 100@50.
		
	self doBenchmark: [
		canvas transform
			by: [ :t | t translateBy: aDelta ]
			during: [  ] ]

]

{ #category : #accessing }
SpartaBenchmarkRunner >> canvas [

	^ canvas
]

{ #category : #accessing }
SpartaBenchmarkRunner >> canvasClass [

	^ canvasClass
]

{ #category : #accessing }
SpartaBenchmarkRunner >> canvasClass: aSpartaCanvasClass [

	canvasClass := aSpartaCanvasClass
]

{ #category : #private }
SpartaBenchmarkRunner >> doBenchmark: aBlockClosure [

	result := aBlockClosure benchFor: self duration
]

{ #category : #accessing }
SpartaBenchmarkRunner >> duration [

	^ 2 seconds
]

{ #category : #newtools }
SpartaBenchmarkRunner >> inspectorForCanvas: aBuilder [
	<inspectorPresentationOrder: 2 title: 'Canvas'>

	^ aBuilder newMorph
		  morph: canvas asForm asMorph;
		  yourself
]

{ #category : #newtools }
SpartaBenchmarkRunner >> inspectorForCanvasContext: aContext [

	aContext active: canvas notNil
]

{ #category : #newtools }
SpartaBenchmarkRunner >> inspectorForResultIn: aContext [
	<inspectorPresentationOrder: 10 title: 'Result'>

"	aContext active: result notNil.

	^ aContext newMorph
		  morph: canvas asForm asMorph;
		  yourself"
]

{ #category : #printing }
SpartaBenchmarkRunner >> label [ 

	^ self selectorAsLabel, ': ', self resultAsLabel, ' @ ', self canvasClass name

]

{ #category : #accessing }
SpartaBenchmarkRunner >> prefixOfBenchmarkSelectors [

	^ 'benchmark'
]

{ #category : #printing }
SpartaBenchmarkRunner >> printOn: aStream [
	"Append a sequence of characters to aStream that identify the receiver."

	super printOn: aStream.
	aStream
		nextPutAll: '(';
		nextPutAll: self label;
		nextPutAll: ')'

]

{ #category : #accessing }
SpartaBenchmarkRunner >> result [

	^ result
]

{ #category : #printing }
SpartaBenchmarkRunner >> resultAsLabel [

	^ result frequency printShowingDecimalPlaces: 2
]

{ #category : #accessing }
SpartaBenchmarkRunner >> run [

	self perform: selector
]

{ #category : #accessing }
SpartaBenchmarkRunner >> selector [
	^ selector
]

{ #category : #accessing }
SpartaBenchmarkRunner >> selector: aSymbol [

	selector := aSymbol
]

{ #category : #printing }
SpartaBenchmarkRunner >> selectorAsLabel [

	^ selector allButFirst:
		  SpartaBenchmarkRunner prefixOfBenchmarkSelectors size
]
