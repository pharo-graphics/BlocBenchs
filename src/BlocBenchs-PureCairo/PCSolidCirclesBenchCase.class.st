Class {
	#name : #PCSolidCirclesBenchCase,
	#superclass : #PCTranslatingFiguresBenchCase,
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #hook }
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
		  case: self;
		  yourself
]

{ #category : #accessing }
PCSolidCirclesBenchCase >> radius [

	^ 50.0 asPoint
]
