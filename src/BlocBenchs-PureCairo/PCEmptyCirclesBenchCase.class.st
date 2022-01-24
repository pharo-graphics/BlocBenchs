Class {
	#name : #PCEmptyCirclesBenchCase,
	#superclass : #PCTranslatingFiguresBenchCase,
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #hook }
PCEmptyCirclesBenchCase >> borderWidth [

	^ 5
]

{ #category : #hook }
PCEmptyCirclesBenchCase >> newFigureWith: random [

	^ BlElement new
		  geometry: BlCircleGeometry new;
		  size: self radius * 2;
		  border: (BlBorder 
				paint: (Color random: random)
				width: self borderWidth);
		  yourself
]

{ #category : #hook }
PCEmptyCirclesBenchCase >> radius [

	^ 50.0 asPoint
]
