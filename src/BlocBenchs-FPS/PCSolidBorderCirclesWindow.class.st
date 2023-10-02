Class {
	#name : #PCSolidBorderCirclesWindow,
	#superclass : #PCCirclesWindow,
	#category : 'BlocBenchs-FPS-Raw'
}

{ #category : #drawing }
PCSolidBorderCirclesWindow >> drawPath [

	cairoContext
		lineWidth: case borderWidth;
		stroke
]
