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

{ #category : #private }
BlSpaceFixture >> hexagonVertices [
	
	^ { 
		 60 @  0.
		 20 @  0.
		  0 @ 36.
		 20 @ 70.
		 60 @ 70.
		 80 @ 36 }
]

{ #category : #fixtures }
BlSpaceFixture >> spaceWithBorderedCircles [
	
	^ BlSpaceBuilder newSpaceWith: [ :builder |

		builder addCircle
			border: (BlBorder paint: builder nextColor width: 8);
			outskirts: BlOutskirts outside;
			relocate: 10 asPoint;
			size: 30 asPoint;
			yourself.

		builder addCircle
			border: (BlBorder paint: builder nextColor width: 8);
			outskirts: BlOutskirts centered;
			relocate: 40 asPoint;
			size: 30 asPoint;
			yourself.

		builder addCircle
			border: (BlBorder paint: builder nextColor width: 8);
			outskirts: BlOutskirts inside;
			relocate: 70 asPoint;
			size: 30 asPoint;
			yourself.

		].
]

{ #category : #fixtures }
BlSpaceFixture >> spaceWithBorderedPolygons [
	
	^ BlSpaceBuilder newSpaceWith: [ :builder |

		builder addToRoot
			geometry: (BlPolygonGeometry vertices: self hexagonVertices);
			border: (BlBorder paint: builder nextColor width: 7);
			outskirts: BlOutskirts outside;
			relocate: 0 asPoint;
			transformDo: [ :t | t scaleBy: 0.5 ];
			yourself.

		builder addCircle
			geometry: (BlPolygonGeometry vertices: self hexagonVertices);
			border: (BlBorder paint: builder nextColor width: 7);
			outskirts: BlOutskirts centered;
			relocate: 20 asPoint;
			transformDo: [ :t | t scaleBy: 0.5 ];
			yourself.

		builder addCircle
			geometry: (BlPolygonGeometry vertices: self hexagonVertices);
			border: (BlBorder paint: builder nextColor width: 7);
			outskirts: BlOutskirts inside;
			relocate: 40 asPoint;
			transformDo: [ :t | t scaleBy: 0.5 ];
			yourself.

		].
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
BlSpaceFixture >> spaceWithPolygon [

	^ BlSpaceBuilder newSpaceWith: [ :builder |
		
		builder addToRoot
			geometry: (BlPolygonGeometry vertices: self hexagonVertices);
			relocate: 10 asPoint;
			yourself.

		]
]

{ #category : #fixtures }
BlSpaceFixture >> spaceWithPolyline [

	^ BlSpaceBuilder newSpaceWith: [ :builder |
		
		builder addToRoot
			geometry: (BlPolylineGeometry vertices: self hexagonVertices);
			relocate: 10 asPoint;
			yourself.

		]
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
