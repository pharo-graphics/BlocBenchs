Class {
	#name : #AeBenchCircleFigure,
	#superclass : #AeBenchFigure,
	#instVars : [
		'radius',
		'center'
	],
	#category : #'BlocBenchs-Alexandrie-Grid'
}

{ #category : #drawing }
AeBenchCircleFigure >> consolidate [
	
	super consolidate.
	
	radius := extent min // 2.
	center := extent // 2
]

{ #category : #drawing }
AeBenchCircleFigure >> drawPathOn: aCairoContext [

	aCairoContext circleCenter: center radius: radius
]
