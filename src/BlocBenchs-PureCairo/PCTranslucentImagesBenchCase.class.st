Class {
	#name : #PCTranslucentImagesBenchCase,
	#superclass : #PCImagesBenchCase,
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #'instance creation' }
PCTranslucentImagesBenchCase >> newImageElementWith: random [
	
	| randomIcon |
	randomIcon := self newFormWith: random.
	
	^ BlElement new
	  size: randomIcon extent;
	  background: (randomIcon asBlBackground opacity: 0.5; yourself);
	  yourself
]
