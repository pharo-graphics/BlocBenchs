Class {
	#name : #BlBTranslucentImagesCase,
	#superclass : #BlBAbstractImagesCase,
	#category : #'BlocBenchs-Benchs-Bloc'
}

{ #category : #'instance creation' }
BlBTranslucentImagesCase >> newImageElementWith: random [
	
	| randomIcon |
	randomIcon := self newFormWith: random.
	
	^ BlElement new
	  extent: randomIcon extent;
	  background: (randomIcon asBlBackground opacity: 0.5; yourself);
	  yourself
]
