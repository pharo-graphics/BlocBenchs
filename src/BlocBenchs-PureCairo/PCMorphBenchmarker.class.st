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
PCMorphBenchmarker >> frameCount [

	^ morph frameCount
]

{ #category : #printing }
PCMorphBenchmarker >> label [

	^ 'Morph Cairo'
]

{ #category : #hook }
PCMorphBenchmarker >> openWindow [
	
	morph := PCTranslatingCirclesMorph new
		surfaceExtent: 800@500;
		numberOfCircles: 300;
		radius: 50.0 asPoint;
		yourself.
	window := morph openInWindowLabeled: self label.
	window extent: 800@500.

]

{ #category : #hook }
PCMorphBenchmarker >> realStartTimestamp [

	^ morph startTimestamp
]
