Class {
	#name : #PCRotatedRectanglesBenchCase,
	#superclass : #PCTranslatingFiguresBenchCase,
	#category : #'BlocBenchs-FPS'
}

{ #category : #accessing }
PCRotatedRectanglesBenchCase >> figureExtent [

	^ 100.0 asPoint
]

{ #category : #hook }
PCRotatedRectanglesBenchCase >> newFigureWith: random [

	^ BlElement new
		  background: (Color random: random);
		  geometry: BlRectangleGeometry new;
		  size: self figureExtent;
		  transformDo: [ :t | t rotateBy: (self angleInDegreesWith: random) ];
		  yourself
]
