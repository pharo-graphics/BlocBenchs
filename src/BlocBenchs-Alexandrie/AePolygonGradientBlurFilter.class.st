Class {
	#name : #AePolygonGradientBlurFilter,
	#superclass : #AeGradientBlurFilter,
	#instVars : [
		'showDebugMarks',
		'sides',
		'vertices',
		'corners',
		'verticesInfo'
	],
	#category : #'BlocBenchs-Alexandrie-Blur'
}

{ #category : #private }
AePolygonGradientBlurFilter >> debugDo: aBlock [

	showDebugMarks ifFalse: [ ^ self ].

	context
		saveState;
		antialias: AeCairoAntialias best.

	aBlock value.

	context restoreState
]

{ #category : #drawing }
AePolygonGradientBlurFilter >> draw [

	context saveState.
	context antialias: AeCairoAntialias none.

	self drawCore.
	sides do: [ :each | self drawSide: each ].
	corners do: [ :each | self drawCorner: each ].

	context restoreState
]

{ #category : #private }
AePolygonGradientBlurFilter >> drawCore [

	sides withIndexDo: [ :each :index |
		(each at: #isClockwise)
			ifTrue: [ context lineTo: (each at: #inside1) ]
			ifFalse: [
				| a b cRadius |
				a := (verticesInfo at: index) fourth.
				b := (verticesInfo at: index) fifth.
				cRadius := (verticesInfo at: index) sixth.
				context
					arcCenter: (each at: #inside1)
					radius: cRadius * 2
					startAngle: a
					endAngle: b
					cw: false ]
		 ].
	context
		sourceColor: color;
		fill.


"	self debugDo: [
		vertices do: [ :each | context lineTo: each ].
		context
			closePath;
			sourceColor: Color white;
			strokeSize: 1.5;
			stroke ].

	self debugDo: [
		sides do: [ :each |
			context
				sourceColor: Color orange;
				circleCenter: (each at: #inside1) radius: 2;
				fill ] ]"
]

{ #category : #private }
AePolygonGradientBlurFilter >> drawCorner: corner [

	| aGradient |
	aGradient :=
		(corner at: #isClockwise)
			ifTrue: [
				(AeCairoRadialGradientPattern
					center: (corner at: #center)
					innerRadius: 0
					outerRadius: (corner at: #radius)) ]
			ifFalse: [
				(AeCairoRadialGradientPattern
					center: (corner at: #center)
					innerRadius: (corner at: #radius)
					outerRadius: 0) ].

	aGradient addStopsFrom: ramp.

		
	context
		moveTo: (corner at: #center);
		arcCenter: (corner at: #center)
			radius: (corner at: #radius)
			startAngle: (corner at: #angle1)
			endAngle: (corner at: #angle2)
			cw: (corner at: #isClockwise);
		closePath.
	context
		sourcePattern: aGradient;
		fillPreservingPath: false alpha: color alpha.

	aGradient externallyFree.


	self debugDo: [
		context
			moveTo: (corner at: #center);
			arcCenter: (corner at: #center)
				radius: (corner at: #radius)
				startAngle: (corner at: #angle1)
				endAngle: (corner at: #angle2)
				cw: (corner at: #isClockwise);
			closePath;
			
			sourceColor: Color green;
			strokeSize: 2;
			stroke ]

]

{ #category : #private }
AePolygonGradientBlurFilter >> drawSide: aSide [

	| aGradient |
	aGradient :=
		(aSide at: #isClockwise)
			ifTrue: [
				AeCairoLinearGradientPattern
					from: (aSide at: #inside1)
					to: (aSide at: #outside1) ]
			ifFalse: [
				AeCairoLinearGradientPattern
					from: (aSide at: #outside1)
					to: (aSide at: #inside1) ].
	aGradient addStopsFrom: ramp.
"	aGradient extend: AeCairoExtendMode none."

	context
		moveTo: (aSide at: #inside1);
		lineTo: (aSide at: #outside1);
		lineTo: (aSide at: #outside2);
		lineTo: (aSide at: #inside2);
		closePath.
	context
		sourcePattern: aGradient;
		fillPreservingPath: false  alpha: color alpha.

	aGradient externallyFree.
	
	self debugDo: [
		context
			moveTo: (aSide at: #inside1);
			lineTo: (aSide at: #outside1);
			lineTo: (aSide at: #outside2);
			lineTo: (aSide at: #inside2);
			closePath;
				
			sourceColor: Color red;
			strokeSize: 2;
			stroke ]

]

{ #category : #initialization }
AePolygonGradientBlurFilter >> initializeFor: aContext vertices: points sigma: blurSigma color: aColor [

	self initialize.
	
	showDebugMarks := false.
	color := aColor.
	context := aContext.
	vertices := points.

	"Estimated radius that Gaussian blur affects"
	blurMargin := (blurSigma * 2) ceiling.

	"The ramp defines all stops, playing with alpha channel"
	ramp := AeBenchBlurConvexPolygonRunner basicNew shadowRampSize: blurMargin.
	


	verticesInfo :=
		(1 to: vertices size) collect: [ :index |
			self
				roundedCornerP1: (vertices atWrap: index - 1)
				p2: (vertices at: index)
				p3: (vertices atWrap: index + 1) ].
	
	sides :=
		(1 to: vertices size) collect: [ :index |
			| inside nextInside normal isClockwise |
			inside := (verticesInfo at: index) first.
			normal := (verticesInfo at: index) second.
			nextInside := (verticesInfo atWrap: index + 1) first.
			(isClockwise := (verticesInfo at: index) third)
				ifFalse: [ nextInside := nextInside - normal ].
			(verticesInfo atWrap: index + 1) third
				ifFalse: [ nextInside := nextInside - normal ].

			{	#inside1 -> inside.
				#inside2 -> nextInside.
				#outside1 -> (inside + normal).
				#outside2 -> (nextInside + normal).
				#isClockwise -> isClockwise.
			} asOrderedDictionary	].

"	corners :=
		(1 to: vertices size) collect: [ :index |
			| aSide nextSide v1 v2 isClockwise |
			aSide := sides at: index.
			nextSide := sides atWrap: index + 1.
			v1 := (aSide at: #outside2) - (nextSide at: #inside1).
			v2 := (nextSide at: #outside1) - (nextSide at: #inside1).
			isClockwise := (verticesInfo at: index) third.
			
			{	#angle1 -> v1 angle.
				#angle2 -> v2 angle.
				#radius -> v1 r.
				#center -> (nextSide at: #inside1).
				#isClockwise -> isClockwise.
			} asOrderedDictionary ].
"
	corners :=
		verticesInfo collect: [ :each |		
			{	#angle1 -> each fourth.
				#angle2 -> each fifth.
				#radius -> (each sixth * 2).
"				#radius -> (blurMargin * 2)."
				#center -> each first.
				#isClockwise -> each third.
			} asOrderedDictionary ].

]

{ #category : #private }
AePolygonGradientBlurFilter >> roundedCornerP1: p1 p2: p2 p3: p3 [
	"Based on `RSAthensRenderer>>#applyRadius:on:from:to:`, which is based on
	https://riptutorial.com/html5-canvas/example/18766/render-a-rounded-polygon-"

	| v1 len1 a1 v2 len2 a2 sinA sin90 angle isClockwise halfAngle cRadius lenOut p a b sideNormal |
	(p1 = p2 or: [ p2 = p3 ]) ifTrue: [ ^ self error ].

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
	isClockwise := true.

	sin90 < 0.0
		ifTrue: [
			angle < 0.0
				ifTrue: [ angle := angle + Float pi ]
				ifFalse: [
					angle := angle - Float pi.
					isClockwise := false ] ]
		ifFalse: [
			angle >= 0.0 ifTrue: [
				isClockwise := false ] ].

	halfAngle := angle / 2.0.
	sinA := halfAngle sin.
	lenOut := (sinA closeTo: 0.0)
		ifTrue: [ Float infinity ]
		ifFalse: [ (halfAngle cos * blurMargin / sinA) abs ].
	cRadius := blurMargin.

	isClockwise
		ifTrue: [
			p := p2 + (v2 * lenOut) + ((v2 y negated @ v2 x) * cRadius).
			a := a1 + Float halfPi.
			b := a2 - Float halfPi ]
		ifFalse: [
			p := p2 + (v2 * lenOut) - ((v2 y negated @ v2 x) * cRadius).
			a := a1 - Float halfPi.
			b := a2 + Float halfPi ].

	sideNormal := Point r: cRadius * 2 theta: b.



	^ { p. sideNormal. isClockwise. a. b. cRadius. angle. lenOut }
]
