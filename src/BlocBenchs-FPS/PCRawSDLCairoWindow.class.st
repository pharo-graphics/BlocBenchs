Class {
	#name : #PCRawSDLCairoWindow,
	#superclass : #Object,
	#instVars : [
		'session',
		'cairoContext',
		'sdlRenderer',
		'sdlWindow',
		'isHighDPI',
		'deviceScalePoint',
		'steppingProcess',
		'mainTextureStrategy'
	],
	#classVars : [
		'MainTextureStrategyClass'
	],
	#pools : [
		'SDL2Constants'
	],
	#category : #'BlocBenchs-FPS-Raw'
}

{ #category : #'as yet unclassified' }
PCRawSDLCairoWindow class >> initialize [

	self useUpdateStaticTextureStrategy
]

{ #category : #'as yet unclassified' }
PCRawSDLCairoWindow class >> useDirectDrawToStreamingTextureStrategy [
	
	MainTextureStrategyClass := PCDirectDrawToStreamingTextureStrategy
]

{ #category : #'as yet unclassified' }
PCRawSDLCairoWindow class >> useMemCopyToStreamingTextureStrategy [
	
	MainTextureStrategyClass := PCMemCopyToStreamingTextureStrategy
]

{ #category : #'as yet unclassified' }
PCRawSDLCairoWindow class >> useUpdateStaticTextureStrategy [
	
	MainTextureStrategyClass := PCUpdateStaticTextureStrategy

]

{ #category : #'opening and closing' }
PCRawSDLCairoWindow >> close [

	sdlRenderer ifNil: [ ^ self ].
	sdlRenderer destroy.
	sdlRenderer := nil.

	sdlWindow destroy.
	sdlWindow := nil.

]

{ #category : #stepping }
PCRawSDLCairoWindow >> drawDone [

	mainTextureStrategy drawDone
]

{ #category : #stepping }
PCRawSDLCairoWindow >> drawOnCairoSurface [
	"Hook: subclasses can use cairoContext to draw."
]

{ #category : #stepping }
PCRawSDLCairoWindow >> drawPrepare [

	mainTextureStrategy drawPrepare.
	cairoContext := mainTextureStrategy cairoContext.
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

	sdlRenderer := sdlWindow createDefaultRenderer.

	deviceScalePoint := sdlRenderer outputExtent / sdlWindow size.
	isHighDPI := deviceScalePoint x > 1.0 or: [ deviceScalePoint y > 1.0 ].

	self resetMainTexture.

]

{ #category : #'opening and closing' }
PCRawSDLCairoWindow >> openWithTitle: title position: position extent: extent shape: shapeSurface [

	| aMode |
	sdlWindow := SDL2
						createShapedWindow: title
						x: position x
						y: position y
						width: extent x
						height: extent y
						flags: SDL_WINDOW_SHOWN | SDL_WINDOW_ALLOW_HIGHDPI. "| SDL_WINDOW_OPENGL"

	[ sdlWindow isShaped ] whileFalse: [
		';' trace.
		10 milliSeconds wait ].
	'.' traceCr.	

	"Any translucent pixel will be considered transparent"
	aMode :=	SDL_WindowShapeMode
		mode: SDL_WindowShapeModeEnum ShapeModeBinarizeAlpha
		parameters: (SDL_WindowShapeParams binarizationCutoff: 255).
	(sdlWindow primSetWindowShape: shapeSurface mode: aMode) in: [ :result |
		result = 0 ifFalse: [ self error: 'Unsuccessful operation' ] ].


	sdlRenderer := sdlWindow createDefaultRenderer.

	deviceScalePoint := sdlRenderer outputExtent / sdlWindow size.
	isHighDPI := deviceScalePoint x > 1.0 or: [ deviceScalePoint y > 1.0 ].

	self resetMainTexture.

]

{ #category : #'opening and closing' }
PCRawSDLCairoWindow >> openWithTitleOriginal: title position: position extent: extent [

	sdlWindow := SDL2
						createWindow: title
						x: position x
						y: position y
						width: extent x
						height: extent y
						flags: SDL_WINDOW_SHOWN | SDL_WINDOW_ALLOW_HIGHDPI. "| SDL_WINDOW_OPENGL"

	sdlRenderer := sdlWindow createDefaultRenderer.

	deviceScalePoint := sdlRenderer outputExtent / sdlWindow size.
	isHighDPI := deviceScalePoint x > 1.0 or: [ deviceScalePoint y > 1.0 ].

	self resetMainTexture.

]

{ #category : #stepping }
PCRawSDLCairoWindow >> presentOnWindow [

	sdlRenderer
		copy: mainTextureStrategy sdlTexture;
		present
]

{ #category : #'opening and closing' }
PCRawSDLCairoWindow >> resetMainTexture [

	mainTextureStrategy := MainTextureStrategyClass
		newExtent: sdlRenderer outputExtent
		renderer: sdlRenderer
		setupBlock: self textureStrategySetupBlock

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

	steppingProcess ifNil: [ ^self ].
	steppingProcess terminate.
	steppingProcess := nil.
]

{ #category : #'opening and closing' }
PCRawSDLCairoWindow >> textureStrategySetupBlock [

	^ [ :aCairoContext |

		"Reduce quality options if it's a HiDPI display"
		isHighDPI ifTrue: [
			aCairoContext
				tolerance: 0.5;
				antialias: AeCairoAntialias CAIRO_ANTIALIAS_NONE.
			aCairoContext surface deviceScale: deviceScalePoint ] ]

]
