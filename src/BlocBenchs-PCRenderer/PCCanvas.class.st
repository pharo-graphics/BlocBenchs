Class {
	#name : #PCCanvas,
	#superclass : #Object,
	#instVars : [
		'cairoCanvas',
		'hasBackground',
		'hasBorder',
		'borderColor',
		'borderWidth',
		'formToCairoSurfaceCache',
		'backgroundAlpha',
		'cairoSurface',
		'backgroundSourceBlock',
		'borderStyle',
		'dashesArrayToFloatArray'
	],
	#category : #'BlocBenchs-PCRenderer-Core'
}

{ #category : #accessing }
PCCanvas class >> extent: aPoint [

	^ self basicNew
		  initializeExtent: aPoint;
		  yourself
]

{ #category : #accessing }
PCCanvas class >> new [

	^ self shouldNotImplement
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
	
	backgroundSourceBlock := [ 
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
	backgroundSourceBlock := [
		self setSourceColor: aBlPaintBackground paint color ]

]

{ #category : #visiting }
PCCanvas >> acceptBlTransparentBackground: aBlTransparentBackground [ 

	hasBackground := false.
	backgroundAlpha := 0.0.
	backgroundSourceBlock := nil.
]

{ #category : #visiting }
PCCanvas >> acceptColorPaintBorder: aBlColorPaint border: aBlBorder [

	borderColor := aBlColorPaint color.
	borderWidth := aBlBorder width * 2. "Imitate BlOutskirtsOutside>>#drawBorder:onSpartaCanvas:of:"

	"Try to save time if border will not be visible"
	hasBorder := (borderColor isTransparent not and: [ borderWidth isZero not ]).
	hasBorder ifFalse: [ ^self ].

	borderStyle := aBlBorder style.

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
		backgroundSourceBlock value.
		
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

	"hasBorder is true"
	self setStrokeParameters.
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
PCCanvas >> drawPolygon: thePoints [

	self drawBackgroundAndOrStrokeWith: [ 
		thePoints do: [ :each | cairoCanvas lineTo: each ].
		cairoCanvas primClosePath ]
]

{ #category : #'api - drawing' }
PCCanvas >> drawPolyline: thePoints [

	self drawBackgroundAndOrStrokeWith: [ 
		thePoints do: [ :each | cairoCanvas lineTo: each ]
		"TODO: only set line cap in cases like this, when path is open"
		 ]
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
PCCanvas >> flush [

	cairoSurface flush
]

{ #category : #rendering }
PCCanvas >> fullDraw: anElement [

	anElement pureCairoDrawOn: self.
	self flush.
	
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

	"TODO: The default source pattern is opaque black, (that is, it is equivalent to cairo_set_source_rgba(cr, 0.0, 0.0, 0.0, 1.0))."
"	aColor isBlack ifTrue: [ ^ self ]."

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

{ #category : #'api - drawing' }
PCCanvas >> setStrokeDashes [

	"TODO: do not initialize here, and reset on new session"	
	| dashArray |
	
	arrayToDashesBuf ifNil: [
		arrayToDashesBuf := LRUCache new
			maximumWeight: 400;
			factory: [ :anArray |
				| buf |
				buf := ByteArray new: 8 * anArray size.
				anArray withIndexDo: [ :len :i |
					buf doubleAt: (i-1) * 8 + 1 put: len asFloat ].
				buf ];
			yourself ].

	dashArray := borderStyle dashArray.

	cairoCanvas
		primSetDashesLengths: (arrayToDashesBuf at: dashArray)
		count: dashArray size
		offset: borderStyle dashOffset

]

{ #category : #'api - drawing' }
PCCanvas >> setStrokeParameters [

	self setSourceColor: borderColor.
	
	"TODO: In cairo, the default line width value is 2.0. Place a if?"
	cairoCanvas primSetLineWidth: borderWidth.

	borderStyle dashArray ifNotEmpty: [ self setStrokeDashes ].

]
