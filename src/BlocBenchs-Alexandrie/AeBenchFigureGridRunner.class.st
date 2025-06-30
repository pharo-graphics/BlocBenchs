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
		'figures',
		'cachePath',
		'strokeFigures',
		'fillFigures'
	],
	#category : #'BlocBenchs-Alexandrie-Grid'
}

{ #category : #accessing }
AeBenchFigureGridRunner >> cachePath: aBoolean [

	cachePath := aBoolean
]

{ #category : #accessing }
AeBenchFigureGridRunner >> cairoSurface [

	^ cairoSurface
]

{ #category : #accessing }
AeBenchFigureGridRunner >> fillFigures: aBoolean [

	fillFigures := aBoolean
]

{ #category : #initialization }
AeBenchFigureGridRunner >> initialize [

	super initialize.

	numberOfRuns := 35.
	surfaceExtent := 900 @ 450.
	matrixDimension := 20 @ 10.
	figureFactoryBlock := [ AeBenchCircleFigure new ].
	cachePath := false.
	strokeFigures := true.
	fillFigures := true.
]

{ #category : #running }
AeBenchFigureGridRunner >> prepareFigures [

	| cellExtent aRandom |
	aRandom := Random seed: 7.
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
			
			strokeFigures ifTrue: [ 
				newFigure strokeColor: (PCFloatColor newFrom: Color red) ].
"				newFigure strokeColor: (PCFloatColor newFrom: (Color random: aRandom)) ]."
			fillFigures ifTrue: [ 
				newFigure fillColor: (PCFloatColor newFrom: Color yellow) ].
"				newFigure fillColor: (PCFloatColor newFrom: (Color random: aRandom)) ]."
			cachePath ifTrue: [
				newFigure cachePathWith: cairoContext].
			
			figures add: newFigure ] ]
]

{ #category : #running }
AeBenchFigureGridRunner >> prepareSurface [

	cairoSurface := AeCairoImageSurface
		extent: surfaceExtent
		format: AeCairoSurfaceFormat argb32.
	cairoContext := cairoSurface newContext.
	cairoContext antialias: AeCairoAntialias good.
	cairoContext strokeSize: 1
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

	self
		prepareSurface;
		prepareFigures.

	millisecondsToRun := Array streamContents: [ :msStream |
		numberOfRuns timesRepeat: [
			self prepareToStep.
			msStream nextPut:
				(Time millisecondsToRun: [ self step ]) ] ].

	self reportString traceCr.
	cairoSurface inspect
]

{ #category : #running }
AeBenchFigureGridRunner >> step [

	figures do: [ :each | each drawOn: cairoContext ]
]

{ #category : #accessing }
AeBenchFigureGridRunner >> strokeFigures: aBoolean [

	strokeFigures := aBoolean
]
