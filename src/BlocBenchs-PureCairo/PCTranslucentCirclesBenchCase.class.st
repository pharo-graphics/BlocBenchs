Class {
	#name : #PCTranslucentCirclesBenchCase,
	#superclass : #PCTranslatingFiguresBenchCase,
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #accessing }
PCTranslucentCirclesBenchCase >> label [

	^ 'Translucent circles'
]

{ #category : #'instance creation' }
PCTranslucentCirclesBenchCase >> newFigureWith: random [
	
	^ BlElement new
		geometry: BlCircleGeometry new;
		size: self radius * 2;
		background: ((Color random: random) alpha: 0.1);
		yourself
]

{ #category : #hook }
PCTranslucentCirclesBenchCase >> newMorph [

	^ PCTranslatingCirclesMorph new
		  surfaceExtent: self surfaceExtent;
		  numberOfCircles: self numberOfFigures;
		  radius: self radius;
		  yourself
]

{ #category : #hook }
PCTranslucentCirclesBenchCase >> radius [

	^ 50.0 asPoint
]
