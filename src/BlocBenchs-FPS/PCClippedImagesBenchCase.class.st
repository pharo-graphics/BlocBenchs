Class {
	#name : #PCClippedImagesBenchCase,
	#superclass : #PCImagesBenchCase,
	#category : 'BlocBenchs-FPS-Cases'
}

{ #category : #'instance creation' }
PCClippedImagesBenchCase >> newImageElementWith: random [
	
	| randomIcon |
	randomIcon := self newFormWith: random.
	
	^ BlElement new
		clipChildren: true;
		geometry: BlRectangleGeometry new;
		size: randomIcon extent // 2;
		background: randomIcon;
		yourself

]
