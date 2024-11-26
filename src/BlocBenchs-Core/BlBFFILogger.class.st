Class {
	#name : #BlBFFILogger,
	#superclass : #BlBMeter,
	#instVars : [
		'loggerCopy'
	],
	#category : #'BlocBenchs-Core-Core'
}

{ #category : #'as yet unclassified' }
BlBFFILogger >> reportResultsFrom: aBlBBlocBenchRunner in: aBlBResult [ 

	aBlBResult 
		addField: #ffiCallsLog 
		title: 'FFI Calls'
		value: loggerCopy
]

{ #category : #'as yet unclassified' }
BlBFFILogger >> startMetering: aBlBBlocBenchRunner [ 

	"Ensure prepared"
	TFLSignal install.
	TFLCallLogger resetInstance.
	TFLCallLogger instance entryCount: 20000.

	"Really start"
	TFLCallLogger instance start
]

{ #category : #'as yet unclassified' }
BlBFFILogger >> stopMetering: aBlBBlocBenchRunner [ 

	"Store a copy of the global logger, and reset it."

	loggerCopy := TFLCallLogger instance copy.

	TFLSignal uninstall.
	TFLCallLogger stop; resetInstance.
]
