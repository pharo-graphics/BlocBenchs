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
		'blurMargin'
	],
	#category : #'BlocBenchs-Alexandrie-Blur'
}

{ #category : #'instance creation' }
AeBenchBlurConvexPolygonRunner class >> new [

	| triangleSize vertices |
	triangleSize := 100.
	vertices := {0@0. (triangleSize*3) @ triangleSize. 0@(triangleSize*2) }.

	^ self newForVertices: vertices blurSigma: 10
]

{ #category : #'instance creation' }
AeBenchBlurConvexPolygonRunner class >> newForVertices: points blurSigma: aBlurSigma [

	^ self basicNew
		initializeForVertices: points blurSigma: aBlurSigma;
		yourself
]

{ #category : #initialization }
AeBenchBlurConvexPolygonRunner >> initializeForVertices: points blurSigma: aBlurSigma [

	| mainExtent |
	self initialize.

	polygonVertices := points.
	blurSigma := aBlurSigma.

	"Estimated radius that a Gaussian shadows affects"
	blurMargin := (blurSigma * Float pi) ceiling.
	
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

	AeCairoA8FastGaussianBlurFilter new
		surface: maskSurface;
		applySigma: blurSigma.

	mainSurface newContext
		sourceColor: self shadowColor;
		maskSurface: maskSurface.
	
	^ mainSurface
]
