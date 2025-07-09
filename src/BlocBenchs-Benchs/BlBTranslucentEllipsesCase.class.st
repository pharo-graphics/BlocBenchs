Class {
	#name : #BlBTranslucentEllipsesCase,
	#superclass : #BlBAbstractTranslatingFiguresCase,
	#category : #'BlocBenchs-Benchs-Bloc'
}

{ #category : #accessing }
BlBTranslucentEllipsesCase >> figureExtent: aRandom [

	^ Point
		x: (aRandom nextBetween: 20 and: 80)
		y: (aRandom nextBetween: 20 and: 80)
]

{ #category : #hook }
BlBTranslucentEllipsesCase >> newFigureWith: random [

	^ BlElement new
		  border: (BlBorder
				paint: ((Color random: random) alpha: 0.8)
				width: 10);
		  geometry: BlEllipseGeometry new;
		  extent: (self figureExtent: random);
		  yourself
]
