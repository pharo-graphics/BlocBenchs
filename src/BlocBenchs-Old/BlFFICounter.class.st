Class {
	#name : #BlFFICounter,
	#superclass : #BlMeter,
	#instVars : [
		'functionNamesAndCounts'
	],
	#category : #'BlocBenchs-Old-ProfileCases'
}

{ #category : #API }
BlFFICounter >> reportAsStringOn: aStream [

	aStream
		<< 'FFI Call Stats'; lf;
		<< self reportCallStatsAsString; lf.
]

{ #category : #API }
BlFFICounter >> reportCallStatsAsString [

	^ String streamContents: [ :stream |
		stream
			<< 'Average: ';
			<< (functionNamesAndCounts values sum printShowingDecimalPlaces: 2);
			<< ' calls/frame'; lf.
		]
]

{ #category : #API }
BlFFICounter >> reportsAsPagesUsing: aBuilder [

	^ { 
		(SpNotebookPage 
			title: 'FFI Call Stats' 
			provider: [
				aBuilder newText text: self reportCallStatsAsString; yourself ]).
		(SpNotebookPage 
			title: 'FFI Calls (Avg. per Frame)'
			provider: [
				"Too many decimal places, else."
				(functionNamesAndCounts associations
					collect: [ :each | each key -> (each value printShowingDecimalPlaces: 1) ]) asOrderedDictionary
					inspectionItems: aBuilder ])
			}
]

{ #category : #API }
BlFFICounter >> startMetering [

	"Ensure prepared"
	TFLSignal install.
	TFLFunctionCounter resetInstance.

	"Really start"
	TFLFunctionCounter start.

	case space enableStatistics.
]

{ #category : #API }
BlFFICounter >> stopMetering [

	"Extract relevant information of the global logger, and reset it."

	| frameCount |

	frameCount := case space spaceStatistics totalFrames.

	functionNamesAndCounts := TFLFunctionCounter instance functionNamesAndCounts.
	functionNamesAndCounts := OrderedDictionary newFrom: 
		(functionNamesAndCounts associations sorted: [ :a :b |
			a value > b value ]).
	functionNamesAndCounts := functionNamesAndCounts
		collect: [ :value | (value / frameCount) asFloat ].

	TFLSignal uninstall.
	TFLFunctionCounter stop; resetInstance.
]
