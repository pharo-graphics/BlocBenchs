"
A DataSeriesStatisticsPrinterTest is a test class for testing the behavior of DataSeriesStatisticsPrinter
"
Class {
	#name : #DataSeriesStatisticsPrinterTest,
	#superclass : #TestCase,
	#instVars : [
		'printer'
	],
	#category : #'BlocBenchs-Printing'
}

{ #category : #running }
DataSeriesStatisticsPrinterTest >> setUp [
	super setUp.
	
	printer := DataSeriesStatisticsPrinter new.
]

{ #category : #tests }
DataSeriesStatisticsPrinterTest >> testPrintMultipleExamples [

	self assert: (printer print: (Array new: 1 withAll: 5)) equals: '5.00 +/-0.00'.
	self assert: (printer print: (Array new: 10 withAll: 5)) equals: '5.00 +/-0.00'.
	self assert: (printer print: (Array new: 30 withAll: 5)) equals: '5.00 +/-0.00'.
	self assert: (printer print: (Array new: 100 withAll: 5)) equals: '5.00 +/-0.00'.

	"Check if these values are correct"
	self assert: (printer print: (1 to: 10)) equals: '5.5 +/-1.7'.
	self assert: (printer print: (1 to: 30)) equals: '15.5 +/-2.6'.
]
