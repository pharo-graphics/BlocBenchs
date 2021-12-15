"
I'm capable of printing certain DataFrame instances in Markdown table format.

"
Class {
	#name : #DataFrameMarkdownPrinter,
	#superclass : #Object,
	#instVars : [
		'dataFrame',
		'stream',
		'horizontalMargin',
		'columnWidths',
		'stringBlockClosure'
	],
	#category : #'BlocBenchs-Printing'
}

{ #category : #accessing }
DataFrameMarkdownPrinter >> columnWidths [

	^ columnWidths
]

{ #category : #accessing }
DataFrameMarkdownPrinter >> dataFrame [

	^ dataFrame
]

{ #category : #accessing }
DataFrameMarkdownPrinter >> dataFrame: aDataFrame [

	dataFrame := aDataFrame
]

{ #category : #accessing }
DataFrameMarkdownPrinter >> horizontalMargin [

	^ horizontalMargin
]

{ #category : #accessing }
DataFrameMarkdownPrinter >> horizontalMargin: aPositiveInteger [

	horizontalMargin := aPositiveInteger
]

{ #category : #initialization }
DataFrameMarkdownPrinter >> initialize [

	super initialize.
	
	horizontalMargin := 1.
	stringBlockClosure := [ :anObject | anObject asString ]

]

{ #category : #private }
DataFrameMarkdownPrinter >> isColumnIndexLeftAligned: columnIndex [

	^ columnIndex = 1
]

{ #category : #accessing }
DataFrameMarkdownPrinter >> stream [

	^ stream
]

{ #category : #accessing }
DataFrameMarkdownPrinter >> stream: aStream [

	stream := aStream
]

{ #category : #accessing }
DataFrameMarkdownPrinter >> stringBlockClosure [

	^ stringBlockClosure
]

{ #category : #accessing }
DataFrameMarkdownPrinter >> stringBlockClosure: aBlockClosure [

	stringBlockClosure := aBlockClosure
]

{ #category : #private }
DataFrameMarkdownPrinter >> stringFor: anObject rowIndex: rowIndex columnIndex: columnIndex [
	
	^ stringBlockClosure cull: anObject cull: rowIndex cull: columnIndex
]

{ #category : #writing }
DataFrameMarkdownPrinter >> write [

	| convertedColumns |	
	convertedColumns := Array streamContents: [ :columnsStream |
		"First column has the row names"
		columnsStream nextPut: ({'#'}, (dataFrame rowNames collect: [ :each | each asString ])).
		
		"The body of the table"
		dataFrame columns doWithIndex: [ :eachColumn :columnIndex |
			columnsStream nextPut: 
				(Array streamContents: [ :cellsStream |
					cellsStream nextPut: (dataFrame columnNames at: columnIndex) asString.
					eachColumn doWithIndex: [ :cellValue :rowIndex |
						cellsStream nextPut: (self
							stringFor: cellValue
							rowIndex: rowIndex
							columnIndex: columnIndex) ] ]) ] ].

	columnWidths := convertedColumns collect: [ :eachColumn |
		eachColumn max: [ :eachString | eachString size ]].

	"Transpose to iterate row by row"	
	(DataFrame withColumns: convertedColumns) asArrayOfRows
		readStreamDo: [ :rowStream |
			self writeRow: rowStream next.
			self writeHorizontalLine.
			[ rowStream atEnd ] whileFalse: [ 
				self writeRow: rowStream next ] ].

]

{ #category : #private }
DataFrameMarkdownPrinter >> writeCell: aString columnIndex: columnIndex [

	| columnWidth padding |
	columnWidth := columnWidths at: columnIndex.
	padding := String new: columnWidth - aString size withAll: Character space.

	(self isColumnIndexLeftAligned: columnIndex)
		ifTrue: [ stream << aString; << padding ]
		ifFalse: [ stream << padding; << aString ]

]

{ #category : #private }
DataFrameMarkdownPrinter >> writeHoritontalTick [

	stream nextPut: $-
]

{ #category : #private }
DataFrameMarkdownPrinter >> writeHorizontalLine [

	columnWidths
		do: [ :each |
			self writeVerticalTick.
			(each + (horizontalMargin * 2)) timesRepeat: [ self writeHoritontalTick ] ].
	self writeVerticalTick.
	stream lf.

]

{ #category : #private }
DataFrameMarkdownPrinter >> writeMargin [

	stream nextPut: Character space
]

{ #category : #private }
DataFrameMarkdownPrinter >> writeRow: aCollectionOfStrings [

	| columnIndex |
	columnIndex := 1.
	aCollectionOfStrings
		do: [ :each |
			self writeVerticalTick.
			self writeMargin.
			self writeCell: each columnIndex: columnIndex.
			columnIndex := columnIndex + 1.
			self writeMargin ].
	self writeVerticalTick.
	stream lf.

]

{ #category : #private }
DataFrameMarkdownPrinter >> writeVerticalTick [

	stream nextPut: $|
]
