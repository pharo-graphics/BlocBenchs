Class {
	#name : #PCRawSDLCairoWindow,
	#superclass : #Object,
	#instVars : [
		'session',
		'cairoSurface',
		'cairoContext',
		'sdlRenderer',
		'sdlTexture',
		'sdlSurface',
		'steppingProcess',
		'sdlWindow'
	],
	#pools : [
		'SDL2Constants'
	],
	#category : #'BlocBenchs-FPS-Raw'
}

{ #category : #'initialize-release' }
PCRawSDLCairoWindow >> close [

	sdlWindow ifNil: [ self error: 'Window is not open' ].

	sdlRenderer destroy.
	sdlRenderer := nil.

	sdlWindow destroy.
	sdlWindow := nil.

]

{ #category : #'as yet unclassified' }
PCRawSDLCairoWindow >> drawOnCairoSurface [
	"Hook"
]

{ #category : #initialization }
PCRawSDLCairoWindow >> initializeSurfaces [

	| outputExtent |

	"SDL2:"	

	outputExtent := sdlRenderer outputExtent. "physical size"
	sdlSurface := SDL2
		createRGBSurfaceForCairoWidth: outputExtent x
		height: outputExtent y.

	sdlTexture := sdlRenderer
		createTextureFormat: SDL_PIXELFORMAT_XRGB8888
		access: SDL_TEXTUREACCESS_STREAMING
		width: outputExtent x
		height: outputExtent y.

	"Cairo:"

	cairoSurface := AeCairoImageSurface
		createForData: sdlSurface pixels
		extent: outputExtent
		stride: sdlSurface pitch
		format: AeCairoSurfaceFormat CAIRO_FORMAT_ARGB32.
	cairoContext := cairoSurface newContext.

	"Apply HiDPI scale"
	cairoSurface deviceScale: outputExtent / sdlWindow size.

]

{ #category : #'as yet unclassified' }
PCRawSDLCairoWindow >> openWithTitle: title position: position extent: extent [

	sdlWindow ifNotNil: [ self error: 'Already open' ].

	sdlWindow := SDL2 createWindow: title
					x: position x
					y: position y
					width: extent x
					height: extent y
					flags: SDL_WINDOW_SHOWN | SDL_WINDOW_ALLOW_HIGHDPI.
	sdlRenderer := sdlWindow createAcceleratedRenderer "createDefaultRenderer".

	self initializeSurfaces.
	
"	sdlRenderer drawColorR: 255 g: 255 b: 255 a: 255;
			  clear;
			  present.
"

]

{ #category : #'as yet unclassified' }
PCRawSDLCairoWindow >> presentCairoOnSDL [

	sdlTexture
		updateTexturePixels: sdlSurface pixels
		pitch: sdlSurface pitch.

	sdlRenderer
		clear;
		copy: sdlTexture;
		present
]

{ #category : #'as yet unclassified' }
PCRawSDLCairoWindow >> startStepLoop [

	[
		session := Smalltalk session.
		steppingProcess := Processor activeProcess.
		
		[ steppingProcess == Processor activeProcess
			and: [ session == Smalltalk session ]]
		
			whileTrue: [
				self step.
				self stepWait  ] ]

			forkAt: 40
			named: 'Step Loop ', self asString

]

{ #category : #'as yet unclassified' }
PCRawSDLCairoWindow >> step [

	self drawOnCairoSurface.
	self presentCairoOnSDL

]

{ #category : #'as yet unclassified' }
PCRawSDLCairoWindow >> stepWait [
			
	"1 milliSecond wait"
]

{ #category : #'initialize-release' }
PCRawSDLCairoWindow >> stopStepLoop [

	steppingProcess terminate.
	steppingProcess := nil.
]
