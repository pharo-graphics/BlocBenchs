"
I'm a Morph that draws an Athens Canvas every time the World steps.

This is useful for benchmarking FPS.
"
Class {
	#name : #PCMorph,
	#superclass : #Morph,
	#instVars : [
		'surface',
		'frameCount',
		'random',
		'startTimestamp',
		'surfaceExtent',
		'surfaceForm',
		'surfaceRectangle'
	],
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #drawing }
PCMorph >> drawOn: aFormCanvas [

	"TODO: check session"
	startTimestamp ifNil: [
		self initializeSurface.
		startTimestamp := DateAndTime now ].

	surface drawDuring: [ :aCanvas | self drawOnAthensCanvas: aCanvas ].

	aFormCanvas
		image: surfaceForm
		at: bounds origin
		sourceRect: surfaceRectangle
		rule: 34.

]

{ #category : #accessing }
PCMorph >> frameCount [

	^ frameCount
]

{ #category : #initialization }
PCMorph >> initialize [

	super initialize.
	surfaceExtent := 500@500.
	random := Random seed: 1.
	frameCount := 0.
]

{ #category : #initialization }
PCMorph >> initializeSurface [

	surface := AthensCairoSurface extent: surfaceExtent.
	surfaceForm := surface pureCairoAsFormExtent: surfaceExtent.
	surfaceRectangle := 0@0 extent: surfaceExtent.

]

{ #category : #accessing }
PCMorph >> startTimestamp [

	^ startTimestamp
]

{ #category : #stepping }
PCMorph >> step [

	frameCount := frameCount + 1.
	self changed
]

{ #category : #stepping }
PCMorph >> stepTime [

	^ 0
]

{ #category : #accessing }
PCMorph >> surface [

	^ surface
]

{ #category : #accessing }
PCMorph >> surfaceExtent [

	^ surfaceExtent
]

{ #category : #accessing }
PCMorph >> surfaceExtent: aPoint [

	surfaceExtent := aPoint
]
