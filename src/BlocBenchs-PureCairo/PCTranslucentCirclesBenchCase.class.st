Class {
	#name : #PCTranslucentCirclesBenchCase,
	#superclass : #PCTranslatingFiguresBenchCase,
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #hook }
PCTranslucentCirclesBenchCase >> newFigureWith: random [
	
	^ BlElement new
		geometry: BlCircleGeometry new;
		size: self radius * 2;
		background: ((Color random: random) alpha: 0.1);
		yourself
]

{ #category : #accessing }
PCTranslucentCirclesBenchCase >> radius [

	^ 50.0 asPoint
]
