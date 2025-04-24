Class {
	#name : #BlBRawCase,
	#superclass : #BlBCase,
	#instVars : [
		'sdlRenderer',
		'mainTextureStrategy',
		'mainTextureStrategyClass',
		'cairoContext',
		'startMS',
		'deltaMS',
		'lastMS',
		'deviceScalePoint',
		'isHighDPI',
		'setupBlock'
	],
	#category : #'BlocBenchs-Core-Core'
}

{ #category : #running }
BlBRawCase class >> isAbstract [ 

	^ self == BlBRawCase 
]

{ #category : #running }
BlBRawCase >> beforeRunRenderer: aSDLRenderer window: aSDLWindow [

	startMS := Time millisecondClockValue.
	deltaMS := 0.0.
	lastMS := startMS.

	sdlRenderer := aSDLRenderer.

	deviceScalePoint := sdlRenderer outputExtent / aSDLWindow extent.
	isHighDPI := deviceScalePoint x > 1.0 or: [ deviceScalePoint y > 1.0 ].

	setupBlock := [ :aCairoContext |
		"Reduce quality options if it's a HiDPI display"
		isHighDPI ifTrue: [
			aCairoContext
				tolerance: 0.5;
				antialias: AeCairoAntialias none.
			aCairoContext surface deviceScale: deviceScalePoint ] ].

	self setupMainTexture
]

{ #category : #running }
BlBRawCase >> cleanUp [

	sdlRenderer := nil.
	mainTextureStrategy := nil
]

{ #category : #drawing }
BlBRawCase >> clearCairoSurface [ 

	cairoContext
		sourceColor: Color white;
		paint

]

{ #category : #'accessing - defaults' }
BlBRawCase >> defaultRunnerClass [

	^ BlBRawBenchRunner
]

{ #category : #'drawing - steps' }
BlBRawCase >> drawDone [

	mainTextureStrategy drawDone
]

{ #category : #'drawing - steps' }
BlBRawCase >> drawOnCairoSurface [

	self subclassResponsibility 
]

{ #category : #'drawing - steps' }
BlBRawCase >> drawPrepare [

	mainTextureStrategy drawPrepare.
	cairoContext := mainTextureStrategy cairoContext.
]

{ #category : #accessing }
BlBRawCase >> elapsedMillisecondsSinceFirstDraw [

	^ lastMS - startMS
]

{ #category : #accessing }
BlBRawCase >> extent [
	
	^ 800@600
]

{ #category : #initialization }
BlBRawCase >> initialize [

	super initialize.
	mainTextureStrategyClass := PCUpdateStaticTextureStrategy
]

{ #category : #accessing }
BlBRawCase >> numberOfMilliseconds [

	^ self duration asMilliSeconds 
]

{ #category : #accessing }
BlBRawCase >> position [
	
	^ 30 asPoint
]

{ #category : #'drawing - steps' }
BlBRawCase >> presentOnWindow [

	sdlRenderer
		copy: mainTextureStrategy sdlTexture;
		present
]

{ #category : #initialization }
BlBRawCase >> resetAnimation [
]

{ #category : #'drawing - steps' }
BlBRawCase >> setupMainTexture [

	mainTextureStrategy := mainTextureStrategyClass
		                       newExtent: sdlRenderer outputExtent
		                       renderer: sdlRenderer
		                       setupBlock: setupBlock.
]

{ #category : #'drawing - steps' }
BlBRawCase >> stepAnimation [

	| currentMS |
	currentMS := Time millisecondClockValue.
	deltaMS := currentMS - lastMS.
	lastMS := currentMS.

]

{ #category : #'drawing - steps' }
BlBRawCase >> stepRender [

	self stepAnimation.
	self drawPrepare.
	self drawOnCairoSurface.
	self drawDone.

	self presentOnWindow

]
