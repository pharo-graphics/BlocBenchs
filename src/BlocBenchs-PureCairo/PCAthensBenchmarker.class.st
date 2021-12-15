Class {
	#name : #PCAthensBenchmarker,
	#superclass : #PCBenchmarker,
	#instVars : [
		'window',
		'morph'
	],
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #hook }
PCAthensBenchmarker >> closeWindow [

	window delete

]

{ #category : #hook }
PCAthensBenchmarker >> frameCount [

	^ morph frameCount
]

{ #category : #printing }
PCAthensBenchmarker >> label [

	^ 'Just Cairo'
]

{ #category : #hook }
PCAthensBenchmarker >> openWindow [
	
	morph := PCTranslatingCirclesMorph new
		surfaceExtent: 800@500;
		numberOfCircles: 300;
		radius: 50.0;
		yourself.
	window := morph openInWindowLabeled: self label.
	window extent: 800@500.

]

{ #category : #hook }
PCAthensBenchmarker >> realStartTimestamp [

	^ morph startTimestamp
]
