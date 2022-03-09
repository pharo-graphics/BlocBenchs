"
I'm a benchmarker for Roassal3.
"
Class {
	#name : #PCRoassal3Benchmarker,
	#superclass : #PCBenchmarker,
	#instVars : [
		'wrapper',
		'roassalCanvas',
		'window'
	],
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #hook }
PCRoassal3Benchmarker >> closeWindow [

	window delete
]

{ #category : #hook }
PCRoassal3Benchmarker >> elapsedTimeSinceFirstDraw [

	^ wrapper elapsedTimeSinceFirstDraw
]

{ #category : #hook }
PCRoassal3Benchmarker >> frameCount [

	^ wrapper frameCount
]

{ #category : #printing }
PCRoassal3Benchmarker >> label [

	^ 'Roassal3'
]

{ #category : #hook }
PCRoassal3Benchmarker >> openWindow [
	
	wrapper := case newRoassalWrapperMorph.
	window := wrapper openInWindowLabeled: self labelWithCase.
	window
		position: 30 asPoint;
		extent: case surfaceExtent.

]
