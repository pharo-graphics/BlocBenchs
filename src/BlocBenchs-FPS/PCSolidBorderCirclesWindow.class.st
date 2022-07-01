Class {
	#name : #PCSolidBorderCirclesWindow,
	#superclass : #PCCirclesWindow,
	#category : #'BlocBenchs-FPS-Raw'
}

{ #category : #drawing }
PCSolidBorderCirclesWindow >> drawPath [

	cairoContext
		primSetLineWidth: case borderWidth;
		primStroke
]
