"
I'm a Morph that draws an Athens Canvas every time the World steps.

This is useful for benchmarking FPS.
"
Class {
	#name : #PCMorph,
	#superclass : #Morph,
	#instVars : [
		'case',
		'surface',
		'frameCount',
		'random',
		'surfaceExtent',
		'surfaceForm',
		'surfaceRectangle',
		'cairoCanvas',
		'session',
		'bitblt',
		'lastMS',
		'deltaMS',
		'startMS'
	],
	#category : #'BlocBenchs-FPS-RawMorph'
}

{ #category : #accessing }
PCMorph >> case [

	^ case
]

{ #category : #accessing }
PCMorph >> case: aPCBenchCase [

	case := aPCBenchCase.
	self surfaceExtent: aPCBenchCase surfaceExtent.
	self random: aPCBenchCase newRandom.

]

{ #category : #drawing }
PCMorph >> copyCairoSurfaceTo: aFormCanvas [
	"Based on displayOnMorphicCanvas:at:"

	bitblt copyBitsTo: aFormCanvas form at: bounds origin clipRect: aFormCanvas privateClipRect.

"	It'd be better to restore this code instead of the PCBitBlt:

	aFormCanvas
		image: surfaceForm
		at: bounds origin
		sourceRect: surfaceRectangle
		rule: 34."
]

{ #category : #drawing }
PCMorph >> drawOn: aFormCanvas [

	| currentMS |
	self ensureReadyToDrawOnCairoCanvas.

	"Remember when was the first time a frame is going to be drawn."
	currentMS := Time millisecondClockValue.
	startMS
		ifNil: [ deltaMS := 0.0. startMS := currentMS. self prepareFirstDraw ]
		ifNotNil: [ deltaMS := currentMS - lastMS ].
	lastMS := currentMS.

	"Replaces #drawDuring:"
	self drawOnCairoCanvas.

	"Replaces #displayOnMorphicCanvas:at:"
	self copyCairoSurfaceTo: aFormCanvas.
]

{ #category : #drawing }
PCMorph >> drawOnCairoCanvas [
	"Draw on cairoCanvas. Assume #ensureReadyToDrawOnCairoCanvas was executed just before."

	self subclassResponsibility
]

{ #category : #accessing }
PCMorph >> elapsedTimeSinceFirstDraw [

	^ (lastMS - startMS) milliSeconds
]

{ #category : #initialization }
PCMorph >> ensureReadyToDrawOnCairoCanvas [

	session == Smalltalk session ifTrue: [ ^ self ].
	session := Smalltalk session.

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
	frameCount := 0.
]

{ #category : #initialization }
PCMorph >> initializeSurface [

	surface := PCCairoSurface extent: surfaceExtent.
	cairoCanvas := surface cairoContext.
	surfaceForm := surface pureCairoAsFormExtent: surfaceExtent.
	surfaceRectangle := 0@0 extent: surfaceExtent.
	bitblt := PCBitBlt
		sourceForm: surfaceForm
		sourceRect: surfaceRectangle.

]

{ #category : #drawing }
PCMorph >> prepareFirstDraw [

]

{ #category : #accessing }
PCMorph >> random [

	^ random
]

{ #category : #accessing }
PCMorph >> random: anObject [

	random := anObject
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
