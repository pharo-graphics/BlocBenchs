Class {
	#name : 'PCRoassalCirclesMorph',
	#superclass : 'PCRoassalTranslatingFiguresMorph',
	#category : 'BlocBenchs-FPS-RawMorph-Old',
	#package : 'BlocBenchs-FPS',
	#tag : 'RawMorph-Old'
}

{ #category : 'instance creation' }
PCRoassalCirclesMorph >> newShape: index [

	^ RSCircle new
		position: case radius asPoint + case figureOffset + (index * case offsetBetweenFigures);
		radius: case radius;
		in: [ :me | self prepareCircle: me ];
		yourself

]

{ #category : 'instance creation' }
PCRoassalCirclesMorph >> prepareCircle: aCircleShape [

	self subclassResponsibility 
]
