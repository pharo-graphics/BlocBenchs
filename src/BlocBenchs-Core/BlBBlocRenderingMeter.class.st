Class {
	#name : #BlBBlocRenderingMeter,
	#superclass : #BlBMeter,
	#category : #'BlocBenchs-Core-Core'
}

{ #category : #reporting }
BlBBlocRenderingMeter >> reportResultsFrom: aBlBBlocBenchRunner in: aBlBResult [ 
	
	| stats fpsSamples mean |
	stats := aBlBBlocBenchRunner space spaceStatistics.
	fpsSamples := stats fpsSamples allButFirst collect: [:e | e second].

	aBlBResult 
		addField: #totalRenderTime 
		title: 'Total Render Time (ms)'
		value: stats totalTime.

	aBlBResult 
		addField: #frameCount 
		title: 'Frame Count'
		value: stats totalFrames.

	mean := fpsSamples 
		ifEmpty: [ 0 ] 
		ifNotEmpty: [ (MeanConfidenceIntervalPrinter new print: fpsSamples)].

	aBlBResult 
		addField: #fps 
		title: 'FPS mean and error margin (90% confidence level)'
		value: mean.
	
	aBlBResult 
		addField: #fpsSamples 
		title: 'Raw FPS samples'
		value: stats fpsSamples.
		
	aBlBResult 
		addField: #phaseStatistics 
		title: 'Phase Statistics'
		value: stats phaseStatistics		
	
]

{ #category : #mettering }
BlBBlocRenderingMeter >> startMetering: aBlBBlocBenchRunner [ 
	
	aBlBBlocBenchRunner space enableStatistics 
]

{ #category : #mettering }
BlBBlocRenderingMeter >> stopMetering: aBlBBlocBenchRunner [ 
	
	
]
