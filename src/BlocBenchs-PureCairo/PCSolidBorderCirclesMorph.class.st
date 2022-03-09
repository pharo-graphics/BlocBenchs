Class {
	#name : #PCSolidBorderCirclesMorph,
	#superclass : #PCCirclesMorph,
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #drawing }
PCSolidBorderCirclesMorph >> drawPath [

	cairoCanvas
		primSetLineWidth: case borderWidth;
		stroke
]
