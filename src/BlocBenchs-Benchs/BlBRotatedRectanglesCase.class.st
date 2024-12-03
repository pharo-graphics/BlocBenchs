Class {
	#name : #BlBRotatedRectanglesCase,
	#superclass : #BlBAbstractTranslatingFiguresCase,
	#category : #'BlocBenchs-Benchs-Bloc'
}

{ #category : #accessing }
BlBRotatedRectanglesCase >> figureExtent [

	^ 100.0 asPoint
]

{ #category : #hook }
BlBRotatedRectanglesCase >> newFigureWith: random [

	^ BlElement new
		  background: (Color random: random);
		  geometry: BlRectangleGeometry new;
		  size: self figureExtent;
		  transformDo: [ :t | t rotateBy: (self angleInDegreesWith: random) ];
		  yourself
]
