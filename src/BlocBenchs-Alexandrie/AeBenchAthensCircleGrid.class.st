"
Benchmark for Athens surfaces analog to `AeBenchFigureGridRunner` with `#AeBenchCircleFigure`.
"
Class {
	#name : #AeBenchAthensCircleGrid,
	#superclass : #Object,
	#instVars : [
		'surfaceExtent',
		'matrixDimension',
		'surfaceClass',
		'numberOfRuns'
	],
	#category : #'BlocBenchs-Alexandrie-Grid'
}

{ #category : #running }
AeBenchAthensCircleGrid class >> run [
	<script: 'self run'>
	
	{ AthensCairoSurface. AthensAeCairoSurface } do: [ :each |
		self new surfaceClass: each; run ]
]

{ #category : #running }
AeBenchAthensCircleGrid >> initialize [

	super initialize.
	
	surfaceExtent := 900@449.
	matrixDimension := 20@10.
	numberOfRuns := 35.
	surfaceClass := AthensAeCairoSurface
]

{ #category : #running }
AeBenchAthensCircleGrid >> run [
	<script: 'self new run'>

	| cellExtent radius surface millisecondsToRun path strokePaint |
	cellExtent := surfaceExtent / matrixDimension.
	radius := cellExtent x / 2.
	surface := surfaceClass extent: surfaceExtent.

	millisecondsToRun := OrderedCollection new.

	surface drawDuring: [ :canvas |
		path :=
			(canvas createPath: [ :builder |
				builder
					moveToX: radius * 2 Y: radius;
					arcCenterX: radius
						centerY: radius
						radius: radius
						startAngle: 0.0
						endAngle: Float twoPi ]).
		strokePaint := canvas setStrokePaint: Color red.
		strokePaint width: 1.
		
		numberOfRuns timesRepeat: [
			surface clear.

			millisecondsToRun add:
				(Time millisecondsToRun: [

					1 to: matrixDimension x do: [:colIndex |
						1 to: matrixDimension y do: [: rowIndex |
							canvas pathTransform
								loadIdentity;
								translateX: (colIndex -1) * cellExtent x
										Y: (rowIndex - 1) * cellExtent y.
							canvas
								setPaint: Color yellow;
								drawShape: path.
							canvas
								setPaint: strokePaint;
								drawShape: path ] ]
						]).
					].
		].

	surface asForm inspect.

	surfaceClass traceCr.
	MeanConfidenceIntervalPrinter new
			unitString: 'ms';
			fixedDecimalPlaces: 1;
			print: millisecondsToRun on: Transcript.
	Transcript cr; cr; flush
]

{ #category : #accessing }
AeBenchAthensCircleGrid >> surfaceClass [

	^ surfaceClass
]

{ #category : #accessing }
AeBenchAthensCircleGrid >> surfaceClass: anObject [

	surfaceClass := anObject
]
