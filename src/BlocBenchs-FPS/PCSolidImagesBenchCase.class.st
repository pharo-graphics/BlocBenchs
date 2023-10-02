Class {
	#name : #PCSolidImagesBenchCase,
	#superclass : #PCImagesBenchCase,
	#category : 'BlocBenchs-FPS-Cases'
}

{ #category : #hook }
PCSolidImagesBenchCase >> newImageElementWith: random [
	
	| randomIcon |
	randomIcon := self newFormWith: random.
	
	^ BlElement new
	  size: randomIcon extent;
	  background: randomIcon;
	  yourself
]

{ #category : #'instance creation' }
PCSolidImagesBenchCase >> newRawSDLCairoWindow [

	^ PCSolidImagesWindow newWith: self
]
