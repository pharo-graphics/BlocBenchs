"
I'm a boid expressed as a geometry.

See my references.

TODO: It is not drawing well into the canvas.
"
Class {
	#name : #BoidCustomGeometry,
	#superclass : #BlElementGeometry,
	#category : #'BlocBenchs-BoidsExample-UI-Bloc'
}

{ #category : #'geometry testing' }
BoidCustomGeometry >> containsPoint: aPoint in: aBlElement [ 
	"Inspired by BlEllipseGeometry>>#containsPoint:in:"

	| w h x y center xRadius yRadius normalized |
	
	w := aBlElement boid radius.
	h := w.
	x := 0.
	y := 0.
	
	xRadius := w / 2.0.
	yRadius := h / 2.0.
	center := (x + xRadius) @ (y + yRadius).

	(xRadius <= 0 or: [ yRadius <= 0 ])
		ifTrue: [ ^ false ].

	normalized := (aPoint x - center x) @ (aPoint y - center y).
	^ ((normalized x squared / xRadius squared) + (normalized y squared / yRadius squared)) <= 1
]

{ #category : #'api - bounds' }
BoidCustomGeometry >> geometryBounds: aBlBounds of: aBlElement [ 

	| center radius |
	center := aBlElement boid position.
	radius := aBlElement boid radius asPoint.

	^ aBlBounds
		origin: center - radius
		extent: center + radius
]

{ #category : #geometry }
BoidCustomGeometry >> matchElement: aBlElement [ 
	
	self flag: #todo. "Ignore element's extent. Wrong? We will get the position and radius from the boid in this element but at the moment of building the path."
]

{ #category : #sparta }
BoidCustomGeometry >> pathOnSpartaCanvas: aCanvas of: aBlElement [

	| aPathBuilder center aBoid ballRightAnchor |
	aBoid := aBlElement boid.
	center := aBoid position.

	aPathBuilder := aCanvas path.
	ballRightAnchor := aBoid radius @ 0.

	"Ball"
	aPathBuilder
"		absolute;"
		relative;
		moveTo: center + ballRightAnchor;
		arcAround: center radius: aBoid radius startAngle: 0 endAngle: Float pi * 2.
		
	"Tail"
	aPathBuilder
"		absolute; moveTo: center;"
"		relative;"
		moveTo: ballRightAnchor;
		lineTo: aBoid velocity negated.
		
	^ aPathBuilder
"		close;"
		finish
]

{ #category : #'api - cache' }
BoidCustomGeometry >> releaseCache [
	"Nothing to release"
]
