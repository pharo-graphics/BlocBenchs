"
Compare several implementations to paint a blurred convex polygon.
"
Class {
	#name : #AeBenchBlurConvexPolygonRunner,
	#superclass : #Object,
	#traits : 'AeTBenchBlurRunner',
	#classTraits : 'AeTBenchBlurRunner classTrait',
	#instVars : [
		'mainSurface',
		'mainContext',
		'polygonVertices',
		'blurSigma',
		'ramp',
		'blurMargin',
		'showDebugMarks'
	],
	#category : #'BlocBenchs-Alexandrie-Blur'
}

{ #category : #'as yet unclassified' }
AeBenchBlurConvexPolygonRunner class >> exampleInteractive [

	| cornerExtent blurSigma a vertices shadowElement polygonElement refreshShadowDeferrer draggableVertexElements space |
	cornerExtent := 20 asPoint.
	blurSigma := 12.

	a := 300.
	vertices := {
		0 @ 0.
		a @ 0.
		a @ a.
		0 @ a }.
			
	shadowElement := BlElement new
		position: 100 asPoint;
		clipChildren: false;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent ];
		yourself.
	polygonElement :=
		BlElement new
			position: (blurSigma * 2) asPoint;
			clipChildren: false;
			geometry: (BlRoundedPolygonGeometry vertices: vertices radius: blurSigma/2);
			yourself.

	refreshShadowDeferrer :=
		MinMaxDeferrer
			value: [
				polygonElement enqueueTask: (BlTaskAction new action: [
					| runner |
					runner :=
						(AeBenchBlurConvexPolygonRunner
							newForVertices: vertices
							blurSigma: blurSigma)
							"showDebugMarks: false;"
							yourself.
					shadowElement background: runner "runDirectNaive" runGaussian asForm ]) ]
			notBefore: 150 milliSeconds
			notAfter:  500 milliSeconds.
	refreshShadowDeferrer schedule.

	draggableVertexElements :=
		vertices withIndexCollect: [ :eachPoint :index |
			BlElement new
				extent: cornerExtent;
				position: eachPoint - (cornerExtent / 2);
				geometry: BlCircleGeometry new;
				addEventHandler: BlPullHandler new;
				addEventHandlerOn: BlPullEvent do: [ :evt |
					vertices
						at: index
						put: evt currentPosition + (cornerExtent / 2).
					polygonElement geometry vertices: vertices.
					polygonElement size: polygonElement geometry extent.
					refreshShadowDeferrer schedule ];
				yourself ].

	polygonElement
		addEventHandlerOn: BlMouseEnterEvent do: [ :evt |
			polygonElement border: (BlBorder builder paint: Color black; width: 1.5; dashArray: #(3); build).
			draggableVertexElements do: [ :each |
				each background: (Color white alpha: 0.25).
				each border: (BlBorder builder paint: Color black; width: 1.5; dashArray: #(3); build) ] ];
		addEventHandlerOn: BlMouseLeaveEvent do: [ :evt |
			polygonElement border: BlBorder empty.
			draggableVertexElements do: [ :each |
				each background: Color transparent.
				each border: BlBorder empty ] ].

	
	space := BlSpace new.
	space extent: 500@500.
	space show.
	
	polygonElement	addChildren: draggableVertexElements.
	shadowElement addChild: polygonElement.
	space root addChild: shadowElement
]

{ #category : #'instance creation' }
AeBenchBlurConvexPolygonRunner class >> new [

	| a vertices |
	a := 100.
	vertices := {
		a//2 @ 0.
		(a*3) @ a.
		0 @ (a*1.1) }.

"	vertices := { 
		0@0.
		a@0.
		a@a.
		0@a }.
"
	vertices := { 
		0 @ 0.
		a*2 @ (a).
		0 @ (a*2) }.

	^ self newForVertices: vertices blurSigma: 10
]

{ #category : #'instance creation' }
AeBenchBlurConvexPolygonRunner class >> newForVertices: points blurSigma: aBlurSigma [

	^ self basicNew
		initializeForVertices: points blurSigma: aBlurSigma;
		yourself
]

{ #category : #running }
AeBenchBlurConvexPolygonRunner >> _runDirectNaive0 [
	<script: 'self new _runDirectNaive0 inspect'>

	" -- fill -- "
"	mainContext restoreStateAfter: [
		mainContext translateByX: blurMargin y: blurMargin.
		polygonVertices do: [ :each |
			mainContext lineTo: each ].
		mainContext closePath.
		mainContext sourceColor: Color white; fill ].

"

	| aGradient topLeft topRight |
	aGradient :=
		(AeCairoLinearGradientPattern
			fromX: 0.0 fromY: blurMargin
			toX: 0.0 toY: blurMargin negated)
				addStopsFrom: ramp;
				yourself.

	" -- sides -- "
	polygonVertices withIndexDo: [ :each :index |
		| previousIndex previousVertex nextIndex nextVertex start cornerInfo |
		previousIndex := index = 1
			ifTrue: [ polygonVertices size ] ifFalse: [ index - 1 ].
		previousVertex := polygonVertices at: previousIndex.

		nextIndex := index = polygonVertices size
			ifTrue: [ 1 ] ifFalse: [ index + 1 ].
		nextVertex := polygonVertices at: nextIndex.



		" -- clip using bisection -- "
		cornerInfo := self roundedCornerP1: previousVertex p2: each p3: nextVertex.
		cornerInfo traceCr.
"		cornerInfo halt.
		mainContext restoreStateAfter: [
			mainContext moveTo: cornerInfo first;
				lineTo: each  ]."


		" -- paint gradient -- "
		mainContext saveState.

		start := each + blurMargin.
		mainContext
			rotateByRadians: (nextVertex - each) angle center: start;
			translateBy: start.

		mainContext
			rectangleX: 0
				y: blurMargin negated
				width: (each distanceTo: nextVertex)
				height: blurMargin * 2.

		mainContext
			sourcePattern: aGradient;
			fillPreservingPath: false alpha: self shadowColor alpha.

		topLeft := mainContext matrix value: 0 @ blurMargin negated. 
		topRight := mainContext matrix value: (each distanceTo: nextVertex) @ blurMargin negated. 

		mainContext restoreState.
		
		mainContext restoreStateAfter: [
			mainContext sourceColor: Color orange.
			mainContext circleCenter: topLeft radius: 2; fill.
			mainContext circleCenter: topRight radius: 2; fill.
			
			mainContext sourceColor: Color white.
			mainContext translateByX: blurMargin y: blurMargin.
			mainContext circleCenter: cornerInfo first radius: 2; fill.
			mainContext circleCenter: each radius: 2; fill. ].

	].


	^ mainSurface
]

{ #category : #running }
AeBenchBlurConvexPolygonRunner >> _runDirectNaive1 [
	<script: 'self new _runDirectNaive1 inspect'>

	| sides sideNormalAngle sideMargin |
	" -- debug fill -- "
	mainContext translateByX: blurMargin y: blurMargin.
	mainContext saveState.
	polygonVertices do: [ :each | mainContext lineTo: each ].
	mainContext closePath.
	mainContext sourceColor: Color white; fill.
	mainContext restoreState.


	sides := polygonVertices withIndexCollect: [ :each :index |
		| previousIndex previousVertex nextIndex nextVertex cornerInfo sideLength |

		previousIndex := index = 1
			ifTrue: [ polygonVertices size ] ifFalse: [ index - 1 ].
		previousVertex := polygonVertices at: previousIndex.

		nextIndex := index = polygonVertices size
			ifTrue: [ 1 ] ifFalse: [ index + 1 ].
		nextVertex := polygonVertices at: nextIndex.

		sideLength := each distanceTo: nextVertex.

		cornerInfo := self roundedCornerP1: previousVertex p2: each p3: nextVertex.

"		start := each + blurMargin.
		matrix := AeCairoMatrix newIdentity.
		matrix 
			rotateByRadians: (nextVertex - each) angle center: start;
			translateBy: start.

		topLeft := matrix value: 0 @ blurMargin negated. 
		topRight := matrix value: (each distanceTo: nextVertex) @ blurMargin negated. "
		sideNormalAngle := (nextVertex - each) angle - Float halfPi.
		sideMargin := Point x: blurMargin * sideNormalAngle cos y: blurMargin * sideNormalAngle sin.

		{	#inside -> cornerInfo first.
			#vertex -> each.  
			#outside1 -> (each + sideMargin).
			#outside2 -> (nextVertex + sideMargin).
		} asOrderedDictionary	].

	
	sides withIndexDo: [ :each :index |
		| next |
		next := index = sides size
			ifTrue: [ sides at: 1 ]
			ifFalse: [ sides at: index + 1 ].
	
		mainContext saveState.

		mainContext
			moveTo: (each at: #inside);
"			lineTo: (each at: #vertex);"
			lineTo: (each at: #outside1);
			lineTo: (each at: #outside2);
"			lineTo: (next at: #vertex);"
			lineTo: (next at: #inside);
			closePath.

		mainContext
			sourceColor: (Color black alpha: 1.0/index);
			stroke;
			restoreState
		 ].


	^ mainSurface
]

{ #category : #running }
AeBenchBlurConvexPolygonRunner >> _runDirectNaive2 [
	<script: 'self new _runDirectNaive2 inspect'>

	| sides sideNormalAngle sideMargin |
	mainContext antialias: AeCairoAntialias none.
	mainContext translateByX: blurMargin y: blurMargin.

	sides := polygonVertices withIndexCollect: [ :each :index |
		| previousIndex previousVertex nextIndex nextVertex cornerInfo sideLength |

		previousIndex := index = 1
			ifTrue: [ polygonVertices size ] ifFalse: [ index - 1 ].
		previousVertex := polygonVertices at: previousIndex.

		nextIndex := index = polygonVertices size
			ifTrue: [ 1 ] ifFalse: [ index + 1 ].
		nextVertex := polygonVertices at: nextIndex.

		sideLength := each distanceTo: nextVertex.

		cornerInfo := self roundedCornerP1: previousVertex p2: each p3: nextVertex.

		sideNormalAngle := (nextVertex - each) angle - Float halfPi.
		sideMargin := Point x: blurMargin * sideNormalAngle cos y: blurMargin * sideNormalAngle sin.

		{	#inside -> cornerInfo first.
			#vertex -> each.  
			#gradientFrom -> (each - sideMargin).
			#outside1 -> (each + sideMargin).
			#outside2 -> (nextVertex + sideMargin).
		} asOrderedDictionary	].

	
	sides withIndexDo: [ :each :index |
		| next |
		next := index = sides size
			ifTrue: [ sides at: 1 ]
			ifFalse: [ sides at: index + 1 ].
	
		mainContext saveState.

		mainContext
			moveTo: (each at: #inside);
			lineTo: (each at: #vertex);
			lineTo: (each at: #outside1);
			lineTo: (each at: #outside2);
			lineTo: (next at: #vertex);
			lineTo: (next at: #inside);
			closePath;
			clip.

"		mainContext
			sourceColor: (Color black alpha: 1.0/index);
			stroke."

		mainContext sourcePattern:
			((AeCairoLinearGradientPattern
				from: (each at: #gradientFrom)
				to: (each at: #outside1))
					addStopsFrom: ramp;
					yourself).
		mainContext paintWithAlpha: self shadowColor alpha.
		
		mainContext restoreState ].




	sides do: [ :each |
		mainContext lineTo: (each at: #inside) ].
	mainContext
		closePath;
		sourceColor: self shadowColor;
		fill.

	^ mainSurface
]

{ #category : #initialization }
AeBenchBlurConvexPolygonRunner >> initializeForVertices: points blurSigma: aBlurSigma [

	| mainExtent |
	self initialize.

	polygonVertices := points.
	blurSigma := aBlurSigma.

	"Estimated radius that Gaussian blur affects"
	blurMargin := (blurSigma * 2) ceiling.
	
	mainExtent := ((Rectangle encompassing: polygonVertices)
		expandBy: blurMargin) extent asIntegerPoint.
	mainSurface := AeCairoImageSurface
		extent: mainExtent
		format: AeCairoSurfaceFormat argb32.
	mainContext := mainSurface newContext.

	"Background is same for all runs"
	mainContext sourceColor: Color yellow; paint.

	"The ramp defines all stops, playing with alpha channel"
	ramp := self shadowRampSize: blurMargin
]

{ #category : #initialization }
AeBenchBlurConvexPolygonRunner >> rampFunctionAt: x [
	"Evaluate 1.0 minus a sigmoid (logistic) function, with mu and sigma determined manually by try and error."

	^ 1.0 - (1.0 / (1.0 + (((x - 0.5) * -9.0) exp)))
]

{ #category : #running }
AeBenchBlurConvexPolygonRunner >> roundedCornerP1: p1 p2: p2 p3: p3 [
	"Based on `RSAthensRenderer>>#applyRadius:on:from:to:`, which is based on
	https://riptutorial.com/html5-canvas/example/18766/render-a-rounded-polygon-"

	| v1 len1 a1 v2 len2 a2 sinA sin90 angle radDir isClockwise halfAngle cRadius lenOut p a b |
	(p1 = p2 or: [ p2 = p3 ]) ifTrue: [ ^ 1halt ].

	v1 := p1 - p2.
	len1 := v1 r.
	v1 := v1 / len1.
	a1 := v1 angle.

	v2 := p3 - p2.
	len2 := v2 r.
	v2 := v2 / len2.
	a2 := v2 angle.

	sinA := (v1 x * v2 y) - (v1 y * v2 x).
	sin90 := (v1 x * v2 x) - (v1 y * v2 y negated).
	angle := sinA arcSin.
	radDir := 1.
	isClockwise := true.

	sin90 < 0.0
		ifTrue: [
			angle < 0.0
				ifTrue: [ angle := angle + Float pi ]
				ifFalse: [
					angle := angle - Float pi.
					radDir := -1.
					isClockwise := false.
					1halt ] ]
		ifFalse: [
			angle >= 0.0 ifTrue: [
				radDir := -1.
				isClockwise := false.
				1halt ] ].

	halfAngle := angle / 2.0.
	sinA :=  halfAngle sin.
	lenOut := (sinA closeTo: 0.0)
		ifTrue: [ Float infinity ]
		ifFalse: [ (halfAngle cos * blurMargin / sinA) abs ].
	cRadius := blurMargin.
	lenOut > ((len1 / 2.0) min: (len2 / 2.0)) ifTrue: [
		lenOut := (len1 / 2.0) min: (len2 / 2.0).
		cRadius := (lenOut * halfAngle tan) abs ].

	p := p2 + (v2 * lenOut) + (v2 y negated @ v2 x * cRadius * radDir).
	a := a1 + (Float halfPi * radDir).
	b := a2 - (Float halfPi * radDir).
	(a closeTo: b) ifTrue: [ a := b ].

	^ {p}
]

{ #category : #running }
AeBenchBlurConvexPolygonRunner >> runDirectNaive [
	<script: 'self new runDirectNaive inspect'>

	| sides sideNormalAngle sideMargin cornerV1 cornerV2 cornerCenter cornerRadius insideVertices aGradient |
	mainContext antialias: AeCairoAntialias none.
	mainContext translateByX: blurMargin y: blurMargin.




	insideVertices := polygonVertices withIndexCollect: [ :each :index |
		| previousIndex previousVertex nextIndex nextVertex |

		previousIndex := index = 1
			ifTrue: [ polygonVertices size ] ifFalse: [ index - 1 ].
		previousVertex := polygonVertices at: previousIndex.

		nextIndex := index = polygonVertices size
			ifTrue: [ 1 ] ifFalse: [ index + 1 ].
		nextVertex := polygonVertices at: nextIndex.

		(self roundedCornerP1: previousVertex p2: each p3: nextVertex) first ].

	sides := polygonVertices withIndexCollect: [ :each :index |
		| previousIndex previousVertex nextIndex nextVertex sideLength |

		previousIndex := index = 1
			ifTrue: [ polygonVertices size ] ifFalse: [ index - 1 ].
		previousVertex := polygonVertices at: previousIndex.

		nextIndex := index = polygonVertices size
			ifTrue: [ 1 ] ifFalse: [ index + 1 ].
		nextVertex := polygonVertices at: nextIndex.

		sideLength := each distanceTo: nextVertex.

		sideNormalAngle := (nextVertex - each) angle - Float halfPi.
		sideMargin := Point r: blurMargin*2 theta: sideNormalAngle.

		{	#inside -> (insideVertices at: index).
			#vertex -> each.
			#gradientFrom -> (each - sideMargin).
			#outside1 -> ((insideVertices at: index) + sideMargin).
			#outside2 -> ((insideVertices at: nextIndex) + sideMargin).
		} asOrderedDictionary	].



	" -- core --"

	sides do: [ :each |
		mainContext lineTo: (each at: #inside) ].
	mainContext
		sourceColor: self shadowColor;
		fill.


	" -- sides -- "
	
	sides withIndexDo: [ :each :index |
		| next |
		next := index = sides size
			ifTrue: [ sides at: 1 ]
			ifFalse: [ sides at: index + 1 ].


		" -- side -- "
	
		mainContext saveState.

		mainContext
			moveTo: (each at: #inside);
			lineTo: (each at: #outside1);
			lineTo: (each at: #outside2);
			lineTo: (next at: #inside);
			closePath.
		
"		mainContext
			sourceColor: Color black;
			strokeSize: 2;
			strokePreservingPath."
		
		mainContext clip.

		aGradient :=
			((AeCairoLinearGradientPattern
				from: (each at: #inside)
				to: (each at: #outside1))
					addStopsFrom: ramp;
					yourself).
		mainContext sourcePattern: aGradient.
		mainContext paintWithAlpha: self shadowColor alpha.
		mainContext restoreState.
		"Force free to include this time in the benchmarks"
		aGradient externallyFree.


		" -- corner -- "
		mainContext saveState.

		cornerV1 := (each at: #outside2) - (next at: #inside). 
		cornerV2 := (next at: #outside1) - (next at: #inside). 
		cornerCenter := next at: #inside.
		cornerRadius := cornerV1 r.
		mainContext
			moveTo: cornerCenter;
			arcCenter: cornerCenter
			radius: cornerRadius
			startAngle: cornerV1 angle
			endAngle: cornerV2 angle;
			closePath.
		aGradient :=
			((AeCairoRadialGradientPattern
				center: cornerCenter
				innerRadius: 0
				outerRadius: cornerRadius)
					addStopsFrom: ramp;
					yourself).
		mainContext sourcePattern: aGradient.
		mainContext fillPreservingPath: false alpha: self shadowColor alpha.

"		mainContext
			sourceColor: Color black;
			strokeSize: 2;
			stroke."
		
		mainContext restoreState.
		
		"Force free to include this time in the benchmarks"
		aGradient externallyFree
		].


	





	^ mainSurface
]

{ #category : #running }
AeBenchBlurConvexPolygonRunner >> runGaussian [
	<script: 'self new runGaussian inspect'>

	| maskSurface maskContext |
	maskSurface := AeCairoImageSurface
		extent: mainSurface extent
		format: AeCairoSurfaceFormat a8.

	maskContext := maskSurface newContext.

	maskContext
		translateByX: blurMargin y: blurMargin.
	polygonVertices do: [ :each |
		maskContext lineTo: each ].
	maskContext closePath.

	maskContext
		sourceColor: Color black;
		fill.

	AeCairoA8GaussianBlurFilter new
		surface: maskSurface;
		applySigma: blurSigma.

	mainSurface newContext
		sourceColor: self shadowColor;
		maskSurface: maskSurface.
	
	^ mainSurface
]
