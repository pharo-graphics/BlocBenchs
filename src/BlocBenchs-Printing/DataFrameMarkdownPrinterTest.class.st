"
A DataFrameMarkdownPrinterTest is a test class for testing the behavior of DataFrameMarkdownPrinter
"
Class {
	#name : #DataFrameMarkdownPrinterTest,
	#superclass : #TestCase,
	#category : #'BlocBenchs-Printing'
}

{ #category : #tests }
DataFrameMarkdownPrinterTest >> testHomogeneus [

	| df print |
	df := DataFrame 
		withRowNames: #(r1 r2)
		columnNames: #(c1 c2 c3 c4).

	1 to: df rowNames size do: [ :rowIndex |
		1 to: df columnNames size do: [ :columnIndex |
			df 
				at: rowIndex at: columnIndex 
				put: (rowIndex asString, columnIndex asString) ] ].


	print := String streamContents: [ :stream |
		DataFrameMarkdownPrinter new
			stream: stream;
			dataFrame: df;
			write ].
	self assert: print withUnixLineEndings equals: 
'| #  | c1 | c2 | c3 | c4 |
|----|----|----|----|----|
| r1 | 11 | 12 | 13 | 14 |
| r2 | 21 | 22 | 23 | 24 |
' withUnixLineEndings.
]

{ #category : #tests }
DataFrameMarkdownPrinterTest >> testNonHomogeneus [

	| df print |
	df := DataFrame 
		withRowNames: #(r1 r2)
		columnNames: #(c1 c2 c3 c4).

	1 to: df rowNames size do: [ :rowIndex |
		1 to: df columnNames size do: [ :columnIndex |
			df 
				at: rowIndex at: columnIndex 
				put: (String new: rowIndex * columnIndex withAll: $o) ] ].

	print := String streamContents: [ :stream |
		DataFrameMarkdownPrinter new
			stream: stream;
			dataFrame: df;
			write ].
	self assert: print withUnixLineEndings equals: 
'| #  | c1 |   c2 |     c3 |       c4 |
|----|----|------|--------|----------|
| r1 |  o |   oo |    ooo |     oooo |
| r2 | oo | oooo | oooooo | oooooooo |
' withUnixLineEndings.
]
