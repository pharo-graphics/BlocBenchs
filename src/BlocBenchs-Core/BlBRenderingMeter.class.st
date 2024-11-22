Class {
	#name : #BlBRenderingMeter,
	#superclass : #BlBMeter,
	#category : #'BlocBenchs-Core'
}

{ #category : #'as yet unclassified' }
BlBRenderingMeter >> reportResultsFrom: aBlBBlocBenchRunner in: aBlBResult [ 
	
	| stats fpsSamples |
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

	aBlBResult 
		addField: #fps 
		title: 'FPS mean and error margin (90% confidence level)'
		value: (MeanConfidenceIntervalPrinter new print: fpsSamples).
	
	aBlBResult 
		addField: #fpsSamples 
		title: 'Raw FPS samples'
		value: stats fpsSamples.
		
	aBlBResult 
		addField: #phaseStatistics 
		title: 'Phase Statistics'
		value: stats phaseStatistics		
	
]

{ #category : #'as yet unclassified' }
BlBRenderingMeter >> startMetering: aBlBBlocBenchRunner [ 
	
	aBlBBlocBenchRunner space enableStatistics 
]

{ #category : #'as yet unclassified' }
BlBRenderingMeter >> stopMetering: aBlBBlocBenchRunner [ 
	
	
]
