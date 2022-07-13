Class {
	#name : #PCRawSDLCairoWindow,
	#superclass : #Object,
	#instVars : [
		'session',
		'cairoContext',
		'sdlRenderer',
		'sdlWindow',
		'mainTexture',
		'isHighDPI',
		'deviceScalePoint',
		'steppingProcess'
	],
	#pools : [
		'SDL2Constants'
	],
	#category : #'BlocBenchs-FPS-Raw'
}

{ #category : #'opening and closing' }
PCRawSDLCairoWindow >> close [

	sdlRenderer destroy.
	sdlRenderer := nil.

	sdlWindow destroy.
	sdlWindow := nil.

]

{ #category : #stepping }
PCRawSDLCairoWindow >> drawDone [

	mainTexture drawDone
]

{ #category : #stepping }
PCRawSDLCairoWindow >> drawOnCairoSurface [
	"Hook: subclasses can use cairoContext to draw."
]

{ #category : #stepping }
PCRawSDLCairoWindow >> drawPrepare [

	mainTexture drawPrepare.
	cairoContext := mainTexture cairoContext.
]

{ #category : #'opening and closing' }
PCRawSDLCairoWindow >> openWithTitle: title position: position extent: extent [

	sdlWindow := SDL2
						createWindow: title
						x: position x
						y: position y
						width: extent x
						height: extent y
						flags: SDL_WINDOW_SHOWN | SDL_WINDOW_ALLOW_HIGHDPI. "| SDL_WINDOW_OPENGL"

	sdlRenderer := sdlWindow createAcceleratedRenderer.

	deviceScalePoint := sdlRenderer outputExtent / sdlWindow size.
	isHighDPI := deviceScalePoint x > 1.0 or: [ deviceScalePoint y > 1.0 ].

	self resetMainTexture.

]

{ #category : #stepping }
PCRawSDLCairoWindow >> presentOnWindow [

	sdlRenderer
		copy: mainTexture sdlTexture;
		present
]

{ #category : #'opening and closing' }
PCRawSDLCairoWindow >> resetMainTexture [

	mainTexture := "PCStaticSDLTexture" PCStreamingSDLTexture"Reusing "
		newExtent: sdlRenderer outputExtent
		renderer: sdlRenderer
		setupBlock: self textureSetupBlock

]

{ #category : #stepping }
PCRawSDLCairoWindow >> startLoop [

	[
		session := Smalltalk session.
		steppingProcess := Processor activeProcess.
		
		[ steppingProcess == Processor activeProcess
			and: [ session == Smalltalk session ]]
		
			whileTrue: [
				self step.
				self stepWait  ] ]

			forkAt: Processor userSchedulingPriority
			named: 'Step Loop ', self asString

]

{ #category : #stepping }
PCRawSDLCairoWindow >> step [

	self drawPrepare.
	self drawOnCairoSurface.
	self drawDone.

	self presentOnWindow

]

{ #category : #stepping }
PCRawSDLCairoWindow >> stepWait [

	self flag: #todo.
	1 milliSecond wait
]

{ #category : #stepping }
PCRawSDLCairoWindow >> stopLoop [

	steppingProcess terminate.
	steppingProcess := nil.
]

{ #category : #'opening and closing' }
PCRawSDLCairoWindow >> textureSetupBlock [

	^ [ :aCairoContext |

		"Reduce quality options if it's a HiDPI display"
		isHighDPI ifTrue: [
			aCairoContext
				primSetTolerance: 0.5;
				primSetAntialias: AeCairoAntialias CAIRO_ANTIALIAS_NONE.
			aCairoContext surface deviceScale: deviceScalePoint ] ]

]
