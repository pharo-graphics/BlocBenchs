Class {
	#name : #AeBenchFigureGridRunner,
	#superclass : #Object,
	#instVars : [
		'surfaceExtent',
		'matrixDimension',
		'cairoContext',
		'cairoSurface',
		'millisecondsToRun',
		'numberOfRuns',
		'figureFactoryBlock',
		'figures'
	],
	#category : #'BlocBenchs-Alexandrie'
}

{ #category : #accessing }
AeBenchFigureGridRunner >> cairoSurface [

	^ cairoSurface
]

{ #category : #initialization }
AeBenchFigureGridRunner >> initialize [

	super initialize.

	numberOfRuns := 35.
	surfaceExtent := 1000 @ 600.
	matrixDimension := 20 @ 10.
	figureFactoryBlock := [ AeBenchCircleFigure new ]
]

{ #category : #running }
AeBenchFigureGridRunner >> prepareFirstStep [

	| cellExtent |
	cairoSurface := AeCairoImageSurface
		extent: surfaceExtent
		format: AeCairoSurfaceFormat argb32.
	cairoContext := cairoSurface newContext.
	cairoContext antialias: AeCairoAntialias fast.

	cellExtent := surfaceExtent / matrixDimension.
	figures := OrderedCollection new.
	1 to: matrixDimension x do: [ :colIndex |
		1 to: matrixDimension y do: [ :rowIndex |
			| newFigure |
			newFigure :=
				(figureFactoryBlock value
					position: (Point
						x: (colIndex - 1) * cellExtent x
						y: (rowIndex - 1) * cellExtent y);
					extent: cellExtent;
					consolidate;
					yourself).
			
"			newFigure cachePathWith: cairoContext."
			"todo: add parameter to ensure integer or 0.5 positions"
			
			figures add: newFigure ] ]
]

{ #category : #running }
AeBenchFigureGridRunner >> prepareToStep [

	cairoContext clearTransparent
]

{ #category : #printing }
AeBenchFigureGridRunner >> reportOn: stream [

	| sortedMS |
	stream
		nextPutAll: ('LABEL: {1} figures in {3} surface {2}'
			format: {
				figures size.
				surfaceExtent.
				(surfaceExtent x * surfaceExtent y * 4) humanReadableByteSizeString }).

	stream
		nextPutAll: ' STATS: '.
	MeanConfidenceIntervalPrinter new
		unitString: 'ms';
		fixedDecimalPlaces: 1;
		print: millisecondsToRun on: stream.

	sortedMS := millisecondsToRun sorted asArray.
	stream
		nextPutAll: '; faster tenth: '.
	(sortedMS first: (millisecondsToRun size * 0.1) ceiling)
		do: [:element | stream print: element ]
		separatedBy: [stream space].
	stream
		nextPutAll: '; slower tenth: '.
	(sortedMS last: (millisecondsToRun size * 0.1) ceiling)
		do: [:element | stream print: element ]
		separatedBy: [stream space].

	stream
		nextPutAll: '; runs: ';
		print: millisecondsToRun size.

	stream cr; flush
]

{ #category : #printing }
AeBenchFigureGridRunner >> reportString [

	^ String streamContents: [ :stream | self reportOn: stream ]
]

{ #category : #running }
AeBenchFigureGridRunner >> run [
	<script: 'AeBenchFigureGridRunner new run'>

	self prepareFirstStep.

	millisecondsToRun := Array streamContents: [ :msStream |
		numberOfRuns timesRepeat: [
			self prepareToStep.
			msStream nextPut:
				(Time millisecondsToRun: [ self step ]) ] ].

	self reportOn: Transcript.
		
	cairoSurface inspect.
]

{ #category : #running }
AeBenchFigureGridRunner >> step [

	figures do: [ :each | each drawOn: cairoContext ]
]
