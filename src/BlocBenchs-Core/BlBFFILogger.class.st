Class {
	#name : #BlBFFILogger,
	#superclass : #BlBMeter,
	#instVars : [
		'loggerCopy'
	],
	#category : #'BlocBenchs-Core-Core'
}

{ #category : #mettering }
BlBFFILogger >> ensureStop [ 

	TFLSignal uninstall.
	TFLCallLogger stop; resetInstance.
]

{ #category : #reporting }
BlBFFILogger >> reportResultsFrom: aBlBBlocBenchRunner in: aBlBResult [ 

	aBlBResult 
		addField: #ffiCallsLog 
		title: 'FFI Calls'
		value: loggerCopy
]

{ #category : #mettering }
BlBFFILogger >> startMetering: aBlBBlocBenchRunner [ 

	"Ensure prepared"
	TFLSignal install.
	TFLCallLogger resetInstance.
	TFLCallLogger instance entryCount: 20000.

	"Really start"
	TFLCallLogger instance start
]

{ #category : #mettering }
BlBFFILogger >> stopMetering: aBlBBlocBenchRunner [ 

	"Store a copy of the global logger, and reset it."

	loggerCopy := TFLCallLogger instance copy.

	self ensureStop 
]
