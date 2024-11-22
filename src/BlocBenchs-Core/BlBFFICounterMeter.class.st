Class {
	#name : #BlBFFICounterMeter,
	#superclass : #BlBMeter,
	#instVars : [
		'functionNamesAndCounts'
	],
	#category : #'BlocBenchs-Core'
}

{ #category : #'as yet unclassified' }
BlBFFICounterMeter >> reportResultsFrom: aBlBBlocBenchRunner in: aBlBResult [ 

	aBlBResult 
		addField: #totalFFICallsPerFrame 
		title: 'Total FFI Calls per frame'
		value: functionNamesAndCounts values sum.

	aBlBResult 
		addField: #ffiCalls 
		title: 'FFI Calls per frame'
		value: functionNamesAndCounts.

]

{ #category : #'as yet unclassified' }
BlBFFICounterMeter >> startMetering: aBlBBlocBenchRunner [ 
	
	"Ensure prepared"
	TFLSignal install.
	TFLFunctionCounter resetInstance.

	"Really start"
	TFLFunctionCounter start.

	aBlBBlocBenchRunner space enableStatistics.
]

{ #category : #'as yet unclassified' }
BlBFFICounterMeter >> stopMetering: aBlBBlocBenchRunner [ 
	
	"Extract relevant information of the global logger, and reset it."

	| frameCount |

	frameCount := aBlBBlocBenchRunner space spaceStatistics totalFrames.

	functionNamesAndCounts := TFLFunctionCounter instance functionNamesAndCounts.
	functionNamesAndCounts := OrderedDictionary newFrom: 
		(functionNamesAndCounts associations sorted: [ :a :b |
			a value > b value ]).
	functionNamesAndCounts := functionNamesAndCounts
		collect: [ :value | (value / frameCount) asFloat ].

	TFLSignal uninstall.
	TFLFunctionCounter stop; resetInstance.
]
