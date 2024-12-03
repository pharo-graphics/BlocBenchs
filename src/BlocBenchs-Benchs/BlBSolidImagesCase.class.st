Class {
	#name : #BlBSolidImagesCase,
	#superclass : #BlBAbstractImagesCase,
	#category : #'BlocBenchs-Benchs-Bloc'
}

{ #category : #hook }
BlBSolidImagesCase >> newImageElementWith: random [
	
	| randomIcon |
	randomIcon := self newFormWith: random.
	
	^ BlElement new
	  size: randomIcon extent;
	  background: randomIcon;
	  yourself
]
