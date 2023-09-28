Class {
	#name : 'PCSolidCirclesBenchCase',
	#superclass : 'PCCirclesBenchCase',
	#category : 'BlocBenchs-FPS-Cases',
	#package : 'BlocBenchs-FPS',
	#tag : 'Cases'
}

{ #category : 'hook' }
PCSolidCirclesBenchCase >> newRawSDLCairoWindow [

	^ PCSolidCirclesWindow newWith: self
]

{ #category : 'instance creation' }
PCSolidCirclesBenchCase >> newRoassalWrapperMorph [
	
	^ PCRoassalSolidCirclesMorph new
		  case: self;
		  yourself
]

{ #category : 'hook' }
PCSolidCirclesBenchCase >> prepare: anElement with: random [

	anElement background: (Color random: random)
]
