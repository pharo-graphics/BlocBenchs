Class {
	#name : #BlBClippedImagesCase,
	#superclass : #BlBAbstractImagesCase,
	#category : #'BlocBenchs-Benchs-Bloc'
}

{ #category : #'instance creation' }
BlBClippedImagesCase >> newImageElementWith: random [
	
	| randomIcon |
	randomIcon := self newFormWith: random.
	
	^ BlElement new
		clipChildren: true;
		geometry: BlRectangleGeometry new;
		size: randomIcon extent // 2;
		background: randomIcon;
		yourself

]
