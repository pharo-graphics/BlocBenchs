Class {
	#name : #PCSolidBorderCirclesBenchCase,
	#superclass : #PCCirclesBenchCase,
	#category : #'BlocBenchs-FPS-Cases'
}

{ #category : #accessing }
PCSolidBorderCirclesBenchCase >> borderWidth [

	^ 5
]

{ #category : #'instance creation' }
PCSolidBorderCirclesBenchCase >> newRawSDLCairoWindow [

	^ PCSolidBorderCirclesWindow newWith: self
]

{ #category : #'instance creation' }
PCSolidBorderCirclesBenchCase >> newRoassalWrapperMorph [

	^ PCRoassalSolidBorderCirclesMorph new
		  case: self;
		  yourself
]

{ #category : #hook }
PCSolidBorderCirclesBenchCase >> prepare: anElement with: random [

	anElement border:
		(BlBorder paint: (Color random: random) width: self borderWidth)
]
