Class {
	#name : #PCScaledRectanglesBenchCase,
	#superclass : #PCTranslatingFiguresBenchCase,
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #hook }
PCScaledRectanglesBenchCase >> figureExtent [

	^ 100.0 asPoint
]

{ #category : #accessing }
PCScaledRectanglesBenchCase >> label [

	^ 'Scaled rectangles'
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

{ #category : #hook }
PCScaledRectanglesBenchCase >> scale [

	^ 0.5 @ 2
]
