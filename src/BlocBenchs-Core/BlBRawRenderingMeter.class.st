Class {
	#name : #BlBRawRenderingMeter,
	#superclass : #BlBMeter,
	#instVars : [
		'initialTime',
		'finalTime'
	],
	#category : #'BlocBenchs-Core-Core'
}

{ #category : #'as yet unclassified' }
BlBRawRenderingMeter >> reportResultsFrom: aBlBRawBenchRunner in: aBlBResult [ 
	
	| fpsSamples |

	fpsSamples := aBlBRawBenchRunner fpsSamples allButFirst collect: [:e | e second].
	
	aBlBResult 
		addField: #totalRenderTime 
		title: 'Total Render Time (ms)'
		value: finalTime - initialTime.

	aBlBResult 
		addField: #frameCount 
		title: 'Frame Count'
		value: aBlBRawBenchRunner totalFrames.

	aBlBResult 
		addField: #fps 
		title: 'FPS mean and error margin (90% confidence level)'
		value: (MeanConfidenceIntervalPrinter new print: fpsSamples).
	
	aBlBResult 
		addField: #fpsSamples 
		title: 'Raw FPS samples'
		value: aBlBRawBenchRunner fpsSamples.
	
]

{ #category : #'as yet unclassified' }
BlBRawRenderingMeter >> startMetering: aBlBBlocBenchRunner [ 
	
	initialTime := Time millisecondClockValue 
]

{ #category : #'as yet unclassified' }
BlBRawRenderingMeter >> stopMetering: aBlBBlocBenchRunner [ 
	
	finalTime := Time millisecondClockValue 
]
