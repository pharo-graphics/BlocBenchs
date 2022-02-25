Class {
	#name : #PCCanvas,
	#superclass : #Object,
	#instVars : [
		'cairoCanvas',
		'hasBackground',
		'hasBorder',
		'borderColor',
		'borderWidth',
		'backgroundBlock',
		'formToCairoSurfaceCache',
		'backgroundAlpha',
		'cairoSurface'
	],
	#category : #'BlocBenchs-PCRenderer'
}

{ #category : #accessing }
PCCanvas class >> extent: aPoint [

	^ self basicNew
		  initializeExtent: aPoint;
		  yourself
]

{ #category : #visiting }
PCCanvas >> acceptBlImageBackground: aBlImageBackground [ 

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
PCCanvas >> acceptBlPaintBackground: aBlPaintBackground [

	hasBackground := true.
	backgroundAlpha := 1.0.
	backgroundBlock := [
		self setSourceColor: aBlPaintBackground paint color ]

]

{ #category : #visiting }
PCCanvas >> acceptBlTransparentBackground: aBlTransparentBackground [ 

	hasBackground := false.
	backgroundAlpha := 0.0.
	backgroundBlock := nil.
]

{ #category : #visiting }
PCCanvas >> acceptColorPaintBorder: aBlColorPaint border: aBlBorder [

	hasBorder := true.
	borderColor := aBlColorPaint color.
	borderWidth := aBlBorder width.

]

{ #category : #visiting }
PCCanvas >> acceptTransparentPaintBorder: aBlElement [ 
	
	hasBorder := false.
]

{ #category : #converting }
PCCanvas >> asForm [

	^ cairoSurface asForm
]

{ #category : #'api - drawing' }
PCCanvas >> drawBackgroundAndOrStrokeWith: aBlock [

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
PCCanvas >> drawCircle: topLeftPoint radius: radiusPoint [

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
PCCanvas >> drawRectangle: aRectangle [

	self drawBackgroundAndOrStrokeWith: [
		cairoCanvas
			rectangleX: aRectangle left
			y: aRectangle top
			width: aRectangle width
			height: aRectangle height ]

]

{ #category : #'api - drawing' }
PCCanvas >> drawTriangle: thePoints [ 

	self drawBackgroundAndOrStrokeWith: [
		cairoCanvas
			moveTo: thePoints first;
			lineTo: thePoints second;
			lineTo: thePoints third;
			primClosePath ]

]

{ #category : #accessing }
PCCanvas >> extent [ 
	^ cairoSurface extent
]

{ #category : #rendering }
PCCanvas >> fullDraw: anElement [

	anElement pureCairoDrawOn: self.
	cairoSurface flush.
	
	^ #()
]

{ #category : #initialization }
PCCanvas >> initializeExtent: aPoint [

	self initialize.

	cairoSurface := AthensCairoSurface extent: aPoint.
	cairoCanvas := cairoSurface privContext.

]

{ #category : #'api - drawing' }
PCCanvas >> position: aPoint transformation: aMatrix applyDuring: aBlock [

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

{ #category : #'api - drawing' }
PCCanvas >> setSourceColor: aColor [

	aColor isTranslucent
		ifTrue: [ self setSourceTranslucentColor: aColor ]
		ifFalse: [ self setSourceSolidColor: aColor ]
]

{ #category : #'api - drawing' }
PCCanvas >> setSourceSolidColor: aColor [

	cairoCanvas primSetSourceR: aColor red g: aColor green b: aColor blue
]

{ #category : #'api - drawing' }
PCCanvas >> setSourceTranslucentColor: aColor [

	cairoCanvas
		primSetSourceR: aColor red
		g: aColor green
		b: aColor blue
		a: aColor alpha
]
