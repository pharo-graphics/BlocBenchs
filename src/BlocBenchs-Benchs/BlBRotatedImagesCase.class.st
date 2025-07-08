Class {
	#name : #BlBRotatedImagesCase,
	#superclass : #BlBAbstractImagesCase,
	#category : #'BlocBenchs-Benchs-Bloc'
}

{ #category : #'instance creation' }
BlBRotatedImagesCase >> newImageElementWith: random [
	
	| randomIcon |
	randomIcon := self newFormWith: random.
	
	^ BlElement new
		transformDo: [ :t | t rotateBy: (self angleInDegreesWith: random) ];
		extent: randomIcon extent;
		background: randomIcon;
		yourself
]
