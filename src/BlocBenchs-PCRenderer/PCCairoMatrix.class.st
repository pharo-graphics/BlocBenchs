Class {
	#name : #PCCairoMatrix,
	#superclass : #FFIExternalStructure,
	#traits : 'PCTCairoLibrary',
	#classTraits : 'PCTCairoLibrary classTrait',
	#classVars : [
		'OFFSET_SHX',
		'OFFSET_SHY',
		'OFFSET_SX',
		'OFFSET_SY',
		'OFFSET_X',
		'OFFSET_Y'
	],
	#pools : [
		'PCCairoDefinitions'
	],
	#category : #'BlocBenchs-PCRenderer-CairoFFI'
}

{ #category : #'field definition' }
PCCairoMatrix class >> fieldsDesc [
	"self rebuildFieldAccessors"
	^ #(
   double sx; double shx;
   double shy; double sy;
   double x; double y;
	)
]

{ #category : #'as yet unclassified' }
PCCairoMatrix class >> fromSpartaMatrix: aSpartaMatrix [

	^ self new
		  initx: aSpartaMatrix x
		  y: aSpartaMatrix y
		  sx: aSpartaMatrix sx
		  sy: aSpartaMatrix sy
		  shx: aSpartaMatrix shx
		  shy: aSpartaMatrix shy;
		  yourself
]

{ #category : #transformations }
PCCairoMatrix >> clearTranslation [
	"reset a translation from matrix, leaving only scale and rotation"
	
	self x: 0.
	self y: 0.
]

{ #category : #copying }
PCCairoMatrix >> copy [
	^ self class new loadAffineTransform: self
]

{ #category : #private }
PCCairoMatrix >> copyFromMatrix: m [
	self assert: [ m getHandle ~= self getHandle ].
	LibC memCopy: m getHandle to: self getHandle size: self class byteSize
]

{ #category : #initialization }
PCCairoMatrix >> initialize [

	super initialize.
	self loadIdentity
]

{ #category : #private }
PCCairoMatrix >> initx: x y: y sx: sx sy: sy shx: shx shy: shy [
	^ self ffiCall: #(
		void cairo_matrix_init ( self,
			double sx,
			double shy,
			double shx,
			double sy,
			double x,
			double y))
]

{ #category : #transformations }
PCCairoMatrix >> inverseTransform: aPoint [ 

	^ self inverted transform: aPoint
]

{ #category : #transformations }
PCCairoMatrix >> invert [
	^self ffiCall: #( cairo_status_t cairo_matrix_invert ( self ))
]

{ #category : #transformations }
PCCairoMatrix >> inverted [
 	| m |
	m := self copy.
	m invert.
	^ m
]

{ #category : #testing }
PCCairoMatrix >> isAffineTransform [
	^ true
]

{ #category : #testing }
PCCairoMatrix >> isIdentity [
	^ self sx = 1 and: [ self shx = 0 and: [ self x = 0 and: [
	self shy = 0 and: [ self sy = 1 and: [ self y = 0]]]]]
]

{ #category : #transformations }
PCCairoMatrix >> loadAffineTransform: m [
	self 
		initx: m x 
		y: m y 
		sx: m sx 
		sy: m sy 
		shx: m shx 
		shy: m shy
]

{ #category : #transformations }
PCCairoMatrix >> loadIdentity [
	"initialize with identity transform"
	
	self primLoadIdentity
]

{ #category : #transformations }
PCCairoMatrix >> multiplyBy: anAthensAffineTransform [
	
	self primMultiplyBy: (
		self class new loadAffineTransform: anAthensAffineTransform)
]

{ #category : #copying }
PCCairoMatrix >> postCopy [
	self setHandle: self getHandle copy.
]

{ #category : #private }
PCCairoMatrix >> primLoadIdentity [
	"initialize with identity transform"

	^ self ffiCall: #( void cairo_matrix_init_identity ( self ) )
]

{ #category : #private }
PCCairoMatrix >> primMultiplyBy: m [
	^ self ffiCall: #(void   cairo_matrix_multiply
		(self,
		PCCairoMatrix * m ,
		PCCairoMatrix * self ) )
]

{ #category : #private }
PCCairoMatrix >> primRotateByRadians: angle [
	^ self ffiCall: #(
		void cairo_matrix_rotate (self, double angle))
]

{ #category : #private }
PCCairoMatrix >> primScaleX: fx Y: fy [
	^ self ffiCall: #(
		void cairo_matrix_scale (self, double fx, double fy)) 
]

{ #category : #private }
PCCairoMatrix >> primSetRotationInRadians: radians [
	^ self ffiCall: #( void cairo_matrix_init_rotate (self, double  radians))
]

{ #category : #private }
PCCairoMatrix >> primSetScaleX: x Y: y [
	^ self ffiCall: #( void cairo_matrix_init_scale (self, double  x, double  y))
]

{ #category : #private }
PCCairoMatrix >> primSetTranslateX: x Y: y [
	^ self ffiCall: #( void cairo_matrix_init_translate (self, double  x, double y))
]

{ #category : #private }
PCCairoMatrix >> primTransformX: x Y: y [
	^ self ffiCall: #( void cairo_matrix_transform_point (self, double * x, double * y))
]

{ #category : #private }
PCCairoMatrix >> primTranslateX: px Y: py [
	^ self ffiCall: #(
		void cairo_matrix_translate (self,
                                                         double px,
                                                         double py))
]

{ #category : #transformations }
PCCairoMatrix >> rotateByDegrees: angle [


	^ self rotateByRadians: angle degreesToRadians
]

{ #category : #transformations }
PCCairoMatrix >> rotateByRadians: angle [

	^ self primRotateByRadians: angle asFloat.
]

{ #category : #transformations }
PCCairoMatrix >> scaleBy: factor [

	"if factor is number, do a uniform scale, 
	if not, then factor is assument to be an instance of Point containing non-uniform scale for each axis"
	factor isPoint 
		ifTrue: [ self scaleX: factor x asFloat Y: factor y asFloat ] 
		ifFalse: [ self scaleX: factor asFloat Y: factor asFloat ]
]

{ #category : #transformations }
PCCairoMatrix >> scaleX: fx Y: fy [
	
	^ self primScaleX: fx asFloat Y: fy asFloat
]

{ #category : #transformations }
PCCairoMatrix >> setRotationInRadians: radians [

	^ self primSetRotationInRadians: radians asFloat
]

{ #category : #transformations }
PCCairoMatrix >> setScaleX: x Y: y [
	
	^ self primSetScaleX: x asFloat Y: y asFloat
]

{ #category : #transformations }
PCCairoMatrix >> setTranslateX: x Y: y [

	^ self primSetTranslateX: x asFloat Y: y asFloat
]

{ #category : #'accessing - structure variables' }
PCCairoMatrix >> shx [
	"This method was automatically generated"
	^handle doubleAt: OFFSET_SHX
]

{ #category : #'accessing - structure variables' }
PCCairoMatrix >> shx: anObject [
	"This method was automatically generated"
	handle doubleAt: OFFSET_SHX put: anObject
]

{ #category : #'accessing - structure variables' }
PCCairoMatrix >> shy [
	"This method was automatically generated"
	^handle doubleAt: OFFSET_SHY
]

{ #category : #'accessing - structure variables' }
PCCairoMatrix >> shy: anObject [
	"This method was automatically generated"
	handle doubleAt: OFFSET_SHY put: anObject
]

{ #category : #'accessing - structure variables' }
PCCairoMatrix >> sx [
	"This method was automatically generated"
	^handle doubleAt: OFFSET_SX
]

{ #category : #'accessing - structure variables' }
PCCairoMatrix >> sx: anObject [
	"This method was automatically generated"
	handle doubleAt: OFFSET_SX put: anObject
]

{ #category : #'accessing - structure variables' }
PCCairoMatrix >> sy [
	"This method was automatically generated"
	^handle doubleAt: OFFSET_SY
]

{ #category : #'accessing - structure variables' }
PCCairoMatrix >> sy: anObject [
	"This method was automatically generated"
	handle doubleAt: OFFSET_SY put: anObject
]

{ #category : #transformations }
PCCairoMatrix >> transform: aPoint [
	| x y |
	x := ByteArray new: 8.
	y := ByteArray new: 8.
	x doubleAt: 1 put: aPoint x.
	y doubleAt: 1 put: aPoint y.
	self primTransformX: x Y: y.
	^ (x doubleAt: 1) @ (y doubleAt: 1)
]

{ #category : #transformations }
PCCairoMatrix >> transformRectangle: aRectangle [
	^ Rectangle encompassing: {
		self transform: aRectangle bottomLeft.
		self transform: aRectangle bottomRight.
		self transform: aRectangle topLeft.
		self transform: aRectangle topRight.
	}
]

{ #category : #transformations }
PCCairoMatrix >> transformX: xValue Y: yValue [
	| x y |
	x := ByteArray new: 8.
	y := ByteArray new: 8.
	x doubleAt: 1 put: xValue.
	y doubleAt: 1 put: yValue.
	self primTransformX: x Y: y.
	^ (x doubleAt: 1) @ (y doubleAt: 1)
]

{ #category : #transformations }
PCCairoMatrix >> translateBy: aPoint [
	self translateX: aPoint x Y: aPoint y
]

{ #category : #transformations }
PCCairoMatrix >> translateX: px Y: py [

	^ self primTranslateX: px asFloat Y: py asFloat.
]

{ #category : #'accessing - structure variables' }
PCCairoMatrix >> x [
	"This method was automatically generated"
	^handle doubleAt: OFFSET_X
]

{ #category : #'accessing - structure variables' }
PCCairoMatrix >> x: anObject [
	"This method was automatically generated"
	handle doubleAt: OFFSET_X put: anObject
]

{ #category : #'accessing - structure variables' }
PCCairoMatrix >> y [
	"This method was automatically generated"
	^handle doubleAt: OFFSET_Y
]

{ #category : #'accessing - structure variables' }
PCCairoMatrix >> y: anObject [
	"This method was automatically generated"
	handle doubleAt: OFFSET_Y put: anObject
]
