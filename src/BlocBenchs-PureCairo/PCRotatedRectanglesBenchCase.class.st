Class {
	#name : #PCRotatedRectanglesBenchCase,
	#superclass : #PCTranslatingFiguresBenchCase,
	#category : #'BlocBenchs-PureCairo'
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
		  transformDo: [ :aBuilder | aBuilder rotateBy: self rotation ];
		  yourself
]

{ #category : #accessing }
PCRotatedRectanglesBenchCase >> rotation [

	^ 10
]
