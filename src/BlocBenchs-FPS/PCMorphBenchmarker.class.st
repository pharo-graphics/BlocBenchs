"
I'm a benchmarker for raw Morphic window rendering using Cairo.
"
Class {
	#name : #PCMorphBenchmarker,
	#superclass : #PCBenchmarker,
	#instVars : [
		'window',
		'morph'
	],
	#category : #'BlocBenchs-FPS-Benchmarkers'
}

{ #category : #hook }
PCMorphBenchmarker >> closeWindow [

	window delete

]

{ #category : #hook }
PCMorphBenchmarker >> elapsedTimeSinceFirstDraw [

	^ morph elapsedTimeSinceFirstDraw
]

{ #category : #hook }
PCMorphBenchmarker >> frameCount [

	^ morph frameCount
]

{ #category : #printing }
PCMorphBenchmarker >> label [

	^ 'Raw Cairo'
]

{ #category : #hook }
PCMorphBenchmarker >> openWindow [
	
	morph := case newMorph.
	window := morph openInWindowLabeled: self labelWithCase.
	window
		position: 30 asPoint;
		extent: case surfaceExtent.

]
