Class {
	#name : #PCRoassalCirclesMorph,
	#superclass : #PCRoassalTranslatingFiguresMorph,
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #'instance creation' }
PCRoassalCirclesMorph >> newShape: index [

	^ RSCircle new
		position: case figureOffset + ((index * case horizontalSeparation) @ 0);
		radius: case radius;
		in:[ :me | self prepareCircle: me ];
		yourself

]

{ #category : #'instance creation' }
PCRoassalCirclesMorph >> prepareCircle: aCircleShape [

	self subclassResponsibility 
]
