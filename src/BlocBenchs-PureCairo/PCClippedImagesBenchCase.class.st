Class {
	#name : #PCClippedImagesBenchCase,
	#superclass : #PCImagesBenchCase,
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #'instance creation' }
PCClippedImagesBenchCase >> newImageElementWith: random [
	
	| randomIcon |
	randomIcon := self newFormWith: random.
	
	^ BlElement new
		geometry: BlRectangleGeometry new;
		size: randomIcon extent // 2;
		background: randomIcon;
		yourself

]
