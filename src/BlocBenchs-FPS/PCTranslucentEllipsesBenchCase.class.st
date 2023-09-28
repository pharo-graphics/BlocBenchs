Class {
	#name : 'PCTranslucentEllipsesBenchCase',
	#superclass : 'PCTranslatingFiguresBenchCase',
	#category : 'BlocBenchs-FPS-Cases',
	#package : 'BlocBenchs-FPS',
	#tag : 'Cases'
}

{ #category : 'accessing' }
PCTranslucentEllipsesBenchCase >> figureExtent: aRandom [

	^ Point
		x: (aRandom nextBetween: 20 and: 80)
		y: (aRandom nextBetween: 20 and: 80)
]

{ #category : 'hook' }
PCTranslucentEllipsesBenchCase >> newFigureWith: random [

	^ BlElement new
		  border: (BlBorder
				paint: ((Color random: random) alpha: 0.8)
				width: 10);
		  geometry: BlEllipseGeometry new;
		  size: (self figureExtent: random);
		  yourself
]
