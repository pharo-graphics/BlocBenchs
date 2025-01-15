Class {
	#name : #BlBRawRenderingMeter,
	#superclass : #BlBMeter,
	#instVars : [
		'initialTime',
		'finalTime'
	],
	#category : #'BlocBenchs-Core-Core'
}

{ #category : #reporting }
BlBRawRenderingMeter >> reportResultsFrom: aBlBRawBenchRunner in: aBlBResult [ 
	
	| fpsSamples mean |

	fpsSamples := aBlBRawBenchRunner fpsSamples allButFirst collect: [:e | e second].
	
	aBlBResult 
		addField: #totalRenderTime 
		title: 'Total Render Time (ms)'
		value: finalTime - initialTime.

	aBlBResult 
		addField: #frameCount 
		title: 'Frame Count'
		value: aBlBRawBenchRunner totalFrames.

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
		value: aBlBRawBenchRunner fpsSamples.
	
]

{ #category : #mettering }
BlBRawRenderingMeter >> startMetering: aBlBBlocBenchRunner [ 
	
	initialTime := Time millisecondClockValue 
]

{ #category : #mettering }
BlBRawRenderingMeter >> stopMetering: aBlBBlocBenchRunner [ 
	
	finalTime := Time millisecondClockValue 
]
