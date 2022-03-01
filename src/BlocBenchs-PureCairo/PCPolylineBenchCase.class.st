Class {
	#name : #PCPolylineBenchCase,
	#superclass : #PCTranslatingFiguresBenchCase,
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #hook }
PCPolylineBenchCase >> newFigureWith: random [

	^ BlElement new
		  border: (BlBorder paint: (Color random: random) width: 1);
		  background: Color transparent;
		  in: [ :me | self preparePolyline: me ];
		  yourself
]

{ #category : #hook }
PCPolylineBenchCase >> preparePolyline: anElement [

	self subclassResponsibility
]
