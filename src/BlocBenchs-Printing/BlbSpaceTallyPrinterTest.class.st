Class {
	#name : #BlbSpaceTallyPrinterTest,
	#superclass : #TestCase,
	#category : #'BlocBenchs-Printing'
}

{ #category : #tests }
BlbSpaceTallyPrinterTest >> testReportAsString [

	| printer |
	printer := BlbSpaceTallyPrinter new.
	
	printer run.
	
	self assert: printer reportAsString lines size > 50
]
