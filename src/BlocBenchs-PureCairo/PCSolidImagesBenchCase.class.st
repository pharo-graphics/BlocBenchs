Class {
	#name : #PCSolidImagesBenchCase,
	#superclass : #PCImagesBenchCase,
	#category : #'BlocBenchs-PureCairo'
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
PCSolidImagesBenchCase >> newMorph [

	^ PCSolidImagesMorph new
		  case: self;
		  yourself
]
