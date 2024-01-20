"
I'm a benchmarker for raw Morphic window rendering using Cairo.
"
Class {
	#name : #PCRawBenchmarker,
	#superclass : #PCBenchmarker,
	#instVars : [
		'rawWindow'
	],
	#category : #'BlocBenchs-FPS-Benchmarkers'
}

{ #category : #hook }
PCRawBenchmarker >> closeWindow [

	rawWindow stopLoop.
	rawWindow close

]

{ #category : #hook }
PCRawBenchmarker >> elapsedTimeSinceFirstDraw [

	^ rawWindow elapsedTimeSinceFirstDraw
]

{ #category : #hook }
PCRawBenchmarker >> frameCount [

	^ rawWindow frameCount
]

{ #category : #hook }
PCRawBenchmarker >> framesDeltaMS [

	^ rawWindow framesDeltaMS
]

{ #category : #printing }
PCRawBenchmarker >> label [

	^ 'Raw SDL2+Cairo'
]

{ #category : #hook }
PCRawBenchmarker >> openWindow [
	
	rawWindow := case newRawSDLCairoWindow.
	rawWindow
		openWithTitle: self labelWithCase
		position: 30 asPoint
		extent: case logicalExtent
		"shape: (SDLShapedWindowExample surfaceWithRoundedCornersExtent: case logicalExtent)".
	rawWindow startLoop
]
