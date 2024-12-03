Class {
	#name : #BlBScaledRectanglesCase,
	#superclass : #BlBAbstractTranslatingFiguresCase,
	#category : #'BlocBenchs-Benchs-Bloc'
}

{ #category : #accessing }
BlBScaledRectanglesCase >> figureExtent [

	^ 100.0 asPoint
]

{ #category : #hook }
BlBScaledRectanglesCase >> newFigureWith: random [

	^ BlElement new
		  geometry: BlRectangleGeometry new;
		  size: self figureExtent;
		  transformDo: [ :aBuilder | aBuilder scaleBy: self scale ];
		  background: (Color random: random);
		  yourself
]

{ #category : #accessing }
BlBScaledRectanglesCase >> scale [

	^ 0.75 @ 1.5
]
