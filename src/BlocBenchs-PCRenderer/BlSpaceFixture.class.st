Class {
	#name : #BlSpaceFixture,
	#superclass : #Object,
	#category : #'BlocBenchs-PCRenderer-Tests'
}

{ #category : #accessing }
BlSpaceFixture >> allFixtureSelectors [

	^ self class allSelectors select: [ :each | each beginsWith: #space ]
]

{ #category : #accessing }
BlSpaceFixture >> allFixtureSpaces [

	^ self allFixtureSelectors collect: [ :each | self perform: each ]
]

{ #category : #fixtures }
BlSpaceFixture >> spaceWithCircles [
	
	^ BlSpaceBuilder newSpaceWith: [ :builder |
		| elementA elementB |
	
		elementA := builder addCircle
			relocate: 10 asPoint;
			size: 10 asPoint;
			yourself.

		elementB := builder addCircle
			relocate: 15 asPoint;
			size: 10 asPoint;
			yourself.
		].
]

{ #category : #fixtures }
BlSpaceFixture >> spaceWithNesting [

	^ BlSpaceBuilder newSpaceWith: [ :builder |
		| elementA elementB elementC |
	
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
			yourself ]

]

{ #category : #fixtures }
BlSpaceFixture >> spaceWithRectangles [

	^ BlSpaceBuilder newSpaceWith: [ :builder |
		| elementA elementB |
	
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
		]
]

{ #category : #fixtures }
BlSpaceFixture >> spaceWithTransformRotate [

	^ BlSpaceBuilder newSpaceWith: [ :builder |
		| elementA elementB elementC |
	
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
			yourself ]
]

{ #category : #fixtures }
BlSpaceFixture >> spaceWithTransformScale [

	^ BlSpaceBuilder newSpaceWith: [ :builder |
		| elementA elementB elementC |

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
			yourself ]
]

{ #category : #fixtures }
BlSpaceFixture >> spaceWithTransformTranslate [

	^ BlSpaceBuilder newSpaceWith: [ :builder |
		| elementA elementB elementC |
	
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
			yourself ]
]

{ #category : #fixtures }
BlSpaceFixture >> spaceWithTriangles [

	^ BlSpaceBuilder newSpaceWith: [ :builder |
		| elementA elementB |
	
		elementA := builder addTriangle
			relocate: 10 asPoint;
			size: 10 asPoint;
			yourself.

		elementB := builder addTriangle
			relocate: 15 asPoint;
			size: 10 asPoint;
			yourself ]
]
