Class {
	#name : #PCRawSDLCairoWindow,
	#superclass : #Object,
	#instVars : [
		'session',
		'cairoSurface',
		'cairoContext',
		'sdlRenderer',
		'steppingProcess',
		'sdlWindow',
		'mainSdlTexture',
		'mainSdlSurface'
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

	mainSdlTexture
		updateTexturePixels: mainSdlSurface pixels
		pitch: mainSdlSurface pitch

]

{ #category : #stepping }
PCRawSDLCairoWindow >> drawOnCairoSurface [
	"Hook: subclasses can use cairoContext to draw."
]

{ #category : #stepping }
PCRawSDLCairoWindow >> drawPrepare [

	
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

	self resetMainTexture
]

{ #category : #stepping }
PCRawSDLCairoWindow >> presentOnWindow [

	sdlRenderer
		copy: mainSdlTexture;
		present
]

{ #category : #'opening and closing' }
PCRawSDLCairoWindow >> resetMainTexture [

	| outputExtent |

	"SDL2:"	

	outputExtent := sdlRenderer outputExtent. "physical size"
	mainSdlSurface := SDL2
		createRGBSurfaceForCairoWidth: outputExtent x
		height: outputExtent y.

	mainSdlTexture := sdlRenderer
		createTextureFormat: SDL_PIXELFORMAT_XRGB8888
		access: SDL_TEXTUREACCESS_STREAMING
		width: outputExtent x
		height: outputExtent y.

	"Cairo:"

	cairoSurface := AeCairoImageSurface
		createForData: mainSdlSurface pixels
		extent: outputExtent
		stride: mainSdlSurface pitch
		format: AeCairoSurfaceFormat CAIRO_FORMAT_ARGB32.
	cairoContext := cairoSurface newContext.

	"Reduce quality options if it's a HiDPI display"
	outputExtent x > sdlWindow size x ifTrue: [
		cairoContext
			primSetTolerance: 0.5;
			primSetAntialias: AeCairoAntialias CAIRO_ANTIALIAS_NONE.
		cairoSurface deviceScale: outputExtent / sdlWindow size ].

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
