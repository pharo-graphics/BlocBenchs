Class {
	#name : #PCSolidBorderCirclesMorph,
	#superclass : #PCCirclesMorph,
	#category : #'BlocBenchs-FPS'
}

{ #category : #drawing }
PCSolidBorderCirclesMorph >> drawPath [

	cairoCanvas
		primSetLineWidth: case borderWidth;
		stroke
]
