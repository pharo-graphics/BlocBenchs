Class {
	#name : #BlFFILogger,
	#superclass : #BlMeter,
	#instVars : [
		'loggerCopy'
	],
	#category : #'BlocBenchs-Old'
}

{ #category : #API }
BlFFILogger >> reportsAsPagesUsing: aBuilder [

	^ { (SpNotebookPage
		   title: 'FFI Recorded Calls'
		   provider: [ 
		   aBuilder instantiate: TFLCallsPresenter on: loggerCopy ]) }
]

{ #category : #API }
BlFFILogger >> startMetering [

	"Ensure prepared"
	TFLCallLogger
		install;
		resetInstance.
	TFLCallLogger instance entryCount: 20000.

	"Really start"
	TFLCallLogger instance start
]

{ #category : #API }
BlFFILogger >> stopMetering [
	"Store a copy of the global logger, and reset it."

	loggerCopy := TFLCallLogger instance copy.

	TFLCallLogger stop; resetInstance.
]
