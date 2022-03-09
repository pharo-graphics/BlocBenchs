Class {
	#name : #PCSolidBorderCirclesMorph,
	#superclass : #PCCirclesMoph,
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #drawing }
PCSolidBorderCirclesMorph >> drawPath [

	cairoCanvas
		primSetLineWidth: case borderWidth;
		stroke
]
