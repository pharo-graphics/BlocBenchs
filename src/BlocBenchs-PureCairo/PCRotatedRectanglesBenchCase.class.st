Class {
	#name : #PCRotatedRectanglesBenchCase,
	#superclass : #PCTranslatingFiguresBenchCase,
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #hook }
PCRotatedRectanglesBenchCase >> angleInDegreesWith: random [
		
	^ random nextInteger: 360
]

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
