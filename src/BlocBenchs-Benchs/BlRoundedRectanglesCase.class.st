Class {
	#name : #BlRoundedRectanglesCase,
	#superclass : #BlBAbstractTranslatingFiguresCase,
	#category : #'BlocBenchs-Benchs-Bloc'
}

{ #category : #accessing }
BlRoundedRectanglesCase >> figureExtent [

	^ 80.0 asPoint
]

{ #category : #hook }
BlRoundedRectanglesCase >> newFigureWith: random [

	^ BlElement new
		  background: (Color random: random);
		  geometry: (BlRoundedRectangleGeometry cornerRadius: 20);
		  extent: self figureExtent;
		  yourself
]
