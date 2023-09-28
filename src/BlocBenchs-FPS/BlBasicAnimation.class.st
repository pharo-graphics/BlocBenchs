Class {
	#name : 'BlBasicAnimation',
	#superclass : 'BlBaseAnimation',
	#instVars : [
		'stepBlock'
	],
	#category : 'BlocBenchs-FPS-Utility',
	#package : 'BlocBenchs-FPS',
	#tag : 'Utility'
}

{ #category : 'pulse' }
BlBasicAnimation >> doStep [
	stepBlock cull: target
]

{ #category : 'accessing' }
BlBasicAnimation >> duration [

	^ 1 minute
]

{ #category : 'accessing' }
BlBasicAnimation >> initialize [ 
	super initialize.
	
	self beInfinite.
]

{ #category : 'pulse' }
BlBasicAnimation >> onStepDo: aBlock [
	stepBlock := aBlock
]
