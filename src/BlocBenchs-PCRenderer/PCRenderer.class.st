Class {
	#name : #PCRenderer,
	#superclass : #BlHostRenderer,
	#instVars : [
		'cairoSurface',
		'hostSpace',
		'cairoCanvas',
		'hasBackground',
		'hasBorder',
		'borderColor',
		'borderWidth',
		'backgroundBlock',
		'formToCairoSurfaceCache',
		'backgroundAlpha'
	],
	#category : #'BlocBenchs-PCRenderer'
}

{ #category : #visiting }
PCRenderer >> acceptBlImageBackground: aBlImageBackground [ 

	hasBackground := true.

	"TODO: do not initialize here, and reset on new session"	
	formToCairoSurfaceCache ifNil: [
		formToCairoSurfaceCache := LRUCache new
			maximumWeight: 400;
			factory: [ :aForm | AthensCairoSurface fromForm: aForm ];
			yourself ].
	
	backgroundBlock := [ 
		| aForm aCairoSurface |
		aForm := aBlImageBackground image.

		aCairoSurface := formToCairoSurfaceCache at: aForm.
		cairoCanvas
			primSetSourceSurface: aCairoSurface x: 0.0 y: 0.0.
		
		backgroundAlpha := aBlImageBackground opacity ].
		
	

]

{ #category : #visiting }
PCRenderer >> acceptBlPaintBackground: aBlPaintBackground [

	hasBackground := true.
	backgroundAlpha := 1.0.
	backgroundBlock := [
		self setSourceColor: aBlPaintBackground paint color ]

]

{ #category : #visiting }
PCRenderer >> acceptBlTransparentBackground: aBlTransparentBackground [ 

	hasBackground := false.
	backgroundAlpha := 0.0.
	backgroundBlock := nil.
]

{ #category : #visiting }
PCRenderer >> acceptColorPaintBorder: aBlColorPaint border: aBlBorder [

	hasBorder := true.
	borderColor := aBlColorPaint color.
	borderWidth := aBlBorder width.

]

{ #category : #visiting }
PCRenderer >> acceptTransparentPaintBorder: aBlElement [ 
	
	hasBorder := false.
]

{ #category : #initialization }
PCRenderer >> createFormSpaceRenderer [

	^ PCFormSpaceRenderer new
]

{ #category : #'api - drawing' }
PCRenderer >> drawBackgroundAndOrStrokeWith: aBlock [

	(hasBackground or: [ hasBorder ]) ifFalse: [ ^self ].

	aBlock value.

	hasBackground ifTrue: [
		backgroundBlock value.
		
		hasBorder 
			ifFalse: [
				cairoCanvas
					primClip;
					primPaintAlpha: backgroundAlpha.
				^ self ]
			ifTrue: [
				cairoCanvas
					primClipPreserve;
					primPaintAlpha: backgroundAlpha ] ].

	"hasBorder is true (maybe hasBackground, too)"
	self setSourceColor: borderColor.
	cairoCanvas primSetLineWidthOn: borderWidth.
	cairoCanvas stroke.

]

{ #category : #'api - drawing' }
PCRenderer >> drawCircle: topLeftPoint radius: radiusPoint [

	self drawBackgroundAndOrStrokeWith: [
		| center |
		center := topLeftPoint + radiusPoint.

		cairoCanvas
			primArcCenterX: center x
			centerY: center y
			radius: radiusPoint x "TODO: ellipse"
			startAngle: 0.0
			endAngle: Float twoPi ]

]

{ #category : #'api - drawing' }
PCRenderer >> drawRectangle: aRectangle [

	self drawBackgroundAndOrStrokeWith: [
		cairoCanvas
			rectangleX: aRectangle left
			y: aRectangle top
			width: aRectangle width
			height: aRectangle height ]

]

{ #category : #visiting }
PCRenderer >> drawTriangle: thePoints [ 

	self drawBackgroundAndOrStrokeWith: [
		cairoCanvas moveTo: thePoints first.
		cairoCanvas lineTo: thePoints second.
		cairoCanvas lineTo: thePoints third ]

]

{ #category : #initialization }
PCRenderer >> initializeForHostSpace: aBlHostSpace [
	"Initialize this renderer for a given host space.
	Please note, that it I be called multiple times"
	
	session := Smalltalk session.
	
	"we should mark it as a current one before initializing a canvas as it may rely on opengl context"
	aBlHostSpace makeCurrent.
	
	surface := self.
	surfaceRenderer := self.
	spaceRenderer := self.

	hostSpace := aBlHostSpace.
	cairoSurface := AthensCairoSurface extent: aBlHostSpace physicalSize asPoint.

	textMeasurer := BlMockedTextMeasurer new
		ascent: -10;
		descent: 5;
		glyphWidth: 10;
		height: 15;
		yourself

]

{ #category : #'api - updates' }
PCRenderer >> performUpdates [


]

{ #category : #'host space - geometry' }
PCRenderer >> physicalSize [

	^ cairoSurface extent asPhysicalSize
]

{ #category : #visiting }
PCRenderer >> position: aPoint transformation: aMatrix applyDuring: aBlock [

	| needsTransformation needsTranslation |
	needsTranslation := aPoint isZero not.
	needsTransformation := aMatrix isIdentity not.
	
	"Evaluate without touching the canvas transformation."
	(needsTransformation or: [ needsTranslation ])
		ifFalse: [ ^ aBlock value ].
	
	"Evaluate saving and restoring the transformation state."
	cairoCanvas primSaveState.
	needsTranslation ifTrue: [
		cairoCanvas primTranslateX: aPoint x y: aPoint y ].
	needsTransformation ifTrue: [
		cairoCanvas primApplyTransform: (AthensCairoMatrix fromSpartaMatrix: aMatrix) ].
	aBlock value.
	cairoCanvas primRestoreState.

]

{ #category : #rendering }
PCRenderer >> renderSpace: aBlSpace [

	"TODO use: cairoSurface privContext instead of drawDuring: to avoid redundant overhead.
	cairoCanvas := cairoSurface privContext.
	...
	cairoSurface flush.
	"

	cairoSurface drawDuring: [  :aCairoCanvas |
		cairoCanvas := aCairoCanvas.
		aBlSpace root pureCairoDrawOn: self ].

	^ #()
]

{ #category : #rendering }
PCRenderer >> renderSurface: aPCRenderer damaged: aCollection [ 

	hostSpace morphicWindow form: cairoSurface asForm
]

{ #category : #accessing }
PCRenderer >> scaleFactor [

	^ 1.0
]

{ #category : #visiting }
PCRenderer >> setSourceColor: aColor [

	aColor isTranslucent
		ifTrue: [
			cairoCanvas
				primSetSourceR: aColor red
				g: aColor green
				b: aColor blue
				a: aColor alpha ]
		ifFalse: [
			cairoCanvas
				primSetSourceR: aColor red
				g: aColor green
				b: aColor blue ]

]

{ #category : #testing }
PCRenderer >> shouldUpdateEveryFrame [

	^ true
]
