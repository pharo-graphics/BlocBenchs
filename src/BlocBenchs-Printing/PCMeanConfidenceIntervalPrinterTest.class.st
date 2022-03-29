"
A DataSeriesStatisticsPrinterTest is a test class for testing the behavior of DataSeriesStatisticsPrinter
"
Class {
	#name : #PCMeanConfidenceIntervalPrinterTest,
	#superclass : #TestCase,
	#category : #'BlocBenchs-Printing'
}

{ #category : #tests }
PCMeanConfidenceIntervalPrinterTest >> testPrintMultipleExamples [

	| printer |
	printer := PCMeanConfidenceIntervalPrinter new.
	
	self assert: (printer print: (Array new: 1 withAll: 5)) equals: '5.00 ±0.00'.
	self assert: (printer print: (Array new: 10 withAll: 5)) equals: '5.00 ±0.00'.
	self assert: (printer print: (Array new: 30 withAll: 5)) equals: '5.00 ±0.00'.
	self assert: (printer print: (Array new: 100 withAll: 5)) equals: '5.00 ±0.00'.

	"Check if these values are correct"
	self assert: (printer print: (1 to: 10)) equals: '5.5 ±1.7'.
	self assert: (printer print: (1 to: 30)) equals: '15.5 ±2.6'.
]
