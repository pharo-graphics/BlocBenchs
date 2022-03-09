Class {
	#name : #PCSolidBorderCirclesBenchCase,
	#superclass : #PCCirclesBenchCase,
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #accessing }
PCSolidBorderCirclesBenchCase >> borderWidth [

	^ 5
]

{ #category : #'instance creation' }
PCSolidBorderCirclesBenchCase >> newMorph [

	^ PCSolidBorderCirclesMorph new
		  case: self;
		  yourself
]

{ #category : #hook }
PCSolidBorderCirclesBenchCase >> prepare: anElement with: random [

	anElement border:
		(BlBorder paint: (Color random: random) width: self borderWidth)
]
