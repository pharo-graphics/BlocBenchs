"
I let Bloc elements render in a Cairo surface.

"
Class {
	#name : #PCCanvas,
	#superclass : #Object,
	#instVars : [
		'hasBackground',
		'borderColor',
		'borderWidth',
		'formToCairoSurfaceCache',
		'backgroundAlpha',
		'cairoSurface',
		'backgroundSourceBlock',
		'borderStyle',
		'arrayToDashesBuf',
		'drawFillAndStrokeBlock',
		'hasOpaqueBackground',
		'isClosedGeometry',
		'pathBlock',
		'isPathSetAsClip',
		'cairoContext',
		'pathCache'
	],
	#pools : [
		'PCCairoDefinitions'
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
		cairoContext primSetSourceSurface: aCairoSurface x: 0.0 y: 0.0.
		].

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
PCCanvas >> acceptTransparentPaintBorder: aBlElement [ 
	
	self setWithoutBorder.
]

{ #category : #private }
PCCanvas >> applyPathBlock [

	pathBlock value: cairoContext
]

{ #category : #converting }
PCCanvas >> asForm [

	^ cairoSurface asForm
]

{ #category : #API }
PCCanvas >> drawElementAlpha: aNumber with: aBlock [

	aNumber = 1.0
		ifTrue: [ cairoContext restoreAfter: aBlock ]
		ifFalse: [ cairoContext paintGroupWith: aBlock alpha: aNumber ]
]

{ #category : #API }
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
	cairoContext := cairoSurface cairoContext.

	cairoContext
		primSetTolerance: 0.5;
		setAA: CAIRO_ANTIALIAS_FAST.
]

{ #category : #API }
PCCanvas >> pathTransform: aMatrix [

	aMatrix isIdentity ifTrue: [ ^self ].
	cairoContext primApplyTransform: aMatrix
]

{ #category : #API }
PCCanvas >> pathTranslate: aPoint [

	aPoint isZero ifTrue: [ ^self ].
	cairoContext primTranslate: aPoint
]

{ #category : #API }
PCCanvas >> setCapButt [

	"Do nothing as it's the default in Cairo"
	"https://www.cairographics.org/manual/cairo-cairo-t.html#cairo-set-line-cap"
]

{ #category : #API }
PCCanvas >> setCapRound [
	
	cairoContext primSetLineCap: CAIRO_LINE_CAP_ROUND
]

{ #category : #API }
PCCanvas >> setCapSquare [
	
	cairoContext primSetLineCap: CAIRO_LINE_CAP_SQUARE
]

{ #category : #API }
PCCanvas >> setClipChildren: aBoolean [

	aBoolean
		ifTrue: [
			isPathSetAsClip ifFalse: [ 
				self applyPathBlock.
				cairoContext primClip ] ]
		ifFalse: [
			isPathSetAsClip ifTrue: [
				cairoContext resetClip ] ].
	isPathSetAsClip := aBoolean
]

{ #category : #private }
PCCanvas >> setDoubleWidth [

	borderWidth := borderWidth * 2.0
]

{ #category : #API }
PCCanvas >> setJoinBevel [

	cairoContext primSetLineJoin: CAIRO_LINE_JOIN_BEVEL
]

{ #category : #API }
PCCanvas >> setJoinMiter: limit [
	
	"No need to set miter join as it's the default in Cairo"
	"https://www.cairographics.org/manual/cairo-cairo-t.html#cairo-set-line-join"
	
	"But we might need to set the miter limit if it's not the default"
	"https://www.cairographics.org/manual/cairo-cairo-t.html#cairo-set-miter-limit"
	limit = 10.0 ifFalse: [ 
		cairoContext primSetMiterLimit: limit ]

]

{ #category : #API }
PCCanvas >> setJoinRound [

	cairoContext primSetLineJoin: CAIRO_LINE_JOIN_ROUND
]

{ #category : #API }
PCCanvas >> setOutskirtsCentered [

	drawFillAndStrokeBlock := [

		self applyPathBlock.

		hasBackground ifTrue: [
			backgroundSourceBlock value.
			cairoContext
				primClipPreserve;
				primPaintAlpha: backgroundAlpha;
				resetClip ].

		self setStrokeParameters.
		cairoContext stroke ]

]

{ #category : #API }
PCCanvas >> setOutskirtsInside [

	hasBackground
		ifTrue: [ self setWithInsideBorderAndBackground ]
		ifFalse: [ self setWithInsideBorderAndNoBackground ]
]

{ #category : #API }
PCCanvas >> setOutskirtsOutside [

	hasBackground
		ifTrue: [
			hasOpaqueBackground
				ifTrue: [ self setWithOutsideBorderAndOpaqueBackground ]
				ifFalse: [ self setWithOutsideBorderAndTranslucentBackground ] ]
		ifFalse: [
			self setWithOutsideBorderAndNoBackground ]
	
]

{ #category : #API }
PCCanvas >> setPathFor: anObject isClosed: aBoolean with: aBlock [
	"Establish how to draw the path, which can be open or closed.
	The anObject argument might serve as a cache key."

	isPathSetAsClip := false.
	isClosedGeometry := aBoolean.
	pathBlock := aBlock

]

{ #category : #private }
PCCanvas >> setSourceColor: aColor [

	"TODO: The default source pattern is opaque black, (that is, it is equivalent to cairo_set_source_rgba(cr, 0.0, 0.0, 0.0, 1.0))."
"	aColor isBlack ifTrue: [ ^ self ]."

	aColor isTranslucent
		ifTrue: [ self setSourceTranslucentColor: aColor ]
		ifFalse: [ self setSourceSolidColor: aColor ]
]

{ #category : #private }
PCCanvas >> setSourceSolidColor: aColor [

	cairoContext primSetSourceR: aColor red g: aColor green b: aColor blue
]

{ #category : #private }
PCCanvas >> setSourceTranslucentColor: aColor [

	cairoContext
		primSetSourceR: aColor red
		g: aColor green
		b: aColor blue
		a: aColor alpha
]

{ #category : #private }
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

	cairoContext
		primSetDashesLengths: (arrayToDashesBuf at: dashArray)
		count: dashArray size
		offset: borderStyle dashOffset

]

{ #category : #private }
PCCanvas >> setStrokeParameters [

	self setSourceColor: borderColor.
	
	cairoContext primSetLineWidth: borderWidth.

	borderStyle dashArray ifNotEmpty: [ self setStrokeDashes ].

	borderStyle lineJoin
		pureCairoApplyTo: self
		style: borderStyle.

	isClosedGeometry ifFalse: [
		borderStyle lineCap pureCairoApplyTo: self ].

]

{ #category : #private }
PCCanvas >> setWithInsideBorderAndBackground [

	drawFillAndStrokeBlock := [

		self applyPathBlock.

		backgroundSourceBlock value.
		cairoContext
			primClipPreserve;
			primPaintAlpha: backgroundAlpha.
		isPathSetAsClip := true.

		self
			setDoubleWidth;
			setStrokeParameters.
		cairoContext stroke.

		]

]

{ #category : #private }
PCCanvas >> setWithInsideBorderAndNoBackground [

	drawFillAndStrokeBlock := [

		self applyPathBlock.

		self
			setDoubleWidth;
			setStrokeParameters.
		cairoContext 
			primClipPreserve;
			stroke.
		isPathSetAsClip := true.

		]

]

{ #category : #private }
PCCanvas >> setWithOutsideBorderAndNoBackground [

	drawFillAndStrokeBlock := [

		self applyPathBlock.

		cairoContext paintGroupWith: [ 
			"Draw doubled border"
			self
				setDoubleWidth;
				setStrokeParameters.
			cairoContext primStrokePreserve.
			"Clear inside"
			cairoContext
				setOperatorClear;
				fill ].

		 ]

]

{ #category : #private }
PCCanvas >> setWithOutsideBorderAndOpaqueBackground [

	drawFillAndStrokeBlock := [

		self applyPathBlock.

		self
			setDoubleWidth;
			setStrokeParameters.
		cairoContext primStrokePreserve.

		backgroundSourceBlock value.
		cairoContext
			primClip;
			primPaint.
		isPathSetAsClip := true.

		]

]

{ #category : #private }
PCCanvas >> setWithOutsideBorderAndTranslucentBackground [

	drawFillAndStrokeBlock := [

		self applyPathBlock.

		cairoContext paintGroupWith: [ 
			"Draw doubled border"
			self
				setDoubleWidth;
				setStrokeParameters.
			cairoContext primStrokePreserve.
			"Clear inside"
			cairoContext
				setOperatorClear;
				fillPreserve ].

		backgroundSourceBlock value.
		cairoContext
			primClip;
			primPaintAlpha: backgroundAlpha.
		isPathSetAsClip := true.

		]

]

{ #category : #private }
PCCanvas >> setWithoutBorder [

	hasBackground
		ifTrue: [ self setWithoutBorderAndBackground ]
		ifFalse: [ self setWithoutBorderAndNoBackground ]
]

{ #category : #private }
PCCanvas >> setWithoutBorderAndBackground [
	
	drawFillAndStrokeBlock := [

		self applyPathBlock.
		backgroundSourceBlock value.

		cairoContext
			primClip;
			primPaintAlpha: backgroundAlpha.
		isPathSetAsClip := true.
		
		]

]

{ #category : #private }
PCCanvas >> setWithoutBorderAndNoBackground [
	
	drawFillAndStrokeBlock := [ ]

]
