Class {
	#name : #AeBenchFigure,
	#superclass : #Object,
	#instVars : [
		'fillColor',
		'strokeColor',
		'position',
		'extent',
		'cachedPath'
	],
	#category : #'BlocBenchs-Alexandrie-Grid'
}

{ #category : #initialization }
AeBenchFigure >> cachePathWith: aCairoContext [
	
	aCairoContext restoreStateAfter: [
		self drawPathOn: aCairoContext.
		cachedPath := aCairoContext currentPath ]
]

{ #category : #initialization }
AeBenchFigure >> consolidate [

]

{ #category : #drawing }
AeBenchFigure >> drawOn: aCairoContext [

	aCairoContext
		saveState;
		translateByX: position x y: position y.

	cachedPath
		ifNil: [ self drawPathOn: aCairoContext ]
		ifNotNil: [
			aCairoContext appendPath: cachedPath ].

	fillColor ifNotNil: [
		aCairoContext
			sourceColor: fillColor;
			fillPreservingPath: strokeColor notNil ].

	strokeColor ifNotNil: [
		aCairoContext
			sourceColor: strokeColor;
			stroke ].

	aCairoContext restoreState
]

{ #category : #drawing }
AeBenchFigure >> drawPathOn: aCairoContext [

	self subclassResponsibility
]

{ #category : #geometry }
AeBenchFigure >> extent: aPoint [

	extent := aPoint
]

{ #category : #accessing }
AeBenchFigure >> fillColor: anObject [

	fillColor := anObject
]

{ #category : #accessing }
AeBenchFigure >> position: aPoint [

	position := aPoint
]

{ #category : #accessing }
AeBenchFigure >> strokeColor: anObject [

	strokeColor := anObject
]
