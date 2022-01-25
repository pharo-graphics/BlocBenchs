Class {
	#name : #PCEmptyCirclesBenchCase,
	#superclass : #PCTranslatingFiguresBenchCase,
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #accessing }
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

{ #category : #accessing }
PCEmptyCirclesBenchCase >> radius [

	^ 50.0 asPoint
]
