Class {
	#name : #PCRotatedImagesBenchCase,
	#superclass : #PCImagesBenchCase,
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #'instance creation' }
PCRotatedImagesBenchCase >> newImageElementWith: random [
	
	| randomIcon |
	randomIcon := self newFormWith: random.
	
	^ BlElement new
		transformDo: [ :t | t rotateBy: (self angleInDegreesWith: random) ];
		size: randomIcon extent;
		background: randomIcon;
		yourself
]
