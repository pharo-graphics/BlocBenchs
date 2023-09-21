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
	#category : #'BlocBenchs-Alexandrie'
}

{ #category : #initialization }
AeBenchFigure >> cachePathWith: aCairoContext [
	
	aCairoContext restoreStateAfter: [
		self drawPathOn: aCairoContext.
		cachedPath := aCairoContext currentPath ]
]

{ #category : #initialization }
AeBenchFigure >> consolidate [
	
	fillColor ifNil: [
		fillColor := PCFloatColor newFrom: Color random ].
	strokeColor ifNil: [
		strokeColor := PCFloatColor newFrom: Color random ]
]

{ #category : #drawing }
AeBenchFigure >> drawOn: aCairoContext [

	aCairoContext
		saveState;
		translateByX: position x y: position y.

	cachedPath
		ifNil: [ self drawPathOn: aCairoContext. ]
		ifNotNil: [ aCairoContext appendPath: cachedPath ].	

	aCairoContext
		sourceColorRGBA: fillColor;
		fillPreserve.

	aCairoContext
		sourceColorRGBA: strokeColor;
		stroke.

	aCairoContext
		restoreState
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
AeBenchFigure >> position: aPoint [

	position := aPoint
]
