Class {
	#name : 'PCClippedImagesBenchCase',
	#superclass : 'PCImagesBenchCase',
	#category : 'BlocBenchs-FPS-Cases',
	#package : 'BlocBenchs-FPS',
	#tag : 'Cases'
}

{ #category : 'instance creation' }
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
