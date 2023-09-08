Class {
	#name : #AeBenchRRectFigure,
	#superclass : #AeBenchFigure,
	#instVars : [
		'radius'
	],
	#category : #'BlocBenchs-Alexandrie'
}

{ #category : #drawing }
AeBenchRRectFigure >> consolidate [

	super consolidate.
	radius := (extent // 5) min
]

{ #category : #drawing }
AeBenchRRectFigure >> drawOn: aCairoContext [

	aCairoContext
		translateByX: position x y: position y;
		roundedRectangleTo: extent radius: radius;
		sourceColorRGBA: fillColor;
		fillPreserve;
		sourceColorRGBA: strokeColor;
		stroke;
		translateByX: position x negated y: position y negated

]
