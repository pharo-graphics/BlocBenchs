Class {
	#name : #PCSolidBorderCirclesMorph,
	#superclass : #PCCirclesMorph,
	#category : #'BlocBenchs-FPS-RawMorph'
}

{ #category : #drawing }
PCSolidBorderCirclesMorph >> drawPath [

	cairoCanvas
		primSetLineWidth: case borderWidth;
		stroke
]
