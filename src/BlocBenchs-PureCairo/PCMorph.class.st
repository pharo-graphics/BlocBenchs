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
		'surfaceRectangle',
		'cairoCanvas',
		'session'
	],
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #drawing }
PCMorph >> drawOn: aFormCanvas [

	self ensureReadyToDrawOnCairoCanvas.
	
	"Based on #drawDuring:"
	self drawOnCairoCanvas.

	"Based on #displayOnMorphicCanvas:at:"
	aFormCanvas
		image: surfaceForm
		at: bounds origin
		sourceRect: surfaceRectangle
		rule: 34.

]

{ #category : #drawing }
PCMorph >> drawOnCairoCanvas [
	"Draw on cairoCanvas. Assume #ensureReadyToDrawOnCairoCanvas was executed just before."

	self subclassResponsibility
]

{ #category : #initialization }
PCMorph >> ensureReadyToDrawOnCairoCanvas [

	session == Smalltalk session ifTrue: [ ^ self ].
	session := Smalltalk session.

	"Remember when was the first time a frame is going to be drawn."
	startTimestamp ifNil: [
		startTimestamp := DateAndTime now ].

	"This happens on the first draw but also, for example, 
	when I was open on save and quit, and then reopen."
	self initializeSurface.

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
	cairoCanvas := surface privContext.
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
