Class {
	#name : #PCRoundedRectanglesBenchCase,
	#superclass : #PCTranslatingFiguresBenchCase,
	#category : 'BlocBenchs-FPS-Cases'
}

{ #category : #accessing }
PCRoundedRectanglesBenchCase >> figureExtent [

	^ 80.0 asPoint
]

{ #category : #hook }
PCRoundedRectanglesBenchCase >> newFigureWith: random [

	^ BlElement new
		  background: (Color random: random);
		  geometry: (BlRoundedRectangleGeometry cornerRadius: 20);
		  size: self figureExtent;
		  yourself
]
