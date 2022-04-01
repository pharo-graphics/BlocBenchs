"
I'm useful to run and report as String a collection of micro benchmarks defined in `SpartaBenchmarkRunner`.

See examples in class-side.
"
Class {
	#name : #SpartaBenchmarkComparison,
	#superclass : #Object,
	#instVars : [
		'benchSelectors',
		'canvasClasses',
		'runners'
	],
	#category : #'BlocBenchs-Old-SpartaMicroBenchs'
}

{ #category : #examples }
SpartaBenchmarkComparison class >> exampleInspect [

	self new
		 run;
		 inspect
]

{ #category : #examples }
SpartaBenchmarkComparison class >> exampleToStdout [

	DataFrameMarkdownPrinter new
		stream: Stdio stdout;
		dataFrame: (self new run; asDataFrame);
		write

]

{ #category : #converting }
SpartaBenchmarkComparison >> asDataFrame [

	| df benchLabels |
	benchLabels := benchSelectors collect: [ :each |
		(runners detect: [ :eachRunner | eachRunner selector = each ]) selectorAsLabel ].

	df := DataFrame
		withRowNames: benchLabels
		columnNames: #(Cairo Skia ratio).

	benchSelectors doWithIndex: [:each :index |
		| runnerForSkia runnerForCairo |
		runnerForCairo := self runnerForCanvas: SpartaCairoCanvas selector: each.
		runnerForSkia := self runnerForCanvas: SkiaCanvas selector: each.
		df
			rowAt: index 
			put: {
				runnerForCairo resultAsLabel.
				runnerForSkia resultAsLabel.
				(runnerForCairo result frequency / runnerForSkia result frequency) printShowingDecimalPlaces: 2 } ].

	^ df 

]

{ #category : #initialization }
SpartaBenchmarkComparison >> initialize [

	super initialize.
	
	canvasClasses := { SkiaCanvas. SpartaCairoCanvas }.

	benchSelectors := SpartaBenchmarkRunner selectorsForBenchmarks sorted.
	"But avoid error in Cairo"
	benchSelectors := benchSelectors copyWithout: #benchmarkFillRectangleWithForm.

]

{ #category : #newtools }
SpartaBenchmarkComparison >> inspectorForRunners: aBuilder [
	<inspectorPresentationOrder: 1 title: 'Runners'>

	^ aBuilder newList
		items: (runners sorted: [ :a :b | a selector < b selector ]);
		display: [ :each | each label ];
		yourself
]

{ #category : #newtools }
SpartaBenchmarkComparison >> inspectorForRunnersContext: aContext [

	aContext active: runners notNil
]

{ #category : #running }
SpartaBenchmarkComparison >> run [

	runners := Array streamContents: [ :stream |
		canvasClasses do: [ :canvasClass |
			benchSelectors do: [ :selector |
				stream nextPut: 
					(SpartaBenchmarkRunner new
						canvasClass: canvasClass;
						selector: selector;
						run;
						yourself) ] ] ]
]

{ #category : #accessing }
SpartaBenchmarkComparison >> runnerForCanvas: aSpartaCanvasClass selector: aSymbol [

	^ runners detect: [ :eachRunner | 
		  eachRunner canvasClass = aSpartaCanvasClass and: [ 
			  eachRunner selector = aSymbol ] ]
]
