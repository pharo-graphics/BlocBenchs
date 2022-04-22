Class {
	#name : #PCSolidBorderCirclesMorph,
	#superclass : #PCCirclesMorph,
	#category : #'BlocBenchs-FPS-RawMorph'
}

{ #category : #drawing }
PCSolidBorderCirclesMorph >> drawPath [

	cairoContext
		primSetLineWidth: case borderWidth;
		primStroke
]
