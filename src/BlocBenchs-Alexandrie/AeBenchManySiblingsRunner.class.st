Class {
	#name : #AeBenchManySiblingsRunner,
	#superclass : #Object,
	#instVars : [
		'surfaceExtent',
		'matrixDimension',
		'cairoContext',
		'cairoSurface',
		'cellDrawStrategy',
		'millisecondsToRun',
		'numberOfRuns',
		'figureFactoryBlock',
		'figures'
	],
	#category : #'BlocBenchs-Alexandrie'
}

{ #category : #accessing }
AeBenchManySiblingsRunner >> cairoSurface [

	^ cairoSurface
]

{ #category : #initialization }
AeBenchManySiblingsRunner >> initialize [

	super initialize.

	numberOfRuns := 30.
	surfaceExtent := 1000 @ 600.
	matrixDimension := 50 @ 50.
	figureFactoryBlock := [ AeBenchRRectFigure new ]
]

{ #category : #running }
AeBenchManySiblingsRunner >> prepareFirstStep [

	| cellExtent |
	cairoSurface := AeCairoImageSurface
		extent: surfaceExtent
		format: AeCairoSurfaceFormat argb32.
	cairoContext := cairoSurface newContext.

	cellExtent := surfaceExtent / matrixDimension.
	figures := OrderedCollection new.
	1 to: matrixDimension x do: [ :colIndex |
		1 to: matrixDimension y do: [ :rowIndex |
			figures add:
				(figureFactoryBlock value
					position: (Point
						x: (colIndex - 1) * cellExtent x
						y: (rowIndex - 1) * cellExtent y);
					extent: cellExtent;
					consolidate;
					yourself) ] ]
]

{ #category : #running }
AeBenchManySiblingsRunner >> prepareToStep [

	cairoContext clearTransparent
]

{ #category : #printing }
AeBenchManySiblingsRunner >> reportOn: stream [

	| separator sortedMS |
	separator := ' | '.

	stream
		nextPutAll: '# runs: ';
		print: millisecondsToRun size.

	stream
		nextPutAll: separator;
		nextPutAll: '# figures: ';
		print: figures size.

	stream
		nextPutAll: separator;
		nextPutAll: 'mean: '.
	MeanConfidenceIntervalPrinter new
		unitString: 'ms';
		print: millisecondsToRun
			on: stream.

	sortedMS := millisecondsToRun sorted asArray.
	stream
		nextPutAll: separator;
		nextPutAll: 'top 10%: '.
	(sortedMS last: (millisecondsToRun size * 0.1) ceiling) printElementsOn: stream.

	stream
		nextPutAll: separator;
		nextPutAll: 'bottom 10%: '.
	(sortedMS first: (millisecondsToRun size * 0.1) ceiling) printElementsOn: stream.

	stream cr
]

{ #category : #printing }
AeBenchManySiblingsRunner >> reportString [

	^ String streamContents: [ :stream | self reportOn: stream ]
]

{ #category : #running }
AeBenchManySiblingsRunner >> run [
	<script: 'self new run'>

	self prepareFirstStep.

	millisecondsToRun := Array streamContents: [ :msStream |
		numberOfRuns timesRepeat: [
			self prepareToStep.
			msStream nextPut:
				(Time millisecondsToRun: [ self step ]) ] ].

	self reportOn: Transcript.
	Transcript flush.
	
	cairoSurface inspect.
]

{ #category : #running }
AeBenchManySiblingsRunner >> step [

	figures do: [ :each | each drawOn: cairoContext ]
]
