Class {
	#name : #PCSolidCirclesBenchCase,
	#superclass : #PCCirclesBenchCase,
	#category : #'BlocBenchs-FPS-Cases'
}

{ #category : #hook }
PCSolidCirclesBenchCase >> newMorph [

	^ PCSolidCirclesMorph new
		  case: self;
		  yourself
]

{ #category : #'instance creation' }
PCSolidCirclesBenchCase >> newRoassalWrapperMorph [
	
	^ PCRoassalSolidCirclesMorph new
		  case: self;
		  yourself
]

{ #category : #hook }
PCSolidCirclesBenchCase >> prepare: anElement with: random [

	anElement background: (Color random: random)
]
