Class {
	#name : #PCScaledRectanglesBenchCase,
	#superclass : #PCTranslatingFiguresBenchCase,
	#category : #'BlocBenchs-FPS'
}

{ #category : #accessing }
PCScaledRectanglesBenchCase >> figureExtent [

	^ 100.0 asPoint
]

{ #category : #hook }
PCScaledRectanglesBenchCase >> newFigureWith: random [

	^ BlElement new
		  geometry: BlRectangleGeometry new;
		  size: self figureExtent;
		  transformDo: [ :aBuilder | aBuilder scaleBy: self scale ];
		  background: (Color random: random);
		  yourself
]

{ #category : #accessing }
PCScaledRectanglesBenchCase >> scale [

	^ 0.75 @ 1.5
]
