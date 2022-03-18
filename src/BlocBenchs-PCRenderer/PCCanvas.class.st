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
		'arrayToDashesBuf',
		'drawFillAndStrokeBlock',
		'cairoPaintMode',
		'hasOpaqueBackground',
		'isClosedGeometry',
		'pathBlock',
		'isPathSetAsClip'
	],
	#pools : [
		'AthensCairoDefinitions'
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

	| image |
	hasBackground := true.
	backgroundAlpha := aBlImageBackground opacity.
	image := aBlImageBackground image.
	hasOpaqueBackground := image isTranslucent not.

	"TODO: do not initialize here, and reset on new session"	
	formToCairoSurfaceCache ifNil: [
		formToCairoSurfaceCache := LRUCache new
			maximumWeight: 400;
			factory: [ :aForm | PCCairoSurface fromForm: aForm ];
			yourself ].
	
	backgroundSourceBlock := [ 
		| aCairoSurface |
		aCairoSurface := formToCairoSurfaceCache at: image.
		cairoCanvas primSetSourceSurface: aCairoSurface x: 0.0 y: 0.0.
		].

]

{ #category : #visiting }
PCCanvas >> acceptBlOutskirtsCentered: aBlOutskirtsCentered [
	
	self setWithCenteredBorder
]

{ #category : #visiting }
PCCanvas >> acceptBlOutskirtsInside: aBlOutskirtsInside [ 

	self setWithInsideBorder
]

{ #category : #visiting }
PCCanvas >> acceptBlOutskirtsOutside: aBlOutskirtsOutside [ 
	
	self setWithOutsideBorder
]

{ #category : #visiting }
PCCanvas >> acceptBlPaintBackground: aBlPaintBackground [

	hasBackground := true.
	backgroundAlpha := aBlPaintBackground opacity.
	hasOpaqueBackground := aBlPaintBackground isOpaque.
	backgroundSourceBlock := [
		self setSourceColor: aBlPaintBackground paint color ]

]

{ #category : #visiting }
PCCanvas >> acceptBlTransparentBackground: aBlTransparentBackground [ 

	hasBackground := false.
	backgroundAlpha := 0.0.
	hasOpaqueBackground := false.
	backgroundSourceBlock := nil.
]

{ #category : #visiting }
PCCanvas >> acceptColorPaintBorder: aBlColorPaint border: aBlBorder [

	borderColor := aBlColorPaint color.
	borderWidth := aBlBorder width.
	borderStyle := aBlBorder style.

	(borderColor isTransparent or: [ borderWidth isZero ]) ifTrue: [
		self setWithoutBorder ].


]

{ #category : #visiting }
PCCanvas >> acceptGeometryCircle: aGeometry element: aBlElement [

	self setPathKey: aGeometry closedWith: [
		cairoCanvas
			primArcCenterX: aGeometry origin x + aGeometry radius
			centerY: aGeometry origin y + aGeometry radius
			radius: aGeometry radius
			startAngle: 0.0
			endAngle: Float twoPi ]

]

{ #category : #visiting }
PCCanvas >> acceptGeometryPolygon: aGeometry element: aBlElement [

	self setPathKey: aGeometry closedWith: [ 
		aGeometry vertices do: [ :each | cairoCanvas lineTo: each ].
		cairoCanvas primClosePath ]
]

{ #category : #visiting }
PCCanvas >> acceptGeometryPolyline: aGeometry element: aBlElement [

	self setPathKey: aGeometry openWith: [ 
		aGeometry vertices do: [ :each | cairoCanvas lineTo: each ] ]
]

{ #category : #visiting }
PCCanvas >> acceptGeometryRectangle: aGeometry element: aBlElement [

	self setPathKey: aGeometry closedWith: [
		| aRectangle |
		aRectangle := aBlElement boundsInLocal.
		
		cairoCanvas
			rectangleX: aRectangle left
			y: aRectangle top
			width: aRectangle width
			height: aRectangle height ]

]

{ #category : #visiting }
PCCanvas >> acceptGeometryTriangle: aGeometry element: aBlElement [

	self setPathKey: aGeometry closedWith: [
		| thePoints |
		thePoints := aGeometry computeVertices.

		cairoCanvas
			moveTo: thePoints first;
			lineTo: thePoints second;
			lineTo: thePoints third;
			primClosePath ]

]

{ #category : #visiting }
PCCanvas >> acceptTransparentPaintBorder: aBlElement [ 
	
	self setWithoutBorder.
]

{ #category : #converting }
PCCanvas >> asForm [

	^ cairoSurface asForm
]

{ #category : #'api - drawing' }
PCCanvas >> drawFillAndStroke [

	drawFillAndStrokeBlock value
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

	cairoSurface := PCCairoSurface extent: aPoint.
	cairoCanvas := cairoSurface privContext.
	cairoPaintMode := AthensCairoPaintMode new canvas: cairoCanvas; yourself.
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
		cairoCanvas primTranslate: aPoint ].
	needsTransformation ifTrue: [
		cairoCanvas primApplyTransform: (PCCairoMatrix fromSpartaMatrix: aMatrix) ].
	aBlock value.
	cairoCanvas primRestoreState.

]

{ #category : #'api - drawing' }
PCCanvas >> setCapButt [

	"Do nothing as it's the default in Cairo"
	"https://www.cairographics.org/manual/cairo-cairo-t.html#cairo-set-line-cap"
]

{ #category : #'api - drawing' }
PCCanvas >> setCapRound [
	
	cairoCanvas primSetLineCap: CAIRO_LINE_CAP_ROUND
]

{ #category : #'api - drawing' }
PCCanvas >> setCapSquare [
	
	cairoCanvas primSetLineCap: CAIRO_LINE_CAP_SQUARE
]

{ #category : #'api - drawing' }
PCCanvas >> setClipChildrenDisabled [

	isPathSetAsClip ifTrue: [
		cairoCanvas resetClip.
		isPathSetAsClip := false ]
]

{ #category : #'api - drawing' }
PCCanvas >> setClipChildrenEnabled [

	isPathSetAsClip ifFalse: [ 
		pathBlock value.
		cairoCanvas primClip.
		isPathSetAsClip := true ]
]

{ #category : #'api - drawing' }
PCCanvas >> setJoinBevel [

	cairoCanvas primSetLineJoin: CAIRO_LINE_JOIN_BEVEL
]

{ #category : #'api - drawing' }
PCCanvas >> setJoinMiter: limit [
	
	"No need to set miter join as it's the default in Cairo"
	"https://www.cairographics.org/manual/cairo-cairo-t.html#cairo-set-line-join"
	
	"But we might need to set the miter limit if it's not the default"
	"https://www.cairographics.org/manual/cairo-cairo-t.html#cairo-set-miter-limit"
	limit = 10.0 ifFalse: [ 
		cairoCanvas primSetMiterLimit: limit ]

]

{ #category : #'api - drawing' }
PCCanvas >> setJoinRound [

	cairoCanvas primSetLineJoin: CAIRO_LINE_JOIN_ROUND
]

{ #category : #'api - drawing' }
PCCanvas >> setPathKey: key closedWith: aBlock [

	isClosedGeometry := true.
	isPathSetAsClip := false.
	pathBlock := aBlock

]

{ #category : #'api - drawing' }
PCCanvas >> setPathKey: key openWith: aBlock [

	isClosedGeometry := false.
	isPathSetAsClip := false.
	pathBlock := aBlock

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
	
	cairoCanvas primSetLineWidth: borderWidth.

	borderStyle dashArray ifNotEmpty: [ self setStrokeDashes ].

	borderStyle lineJoin
		pureCairoApplyTo: self
		style: borderStyle.

	isClosedGeometry ifFalse: [
		borderStyle lineCap pureCairoApplyTo: self ].

]

{ #category : #'api - drawing' }
PCCanvas >> setWithCenteredBorder [

	drawFillAndStrokeBlock := [

		pathBlock value.

		hasBackground ifTrue: [
			backgroundSourceBlock value.
			cairoCanvas
				primClipPreserve;
				primPaintAlpha: backgroundAlpha;
				resetClip ].

		self setStrokeParameters.
		cairoCanvas stroke ]

]

{ #category : #'api - drawing' }
PCCanvas >> setWithInsideBorder [

	hasBackground
		ifTrue: [ self setWithInsideBorderAndBackground ]
		ifFalse: [ self setWithInsideBorderAndNoBackground ]
]

{ #category : #'api - drawing' }
PCCanvas >> setWithInsideBorderAndBackground [

	drawFillAndStrokeBlock := [

		pathBlock value.

		backgroundSourceBlock value.
		cairoCanvas
			primClipPreserve;
			primPaintAlpha: backgroundAlpha.
		isPathSetAsClip := true.

		borderWidth := borderWidth * 2.0.
		self setStrokeParameters.
		cairoCanvas stroke.

		]

]

{ #category : #'api - drawing' }
PCCanvas >> setWithInsideBorderAndNoBackground [

	drawFillAndStrokeBlock := [

		pathBlock value.

		borderWidth := borderWidth * 2.0.
		self setStrokeParameters.
		cairoCanvas 
			primClipPreserve;
			stroke.
		isPathSetAsClip := true.

		]

]

{ #category : #'api - drawing' }
PCCanvas >> setWithOutsideBorder [

	hasBackground
		ifTrue: [
			hasOpaqueBackground
				ifTrue: [ self setWithOutsideBorderAndOpaqueBackground ]
				ifFalse: [ self setWithOutsideBorderAndTranslucentBackground ] ]
		ifFalse: [
			self setWithOutsideBorderAndNoBackground ]
	
]

{ #category : #'api - drawing' }
PCCanvas >> setWithOutsideBorderAndNoBackground [

	drawFillAndStrokeBlock := [

		pathBlock value.

		cairoCanvas paintGroupWith: [ 
			"Draw doubled border"
			borderWidth := borderWidth * 2.0.
			self setStrokeParameters.
			cairoCanvas primStrokePreserve.
			"Clear inside"
			cairoPaintMode clear.
			cairoCanvas fill ].

		 ]

]

{ #category : #'api - drawing' }
PCCanvas >> setWithOutsideBorderAndOpaqueBackground [

	drawFillAndStrokeBlock := [

		pathBlock value.

		borderWidth := borderWidth * 2.0.
		self setStrokeParameters.
		cairoCanvas primStrokePreserve.

		backgroundSourceBlock value.
		cairoCanvas
			primClip;
			primPaint.
		isPathSetAsClip := true.

		]

]

{ #category : #'api - drawing' }
PCCanvas >> setWithOutsideBorderAndTranslucentBackground [

	drawFillAndStrokeBlock := [

		pathBlock value.

		cairoCanvas paintGroupWith: [ 
			"Draw doubled border"
			borderWidth := borderWidth * 2.0.
			self setStrokeParameters.
			cairoCanvas primStrokePreserve.
			"Clear inside"
			cairoPaintMode clear.
			cairoCanvas fillPreserve ].

		backgroundSourceBlock value.
		cairoCanvas
			primClip;
			primPaintAlpha: backgroundAlpha.
		isPathSetAsClip := true.

		]

]

{ #category : #'api - drawing' }
PCCanvas >> setWithoutBorder [

	hasBackground
		ifTrue: [ self setWithoutBorderAndBackground ]
		ifFalse: [ self setWithoutBorderAndNoBackground ]
]

{ #category : #'api - drawing' }
PCCanvas >> setWithoutBorderAndBackground [
	
	drawFillAndStrokeBlock := [

		pathBlock value.
		backgroundSourceBlock value.

		cairoCanvas
			primClip;
			primPaintAlpha: backgroundAlpha.
		isPathSetAsClip := true.
		
		]

]

{ #category : #'api - drawing' }
PCCanvas >> setWithoutBorderAndNoBackground [
	
	drawFillAndStrokeBlock := [ ]

]
