"
I'm a Morph that draws an Athens Canvas every time the World steps.

This is useful for benchmarking FPS.
"
Class {
	#name : #PCMorph,
	#superclass : #Morph,
	#instVars : [
		'case',
		'cairoContext',
		'cairoSurface',
		'frameCount',
		'random',
		'surfaceExtent',
		'session',
		'lastMS',
		'deltaMS',
		'startMS',
		'surfaceRectangle',
		'surfaceData'
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
	self updateFromCairoSurfaceToFormCanvas: aFormCanvas.
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

	cairoSurface := AeCairoImageSurface extent: surfaceExtent.
	cairoContext := AeCairoContext create: cairoSurface.
	surfaceRectangle := 0@0 extent: surfaceExtent.

	surfaceData := FFIExternalArray
		fromHandle: cairoSurface primData getHandle
		type: FFIUInt32
		size: cairoSurface primHeight * cairoSurface primStride / 4.

]

{ #category : #drawing }
PCMorph >> prepareFirstDraw [

]

{ #category : #accessing }
PCMorph >> random [

	^ random
]

{ #category : #accessing }
PCMorph >> random: aRandom [

	random := aRandom
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

	^ cairoSurface
]

{ #category : #accessing }
PCMorph >> surfaceExtent [

	^ surfaceExtent
]

{ #category : #accessing }
PCMorph >> surfaceExtent: aPoint [

	surfaceExtent := aPoint
]

{ #category : #drawing }
PCMorph >> updateFromCairoSurfaceToFormCanvas: aFormCanvas [
	"Based on displayOnMorphicCanvas:at: and AeCairoImageSurface>>asForm."

	| aBitmap aForm |
	self flag: #todo. "SLOW and BUGGY since Alexandrie doesn't use the surface plugin!"

	aBitmap := Bitmap newFrom: surfaceData.
	aForm := Form extent: surfaceExtent depth: 32 bits: aBitmap.

	aFormCanvas
		image: aForm
		at: bounds origin
		sourceRect: surfaceRectangle
		rule: 34

]
