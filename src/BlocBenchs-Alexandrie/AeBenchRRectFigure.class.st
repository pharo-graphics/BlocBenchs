Class {
	#name : #AeBenchRRectFigure,
	#superclass : #AeBenchFigure,
	#instVars : [
		'radius'
	],
	#category : #'BlocBenchs-Alexandrie-Grid'
}

{ #category : #drawing }
AeBenchRRectFigure >> consolidate [

	super consolidate.
	radius := (extent // 5) min
]

{ #category : #drawing }
AeBenchRRectFigure >> drawPathOn: aCairoContext [

	aCairoContext roundedRectangleTo: extent radius: radius
]
