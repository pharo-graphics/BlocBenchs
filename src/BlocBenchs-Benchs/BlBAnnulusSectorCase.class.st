Class {
	#name : #BlBAnnulusSectorCase,
	#superclass : #BlBAbstractTranslatingFiguresCase,
	#category : #'BlocBenchs-Benchs-Bloc'
}

{ #category : #'instance creation' }
BlBAnnulusSectorCase >> newFigureWith: random [

	^ BlElement new
		  background: (Color random: random);
		  geometry: (BlAnnulusSectorGeometry new
				   startAngle: (random nextInteger: 360);
				   endAngle: (random nextInteger: 360);
				   innerRadius: (random nextBetween: 0.0 and: 0.4);
				   outerRadius: (random nextBetween: 0.5 and: 1.0);
				   yourself);
		  extent: 100 asPoint;
		  yourself
]
