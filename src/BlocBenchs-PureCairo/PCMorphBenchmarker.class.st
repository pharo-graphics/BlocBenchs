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
	#category : #'BlocBenchs-PureCairo'
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

	^ 'Morph Cairo'
]

{ #category : #hook }
PCMorphBenchmarker >> openWindow [
	
	morph := case newMorph.
	window := morph openInWindowLabeled: self labelWithCase.
	window extent: case surfaceExtent.

]
