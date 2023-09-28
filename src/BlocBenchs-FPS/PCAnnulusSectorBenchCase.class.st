Class {
	#name : 'PCAnnulusSectorBenchCase',
	#superclass : 'PCTranslatingFiguresBenchCase',
	#category : 'BlocBenchs-FPS-Cases',
	#package : 'BlocBenchs-FPS',
	#tag : 'Cases'
}

{ #category : 'hook' }
PCAnnulusSectorBenchCase >> newFigureWith: random [

	^ BlElement new
		  background: (Color random: random);
		  geometry: (BlAnnulusSectorGeometry new
				   startAngle: (random nextInteger: 360);
				   endAngle: (random nextInteger: 360);
				   innerRadius: (random nextBetween: 0.0 and: 0.4);
				   outerRadius: (random nextBetween: 0.5 and: 1.0);
				   yourself);
		  size: 100 asPoint;
		  yourself
]
