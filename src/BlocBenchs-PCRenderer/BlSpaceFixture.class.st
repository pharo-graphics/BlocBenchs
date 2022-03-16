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
BlSpaceFixture >> diagonalPositionGeneratorStartingAt: aPoint by: by [
	
	^ Generator on: [ :g | 
		| index |
		index := 0.
		[ 	g yield: aPoint + index asPoint.
			index := index + by ] repeat ]
]

{ #category : #private }
BlSpaceFixture >> gridPositionGeneratorStartingAt: offset by: by columns: numberOfColumns [
	
	^ Generator on: [ :g | 
		| column next |
		column := 0.
		next := offset.
		
		[	[	"Put next position"
				g yield: next.

				"Advance to next column in same row"
				next := next + (by @ 0).
				column := column + 1.

			] doWhileTrue: [ column < numberOfColumns ].

			"Start a new row"
			next := offset x @ (next y + by).
			column := 0 

		] repeat ]
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
BlSpaceFixture >> spaceWithNestingOutskirtsAndOpacity [
	
	^ BlSpaceBuilder newSpaceWith: [ :builder |

		| outskirts width positionGenerator addElementBlock |
		outskirts := { BlOutskirts inside. BlOutskirts centered. BlOutskirts outside }.
		width := 5.
		positionGenerator := self 
			gridPositionGeneratorStartingAt: 8 asPoint
			by: 25
			columns: 3.
		addElementBlock := [ :anOutskirt :borderColor |
			| element |
			element := builder addCircle
				border: (BlBorder paint: borderColor width: width);
				outskirts: anOutskirt;
				relocate: positionGenerator next;
				size: 35 asPoint;
				yourself.
			(builder addTo: element)
				relocate: 15 asPoint
		].

		"Opaques"
		outskirts do: [ :eachOutskirt |
			addElementBlock
				value: eachOutskirt
				value: builder nextColor ].

		"Translucents"
		outskirts do: [ :eachOutskirt |
			addElementBlock
				value: eachOutskirt
				value: builder nextColor translucent ].

		"Transparents"
		outskirts do: [ :eachOutskirt |
			addElementBlock
				value: eachOutskirt
				value: Color transparent ].

		].
]

{ #category : #fixtures }
BlSpaceFixture >> spaceWithOutskirtsOfCircles [
	
	^ BlSpaceBuilder newSpaceWith: [ :builder |

		| outskirts width positionGenerator |
		outskirts := { BlOutskirts inside. BlOutskirts centered. BlOutskirts outside }.
		width := 5.
		positionGenerator := self 
			gridPositionGeneratorStartingAt: 8 asPoint
			by: 25
			columns: 3.

		"Opaques"
		outskirts do: [ :eachOutskirt |
				builder addCircle
					border: (BlBorder paint: builder nextColor width: width);
					outskirts: eachOutskirt;
					relocate: positionGenerator next;
					size: 35 asPoint;
					yourself ].

		"Translucents"
		outskirts do: [ :eachOutskirt |
				builder addCircle
					border: (BlBorder paint: builder nextColor width: width);
					background: builder nextColor translucent;
					outskirts: eachOutskirt;
					relocate: positionGenerator next;
					size: 35 asPoint;
					yourself ].

		"Transparents"
		outskirts do: [ :eachOutskirt |
				builder addCircle
					border: (BlBorder paint: builder nextColor width: width);
					background: Color transparent;
					outskirts: eachOutskirt;
					relocate: positionGenerator next;
					size: 35 asPoint;
					yourself ].

		].
]

{ #category : #fixtures }
BlSpaceFixture >> spaceWithOutskirtsOfPolygons [
	
	^ BlSpaceBuilder newSpaceWith: [ :builder |

		| outskirts width scale positionGenerator |
		outskirts := { BlOutskirts inside. BlOutskirts centered. BlOutskirts outside }.
		width := 7.
		scale := 0.5.
		positionGenerator := self 
			gridPositionGeneratorStartingAt: 0 asPoint
			by: 20
			columns: 3.

		"Opaques"
		outskirts do: [ :eachOutskirt |
				builder addHexagonalPolygon
					relocate: positionGenerator next;
					border: (BlBorder paint: builder nextColor width: width);
					outskirts: eachOutskirt;
					transformDo: [ :t | t scaleBy: scale ];
					yourself ].

		"Translucents"
		outskirts do: [ :eachOutskirt |
				builder addHexagonalPolygon
					relocate: positionGenerator next;
					background: builder nextColor translucent;
					border: (BlBorder paint: builder nextColor width: width);
					outskirts: eachOutskirt;
					transformDo: [ :t | t scaleBy: scale ];
					yourself ].

		"Transparents"
		outskirts do: [ :eachOutskirt |
				builder addHexagonalPolygon
					relocate: positionGenerator next;
					background: Color transparent;
					border: (BlBorder paint: builder nextColor width: width);
					outskirts: eachOutskirt;
					transformDo: [ :t | t scaleBy: scale ];
					yourself ].

		].
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
BlSpaceFixture >> spaceWithStrokeStyles [
	
	^ BlSpaceBuilder newSpaceWith: [ :builder |

			| positionGenerator width |
			width := 9.
			positionGenerator := self diagonalPositionGeneratorStartingAt: 7 by: 14.

			builder addPolyline
				relocate: positionGenerator next;
				border: (BlBorder builder
					width: width;
					capButt;
					joinRound;
					paint: builder nextColor;
					build);
				yourself.

			builder addPolyline
				relocate: positionGenerator next;
				border: (BlBorder builder
					width: width;
					capSquare;
					joinBevel;
					paint: builder nextColor;
					build);
				yourself.

			builder addPolyline
				relocate: positionGenerator next;
				border: (BlBorder builder
					width: width;
					capRound;
					joinMiter;
					miterLimit: 10;
					paint: builder nextColor;
					build);
				yourself.

			builder addPolyline
				relocate: positionGenerator next;
				border: (BlBorder builder
					dashArray: #(0 5);
					capRound;
					joinRound;
					paint: builder nextColor;
					width: 4;
					build);
				yourself.

			builder addPolyline
				relocate: positionGenerator next;
				border: (BlBorder builder
					dashArray: #(3 5);
					dashOffset: 5;
					paint: builder nextColor;
					capSquare;
					joinBevel;
					width: 3;
					build);
				yourself.

			builder addPolyline
				relocate: positionGenerator next;
				border: (BlBorder builder
					paint: builder nextColor;
					capSquare;
					joinMiter;
					miterLimit: 1; "This will make it render as bevel join"
					width: 12;
					build);
				transformDo: [ :t |
					t translateBy: -10 asPoint.
					t scaleBy: 0.8. ];
				yourself.

		].
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
