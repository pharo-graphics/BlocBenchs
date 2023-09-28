"
I'm a Bloc host that renders and pulses BUT doesn't open an actual window.

As a consequence:
- I process space frames normally, which includes processing tasks that are enqueued (for example, animations)
- No mouse or keyboard events are generated (as there is no actual window shown)
- Rendered surface is not copied to a window surface (same)

Differences with `BlHeadlessHost`:
- I don't subclass BlHost
- I don't provide a pulse loop
- I don't copy rendered pixels
- I don't use a Sparta canvas (but could, it's polymorphic but not implemented yet)
"
Class {
	#name : 'PCHeadlessHost',
	#superclass : 'Object',
	#classInstVars : [
		'scaleFactor'
	],
	#category : 'BlocBenchs-FPS-Host-Headless',
	#package : 'BlocBenchs-FPS',
	#tag : 'Host-Headless'
}

{ #category : 'accessing' }
PCHeadlessHost class >> scaleFactor [

	^ scaleFactor ifNil: [ 1.0 ]
]

{ #category : 'accessing' }
PCHeadlessHost class >> scaleFactor: aFloat [
	"
	For typical HiDPI:
	
	self scaleFactor: 2.0
	"

	scaleFactor := aFloat
]

{ #category : 'accessing' }
PCHeadlessHost class >> stop [
	
	
]

{ #category : 'enumerating' }
PCHeadlessHost class >> uiProcessDo: aFullBlockClosure [ 
	
	^ aFullBlockClosure value: Processor activeProcess
]

{ #category : 'host - api' }
PCHeadlessHost >> createHostSpaceFor: aBlSpace [ 
	
	| scaleFactor aHostSpace aCanvas aeCairoSurface |
	"Create and initialize a AeCanvas like a `BASpaceRenderer`"
	scaleFactor := self class scaleFactor.
	aeCairoSurface := AeCairoImageSurface extent: aBlSpace extent * scaleFactor.
	aeCairoSurface deviceScale: scaleFactor asPoint.
	aCanvas := AeCanvas newFor: aeCairoSurface.
	scaleFactor > 1.0 ifTrue: [ aCanvas setLowQualityOptions ].

	
	aHostSpace := PCHeadlessHostSpace new.
	aHostSpace
		space: aBlSpace;
		canvas: aCanvas.
	aBlSpace hostSpace: aHostSpace.

]

{ #category : 'host - api' }
PCHeadlessHost >> destroyHostSpaceFor: aBlSpace [

	aBlSpace detachHostSpace
]

{ #category : 'testing' }
PCHeadlessHost >> isRunning [

	^ true
]

{ #category : 'testing' }
PCHeadlessHost >> isStillAvailable [

	^ true
]
