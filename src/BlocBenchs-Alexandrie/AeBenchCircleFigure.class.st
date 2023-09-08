Class {
	#name : #AeBenchCircleFigure,
	#superclass : #AeBenchFigure,
	#instVars : [
		'radius',
		'center'
	],
	#category : #'BlocBenchs-Alexandrie'
}

{ #category : #drawing }
AeBenchCircleFigure >> consolidate [

	super consolidate.
	
	radius := extent min / 2.
	center := position - radius
]

{ #category : #drawing }
AeBenchCircleFigure >> drawOn: aCairoContext [

	aCairoContext
		circleCenterX: center x
			y: center y
			radius: radius.
	
	aCairoContext
		sourceColorRGBA: fillColor;
		fillPreserve.

	aCairoContext
		sourceColorRGBA: strokeColor;
		stroke
]
