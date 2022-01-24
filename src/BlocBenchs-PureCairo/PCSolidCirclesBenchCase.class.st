Class {
	#name : #PCSolidCirclesBenchCase,
	#superclass : #PCTranslatingFiguresBenchCase,
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #'instance creation' }
PCSolidCirclesBenchCase >> newFigureWith: random [
	
	^ BlElement new
		geometry: BlCircleGeometry new;
		size: self radius * 2;
		background: (Color random: random);
		yourself
]

{ #category : #hook }
PCSolidCirclesBenchCase >> newMorph [

	^ PCTranslatingCirclesMorph new
		  surfaceExtent: self surfaceExtent;
		  random: self newRandom;
		  numberOfFigures: self numberOfFigures;
		  figureOffset: self figureOffset;
		  radius: self radius;
		  yourself
]

{ #category : #hook }
PCSolidCirclesBenchCase >> radius [

	^ 50.0 asPoint
]
