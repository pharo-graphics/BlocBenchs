Class {
	#name : #PCFindMouseMoveTargetAtTest,
	#superclass : #TestCase,
	#instVars : [
		'space'
	],
	#category : #'BlocBenchs-PCRenderer-Tests'
}

{ #category : #tests }
PCFindMouseMoveTargetAtTest >> assertMouseEventTargetAt: aPoint equals: anElement [

	self
		assert: (space root findMouseEventTargetAt: aPoint)
		equals: anElement
]

{ #category : #running }
PCFindMouseMoveTargetAtTest >> setUp [
	super setUp.
	
	Bloc hasSparta: false.
]

{ #category : #tests }
PCFindMouseMoveTargetAtTest >> test01OverlappingRectangles [

	| elementA elementB |
	space := BlSpaceBuilder newSpaceWith: [ :builder |
	
		elementA := builder addToRoot
			geometry: BlRectangleGeometry new;
			relocate: 10 asPoint;
			size: 10 asPoint;
			yourself.

		elementB := builder addToRoot
			geometry: BlRectangleGeometry new;
			relocate: 15 asPoint;
			size: 10 asPoint;
			yourself.
		].
	
	self
		assertMouseEventTargetAt: 9 asPoint
		equals: space root. "No element; only background"

	self
		assertMouseEventTargetAt: 10 asPoint
		equals: elementA.

	self
		assertMouseEventTargetAt: 15 asPoint
		equals: elementB.

]

{ #category : #tests }
PCFindMouseMoveTargetAtTest >> test02NestedRectangles [

	| elementA elementB elementC |
	space := BlSpaceBuilder newSpaceWith: [ :builder |
	
		elementA := builder addToRoot
			geometry: BlRectangleGeometry new;
			relocate: 10 asPoint;
			size: 10 asPoint;
			clipChildren: false;
			yourself.

		elementB := (builder addTo: elementA)
			geometry: BlRectangleGeometry new;
			relocate: 5 asPoint;
			size: 10 asPoint;
			clipChildren: true;
			yourself.
			
		elementC := (builder addTo: elementB)
			geometry: BlRectangleGeometry new;
			relocate: 5 asPoint;
			size: 10 asPoint;
			yourself.
		].
	
	self
		assertMouseEventTargetAt: 10 asPoint
		equals: elementA.

	self
		assertMouseEventTargetAt: 15 asPoint
		equals: elementB.

	self
		assertMouseEventTargetAt: 20 asPoint
		equals: elementC. "elementA doesn't clip"

	self
		assertMouseEventTargetAt: 25 asPoint
		equals: space root. "elementB DOES clip"
		

]

{ #category : #tests }
PCFindMouseMoveTargetAtTest >> test03Triangles [

	| elementA elementB |
	space := BlSpaceBuilder newSpaceWith: [ :builder |
	
		elementA := builder addTriangle
			relocate: 10 asPoint;
			size: 10 asPoint;
			yourself.

		elementB := builder addTriangle
			relocate: 15 asPoint;
			size: 10 asPoint;
			yourself.
		].	

	self
		assertMouseEventTargetAt: 10 asPoint
		equals: elementA.

	self
		assertMouseEventTargetAt: 11 @ 10
		equals: space root.

	self
		assertMouseEventTargetAt: 15 asPoint
		equals: elementB.

]

{ #category : #tests }
PCFindMouseMoveTargetAtTest >> test04Circles [

	| elementA elementB |
	space := BlSpaceBuilder newSpaceWith: [ :builder |
	
		elementA := builder addCircle
			relocate: 10 asPoint;
			size: 10 asPoint;
			yourself.

		elementB := builder addCircle
			relocate: 15 asPoint;
			size: 10 asPoint;
			yourself.
		].	

	self
		assertMouseEventTargetAt: 10 asPoint
		equals: space root.

	self
		assertMouseEventTargetAt: 15 asPoint
		equals: elementA.

	self
		assertMouseEventTargetAt: 20 asPoint
		equals: elementB.

]
