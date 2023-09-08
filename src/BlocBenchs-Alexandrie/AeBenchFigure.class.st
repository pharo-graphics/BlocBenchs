Class {
	#name : #AeBenchFigure,
	#superclass : #Object,
	#instVars : [
		'fillColor',
		'strokeColor',
		'position',
		'extent'
	],
	#category : #'BlocBenchs-Alexandrie'
}

{ #category : #initialization }
AeBenchFigure >> consolidate [
	
	fillColor ifNil: [
		fillColor := PCFloatColor newFrom: Color random ].
	strokeColor ifNil: [
		strokeColor := PCFloatColor newFrom: Color random ].
]

{ #category : #geometry }
AeBenchFigure >> extent: aPoint [

	extent := aPoint
]

{ #category : #accessing }
AeBenchFigure >> position: aPoint [

	position := aPoint
]
