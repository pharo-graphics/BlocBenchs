Class {
	#name : #PCMouseEventTargetTest,
	#superclass : #TestCase,
	#instVars : [
		'space'
	],
	#category : #'BlocBenchs-PCRenderer-Tests'
}

{ #category : #tests }
PCMouseEventTargetTest >> assertMouseEventTargetAt: aPoint equals: anElement [

	self
		assert: (space root findMouseEventTargetAt: aPoint)
		equals: anElement
]

{ #category : #tests }
PCMouseEventTargetTest >> assertNoMouseEventTargetAt: aPoint [
	"Assert that the target at aPoint is the root, which means there are no elements there."

	self assertMouseEventTargetAt: aPoint equals: space root
]

{ #category : #running }
PCMouseEventTargetTest >> setUp [
	super setUp.
	
"
	Bloc hasSparta: false.
	"
]

{ #category : #tests }
PCMouseEventTargetTest >> testCircles [

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
		assertNoMouseEventTargetAt: 10 asPoint.

	self
		assertMouseEventTargetAt: 15 asPoint
		equals: elementA.

	self
		assertMouseEventTargetAt: 20 asPoint
		equals: elementB.

]

{ #category : #tests }
PCMouseEventTargetTest >> testNesting [

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

	"elementB DOES clip, then elementC is not found"
	self
		assertNoMouseEventTargetAt: 25 asPoint. 

]

{ #category : #tests }
PCMouseEventTargetTest >> testRectangles [

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
	
	"No element theer, only background."
	self
		assertNoMouseEventTargetAt: 9 asPoint. 

	self
		assertMouseEventTargetAt: 10 asPoint
		equals: elementA.

	self
		assertMouseEventTargetAt: 15 asPoint
		equals: elementB.

]

{ #category : #tests }
PCMouseEventTargetTest >> testTransformRotate [

	| elementA elementB elementC |
	space := BlSpaceBuilder newSpaceWith: [ :builder |
	
		elementA := builder addToRoot
			geometry: BlTriangleGeometry new;
			relocate: 0 asPoint;
			size: 25 asPoint;
			transformDo: [ :t | t rotateBy: -135 ];
			yourself.

		elementB := builder addToRoot
			geometry: BlRectangleGeometry new;
			relocate: 20 asPoint;
			size: 20 asPoint;
			transformDo: [ :t | t rotateBy: 45 ];
			yourself.
			
		elementC := (builder addTo: elementB)
			geometry: BlRectangleGeometry new;
			transformDo: [ :t | t rotateBy: 180 ];
			relocate: 5 asPoint;
			size: 10 asPoint;
			yourself ].
	 
	{	 0 -> space root. 	
		 5 -> elementA.
		10 -> elementA.
		15 -> elementA.
		20 -> elementA.
		25 -> elementB.
		30 -> elementC.
		35 -> elementB.
		40 -> space root } do: [ :each |
			self
				assertMouseEventTargetAt: each key asPoint
				equals: each value ]

]

{ #category : #tests }
PCMouseEventTargetTest >> testTransformScale [

	| elementA elementB elementC |
	space := BlSpaceBuilder newSpaceWith: [ :builder |

		"Center is at 10@10"
		elementA := builder addToRoot
			geometry: BlCircleGeometry new;
			relocate: 0 asPoint;
			size: 20 asPoint;
			transformDo: [ :t | t scaleBy: 1/2 ];
			yourself.

		"Center is 25@25 (10/2 + 20)"
		elementB := builder addToRoot
			geometry: BlCircleGeometry new;
			relocate: 20 asPoint;
			size: 10 asPoint;
			transformDo: [ :t | t scaleBy: 2 ];
			yourself.

		"C is in the center of it's parent, as they have the same size."
		elementC := (builder addTo: elementB)
			geometry: BlCircleGeometry new;
			relocate: 0 asPoint;
			size: 10 asPoint;
			transformDo: [ :t | t scaleBy: 0.5 ];
			yourself ].

	{ 	 5 -> space root.
		10 -> elementA.
		15 -> space root.
		20 -> elementB.
		25 -> elementC.
		30 -> elementB.
		35 -> space root } do: [ :each |
			self
				assertMouseEventTargetAt: each key asPoint
				equals: each value ]

]

{ #category : #tests }
PCMouseEventTargetTest >> testTransformTranslate [

	| elementA elementB elementC |
	space := BlSpaceBuilder newSpaceWith: [ :builder |
	
		elementA := builder addToRoot
			geometry: BlRectangleGeometry new;
			transformDo: [ :t | t translateBy: 10 ];
			size: 10 asPoint;
			yourself.

		elementB := builder addToRoot
			geometry: BlRectangleGeometry new;
			transformDo: [ :t | t translateBy: 15 ];
			size: 10 asPoint;
			yourself.
			
		elementC := (builder addTo: elementB)
			geometry: BlRectangleGeometry new;
			transformDo: [ :t | t translateBy: 5 ];
			size: 5 asPoint;
			yourself ].
	
	self
		assertMouseEventTargetAt: 10 asPoint
		equals: elementA.

	self
		assertMouseEventTargetAt: 15 asPoint
		equals: elementB.

	self
		assertMouseEventTargetAt: 20 asPoint
		equals: elementC.

	self
		assertNoMouseEventTargetAt: 25 asPoint. 

]

{ #category : #tests }
PCMouseEventTargetTest >> testTriangles [

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
		assertNoMouseEventTargetAt: 11@10.

	self
		assertMouseEventTargetAt: 15 asPoint
		equals: elementB.

]
