"
I print a simple statistical description from a collection of numbers: the mean and confidence interval.

Based on SMarkSimpleStatisticsReporter from SMark benchmark project.

"
Class {
	#name : #PCMeanConfidenceIntervalPrinter,
	#superclass : #Object,
	#instVars : [
		'fixedDecimalPlaces'
	],
	#category : #'BlocBenchs-Printing'
}

{ #category : #examples }
PCMeanConfidenceIntervalPrinter class >> example [

	| hosts canvases cases runners printer df |
	hosts := { BlOSWindowSDL2Host. BlMorphicWindowHost }.
	canvases := { BlSpartaCairoCanvasBuilder. BlSpartaSkiaCanvasBuilder}.
	cases := { BlBoidsProfileCase new duration: 20 seconds; yourself }.
	runners := hosts flatCollect: [:eachHost |
		canvases flatCollect: [:eachCanvas |
			cases collect: [ :eachCase |
				| case |
				case := eachCase copy
					hostClass: eachHost;
					spartaCanvasClass: eachCanvas;
					yourself.

				(BlProfileRunner newForCase: case)
					enableFPS;
					yourself

				] ] ].

	[
	runners do: #run.

	printer := PCMeanConfidenceIntervalPrinter new
		fixedDecimalPlaces: 1;
		yourself.
	df := DataFrame
		withRowNames: (hosts collect: #label)
		columnNames: (canvases collect: #label).
	hosts doWithIndex: [:eachHost :hostIndex |
		canvases doWithIndex: [:eachCanvas :canvasIndex |
			runners
				detect: [ :each |
					each case hostClass = eachHost and: [
					each case spartaCanvasClass = eachCanvas ] ]
				ifFound: [ :found |
					df
						at: hostIndex at: canvasIndex
						put: (printer print: found meters anyOne intermediateFPS) ] ] ].

	Stdio stdout
		lf;
		<< runners anyOne case label;
		lf;
		<< CairoLibrary uniqueInstance versionString;
		lf; lf.
	DataFrameMarkdownPrinter new
		stream: Stdio stdout;
		dataFrame: df;
		write.
	Stdio stdout lf. 
	] fork
]

{ #category : #statistics }
PCMeanConfidenceIntervalPrinter >> confidenceVariance: aCollectionOfNumbers [

	| size |
	size := aCollectionOfNumbers size.

	^ size >= 30 
		ifTrue: [ 
			self gaussianConfidenceFactor * aCollectionOfNumbers stdev
		  		/ size asFloat sqrt ]
		ifFalse: [ 
			(self studentsTConfidenceFactorFor: size) * aCollectionOfNumbers stdev
	  			/ size asFloat sqrt ]


]

{ #category : #accessing }
PCMeanConfidenceIntervalPrinter >> fixedDecimalPlaces [

	^ fixedDecimalPlaces
]

{ #category : #accessing }
PCMeanConfidenceIntervalPrinter >> fixedDecimalPlaces: aPositiveInteger [

	fixedDecimalPlaces := aPositiveInteger
]

{ #category : #statistics }
PCMeanConfidenceIntervalPrinter >> gaussianConfidenceFactor [
	"Used when size >= 30."
	"1 ~ 68.27%"
	"1.644853626951 ~ 90%"
	"2 ~ 95.45%"

	^ 1.644853626951
]

{ #category : #printing }
PCMeanConfidenceIntervalPrinter >> print: aCollectionOfNumbers [

	^ String streamContents: [ :aStream | 
		  self print: aCollectionOfNumbers on: aStream ]
]

{ #category : #reporting }
PCMeanConfidenceIntervalPrinter >> print: aCollectionOfNumbers on: aStream [
	"Print average +/- confidence variance. The colleciton must be not empty."

	| confidenceVariance significantDigits |
	confidenceVariance := aCollectionOfNumbers size = 1
		ifTrue: [ 0.0 ]
		ifFalse: [ self confidenceVariance: aCollectionOfNumbers ].

	significantDigits := fixedDecimalPlaces ifNil: [
		self significantDigits: confidenceVariance ].

	aCollectionOfNumbers average
		printOn: aStream
		showingDecimalPlaces: significantDigits.

	aStream << ' ±'.
	confidenceVariance
		printOn: aStream
		showingDecimalPlaces: significantDigits
]

{ #category : #statistics }
PCMeanConfidenceIntervalPrinter >> significantDigits: confidenceVariance [

	confidenceVariance = 0 ifTrue: [ ^ 2 ].
	confidenceVariance >= 10 ifTrue: [ ^ 0 ].
	^ 1 - confidenceVariance log floor
]

{ #category : #statistics }
PCMeanConfidenceIntervalPrinter >> studentsTConfidenceFactorFor: size [
	"Answer a pre-calculated value for a confidence interval of ~90%."
	"Supported for 1 <= size <= 30."
	"The students T distribution sucks to calculate since the value depends on the size."

	| values |
	values := Array new: 30.
	values at: 1  put: 6.314.
	values at: 2  put: 2.920.
	values at: 3  put: 2.353.
	values at: 4  put: 2.132.
	values at: 5  put: 2.015.
	values at: 6  put: 1.943.
	values at: 7  put: 1.895.
	values at: 8  put: 1.860.
	values at: 9  put: 1.833.
	values at: 10 put: 1.812.
	values at: 11 put: 1.796.
	values at: 12 put: 1.782.
	values at: 13 put: 1.771.
	values at: 14 put: 1.761.
	values at: 15 put: 1.753.
	values at: 16 put: 1.746.
	values at: 17 put: 1.740.
	values at: 18 put: 1.734.
	values at: 19 put: 1.729.
	values at: 20 put: 1.725.
	values at: 21 put: 1.721.
	values at: 22 put: 1.717.
	values at: 23 put: 1.714.
	values at: 24 put: 1.711.
	values at: 25 put: 1.708.
	values at: 26 put: 1.706.
	values at: 27 put: 1.703.
	values at: 28 put: 1.701.
	values at: 29 put: 1.699.
	values at: 30 put: 1.697.
	^ values at: size
	
]
