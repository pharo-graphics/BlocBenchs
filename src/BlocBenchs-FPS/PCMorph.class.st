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
		'random',
		'surfaceExtent',
		'session',
		'lastMS',
		'deltaMS',
		'startMS',
		'surfaceRectangle',
		'surfaceData',
		'framesDeltaMS'
	],
	#category : #'BlocBenchs-FPS-RawMorph-Old'
}

{ #category : #accessing }
PCMorph >> case [

	^ case
]

{ #category : #accessing }
PCMorph >> case: aPCBenchCase [

	case := aPCBenchCase.
	self surfaceExtent: aPCBenchCase logicalExtent.
	self random: aPCBenchCase newRandom.

]

{ #category : #drawing }
PCMorph >> drawOn: aFormCanvas [

	| currentMS |
	self ensureReadyToDrawOnCairoCanvas.

	"Remember when was the first time a frame is going to be drawn."
	currentMS := Time millisecondClockValue.
	startMS
		ifNil: [
			deltaMS := 0.0. 
			startMS := currentMS.
			framesDeltaMS := OrderedCollection new: case numberOfSeconds * 250.
			self resetAnimation ]
		ifNotNil: [
			deltaMS := currentMS - lastMS.
			framesDeltaMS add: deltaMS ].
	lastMS := currentMS.

	"Replaces #drawDuring:"
	self drawOnCairoSurface.

	"Replaces #displayOnMorphicCanvas:at:"
	self updateFromCairoSurfaceToFormCanvas: aFormCanvas.
]

{ #category : #drawing }
PCMorph >> drawOnCairoSurface [
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

	^ framesDeltaMS size
]

{ #category : #accessing }
PCMorph >> framesDeltaMS [

	^ framesDeltaMS
]

{ #category : #initialization }
PCMorph >> initializeSurface [

	cairoSurface := AeCairoImageSurface extent: surfaceExtent.
	cairoContext := cairoSurface newContext.
	surfaceRectangle := 0@0 extent: surfaceExtent.

	surfaceData := FFIExternalArray
		fromHandle: cairoSurface data getHandle
		type: FFIUInt32
		size: cairoSurface byteSize >> 2.

]

{ #category : #accessing }
PCMorph >> logicalExtent [

	^ surfaceExtent
]

{ #category : #accessing }
PCMorph >> random [

	^ random
]

{ #category : #accessing }
PCMorph >> random: aRandom [

	random := aRandom
]

{ #category : #drawing }
PCMorph >> resetAnimation [

]

{ #category : #stepping }
PCMorph >> step [

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
