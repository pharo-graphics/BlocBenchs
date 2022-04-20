Class {
	#name : #PCCairoContext,
	#superclass : #Object,
	#traits : 'PCTCairoLibrary',
	#classTraits : 'PCTCairoLibrary classTrait',
	#instVars : [
		'handle'
	],
	#pools : [
		'PCCairoDefinitions'
	],
	#category : #'BlocBenchs-PCRenderer-CairoFFI'
}

{ #category : #converting }
PCCairoContext class >> asExternalTypeOn: generator [
	"use handle ivar to hold my instance (cairo_t)"
	^ FFIExternalObjectType objectClass: self
]

{ #category : #private }
PCCairoContext class >> on: cairoSurface [

	^ (self primCreate: cairoSurface) surface: cairoSurface
]

{ #category : #primitives }
PCCairoContext class >> primCreate: cairoSurface [
	^ self ffiCall: #( 
		PCCairoContext cairo_create (PCCairoSurface cairoSurface) )
]

{ #category : #private }
PCCairoContext >> copyPage [
	self ffiCall: #( void cairo_copy_page (self) )
]

{ #category : #private }
PCCairoContext >> destroy [
	^ self ffiCall: #( 	void cairo_destroy (self) )
]

{ #category : #private }
PCCairoContext >> fill [
	^ self ffiCall: #(void cairo_fill (self))
]

{ #category : #drawing }
PCCairoContext >> fillPreserve [
	^ self ffiCall: #(#void #cairo_fill_preserve #(#self))
]

{ #category : #accessing }
PCCairoContext >> fillRule [
	^ self ffiCall: #( cairo_fill_rule_t cairo_get_fill_rule ( self ) )
]

{ #category : #drawing }
PCCairoContext >> fillRuleEvenOdd [
	self setFillRule: CAIRO_FILL_RULE_EVEN_ODD
]

{ #category : #accessing }
PCCairoContext >> fillRuleWinding [
	self setFillRule: CAIRO_FILL_RULE_WINDING
]

{ #category : #private }
PCCairoContext >> getCurrentPoint [

	| x y |
	"since we use pointers to floats we must create a copy of original values to not scratch them"
	x := ByteArray new: 8.
	y := ByteArray new: 8.
	self primGetCurrentPointX: x Y: y.
	^ (x doubleAt: 1)@ (y doubleAt: 1)
]

{ #category : #private }
PCCairoContext >> getScaledFont [
	"Returns the current scaled font. This object is owned by cairo. To keep a reference to it, you must call cairo_scaled_font_reference().
 "
	^ self ffiCall: #( CairoScaledFont cairo_get_scaled_font ( self ))
]

{ #category : #accessing }
PCCairoContext >> handle [
	^ handle value
]

{ #category : #'as yet unclassified' }
PCCairoContext >> lineTo: aPoint [

	^ self primLineToX: aPoint x asFloat Y: aPoint y asFloat
]

{ #category : #private }
PCCairoContext >> loadPath: aPath [
	^ self ffiCall: #( void cairo_append_path (self , AthensCairoPath aPath))
]

{ #category : #'as yet unclassified' }
PCCairoContext >> moveTo: aPoint [

	self primMoveToX: aPoint x asFloat Y: aPoint y asFloat
]

{ #category : #drawing }
PCCairoContext >> moveToX: x Y: y [
	" move command always starts a new contour "
	^ self primMoveToX: x asFloat Y: y asFloat
]

{ #category : #private }
PCCairoContext >> newPath [
	^ self ffiCall: #( void cairo_new_path ( self ) )
]

{ #category : #'as yet unclassified' }
PCCairoContext >> paintGroupWith: aBlock [

	self primPushGroup.
	aBlock value.
	self
		primPopGroupToSource;
		primPaint
]

{ #category : #'as yet unclassified' }
PCCairoContext >> paintGroupWith: aBlock alpha: aNumber [

	self primPushGroup.
	aBlock value.
	self
		primPopGroupToSource;
		primPaintAlpha: aNumber
]

{ #category : #'as yet unclassified' }
PCCairoContext >> popGroup [

	^ self primPopGroup initialize "(autoRelease)"
]

{ #category : #'as yet unclassified' }
PCCairoContext >> primAppendPath: aPath [
	^ self ffiCall: #( void cairo_append_path (self , AthensCairoPath aPath))
]

{ #category : #'as yet unclassified' }
PCCairoContext >> primApplyTransform: aCairoMatrix [

	^ self ffiCall: #( void cairo_transform (
		self, PCCairoMatrix *aCairoMatrix) )

]

{ #category : #'as yet unclassified' }
PCCairoContext >> primArcCenterX: centerX centerY: centerY radius: aRadius startAngle: aStartAngle endAngle: anEndAngle [ 

	self ffiCall: #(void cairo_arc (
			self,
			double centerX,
			double centerY,
			double aRadius,
			double aStartAngle,
			double anEndAngle) )
]

{ #category : #private }
PCCairoContext >> primClip [
	^ self ffiCall: #(void cairo_clip (self))
]

{ #category : #'as yet unclassified' }
PCCairoContext >> primClipPreserve [

	^ self ffiCall:
		  #( void cairo_clip_preserve #( self ) )
]

{ #category : #'as yet unclassified' }
PCCairoContext >> primClosePath [

	^ self ffiCall: #(void cairo_close_path (self))
]

{ #category : #'as yet unclassified' }
PCCairoContext >> primCopyPath [ 

	^ self ffiCall: #( AthensCairoPath cairo_copy_path (self) )
]

{ #category : #private }
PCCairoContext >> primDrawWithAlpha: alpha [
	^ self ffiCall: #( 
		void cairo_paint_with_alpha ( self , double alpha)
	)
]

{ #category : #private }
PCCairoContext >> primGetCurrentPointX: x Y: y [
	^ self ffiCall: #( void cairo_get_current_point (self, double * x, double * y))
]

{ #category : #private }
PCCairoContext >> primGetSource [
	^ self ffiCall: #( cairo_pattern_t cairo_get_source ( self ) )
]

{ #category : #'as yet unclassified' }
PCCairoContext >> primInFillX: x Y: y [ 

	^ self ffiCall: #(bool cairo_in_fill (
		self,
		double x,
		double y))
]

{ #category : #'as yet unclassified' }
PCCairoContext >> primLineToX: aX Y: aY [
	
	^ self ffiCall: #(void cairo_line_to (
		self, 
		double aX,
		double aY ) )
]

{ #category : #'as yet unclassified' }
PCCairoContext >> primLoadIdentity [

	^ self ffiCall: #(
		void cairo_identity_matrix (self) )
]

{ #category : #'as yet unclassified' }
PCCairoContext >> primMask: aPattern [

	^ self ffiCall: #(void cairo_mask ( self, AthensCairoPatternPaint aPattern))
]

{ #category : #private }
PCCairoContext >> primMoveToX: x Y: y [
	" move command always starts a new contour "
	^ self ffiCall: #(void cairo_move_to (self, double x, double y ) )
]

{ #category : #'as yet unclassified' }
PCCairoContext >> primNewPath [

	^ self ffiCall: #( void cairo_new_path ( self ) )
]

{ #category : #private }
PCCairoContext >> primPaint [
	"A drawing operator that paints the current source everywhere within the current clip region."
	^ self ffiCall: #(void cairo_paint (self))
]

{ #category : #'as yet unclassified' }
PCCairoContext >> primPaintAlpha: aNumber [

	^ self ffiCall: #(void cairo_paint_with_alpha (
			self,
			double aNumber ) )
]

{ #category : #'as yet unclassified' }
PCCairoContext >> primPopGroup [

	^ self ffiCall: #(AthensCairoPatternPaint cairo_pop_group ( self ) )
]

{ #category : #'as yet unclassified' }
PCCairoContext >> primPopGroupToSource [

	^ self ffiCall: #(void cairo_pop_group_to_source ( self ) )
]

{ #category : #'as yet unclassified' }
PCCairoContext >> primPushGroup [

	^ self ffiCall: #(void cairo_push_group ( self ) )
]

{ #category : #private }
PCCairoContext >> primRectangleX: x y: y width: aWidth height: aHeight [
	^ self ffiCall: #(void cairo_rectangle (self,
		 double x, double y,
		 double aWidth, double aHeight) )
]

{ #category : #private }
PCCairoContext >> primResetDashes: anOffset [
"	void                cairo_set_dash                      (cairo_t *cr,
                                                         double *dashes,
                                                         int num_dashes,
                                                         double offset);"
	^ self ffiCall: #(void cairo_set_dash (
				self,
				0,
				0,
				double anOffset) )
]

{ #category : #private }
PCCairoContext >> primRestoreState [
	^ self ffiCall: #(void cairo_restore (self))
]

{ #category : #private }
PCCairoContext >> primSaveState [
	^ self ffiCall: #(void cairo_save (self))
]

{ #category : #private }
PCCairoContext >> primSetDashesLengths2: dashesLengths count: dashesCount offset: anOffset [
	^ self ffiCall: #(void cairo_set_dash (self,
			void * dashesLengths,
			int dashesCount,
			double anOffset ) )
]

{ #category : #private }
PCCairoContext >> primSetDashesLengths: dashesLengths count: dashesCount offset: anOffset [
	^ self ffiCall: #(void cairo_set_dash (self,
			double * dashesLengths,
			int dashesCount,
			double anOffset ) )
]

{ #category : #private }
PCCairoContext >> primSetFontSize: aSize [
	"
	void                cairo_set_font_size                 (cairo_t *cr,
                                                         double size);
	"
	^ self ffiCall: #( void cairo_set_font_size (self , double aSize ))
]

{ #category : #private }
PCCairoContext >> primSetLineCap: capStyle [
	^ self ffiCall: #(void cairo_set_line_cap ( self, cairo_line_cap_t capStyle ) )
]

{ #category : #private }
PCCairoContext >> primSetLineJoin: joinStyle [
	^ self ffiCall: #(void cairo_set_line_join ( self, cairo_line_join_t joinStyle) )
]

{ #category : #private }
PCCairoContext >> primSetLineWidth: width [
	^ self ffiCall: #(void cairo_set_line_width (self, double width) )
]

{ #category : #'as yet unclassified' }
PCCairoContext >> primSetMiterLimit: aNumber [

	^ self ffiCall: #( void cairo_set_miter_limit (
		self,
      double aNumber ) )
]

{ #category : #initialization }
PCCairoContext >> primSetOperator: aCairoOperator [

	^ self ffiCall: #(void cairo_set_operator (self, cairo_operator_t aCairoOperator) )
]

{ #category : #private }
PCCairoContext >> primSetSource: aPattern [
	^ self ffiCall: #(void cairo_set_source ( self, AthensCairoPatternPaint aPattern))
]

{ #category : #'as yet unclassified' }
PCCairoContext >> primSetSourceR: red g: green b: blue [
	^ self ffiCall: #( 
		void cairo_set_source_rgb ( self ,
			double red,
			double green,
			double blue) )
]

{ #category : #private }
PCCairoContext >> primSetSourceR: red g: green b: blue a: alpha [
	^ self ffiCall: #( 
		void cairo_set_source_rgba ( self ,
			double red,
			double green,
			double blue,
			double alpha) )
]

{ #category : #'as yet unclassified' }
PCCairoContext >> primSetSourceRGBAColor: aColor [

	^ self primSetSourceR: aColor red g: aColor green b: aColor blue a: aColor alpha
]

{ #category : #'as yet unclassified' }
PCCairoContext >> primSetSourceRGBColor: aColor [

	^ self primSetSourceR: aColor red g: aColor green b: aColor blue
]

{ #category : #'as yet unclassified' }
PCCairoContext >> primSetSourceSurface: aCairoSurface x: aX y: aY [

	^ self ffiCall: #( void cairo_set_source_surface (
			self,
			PCCairoSurface aCairoSurface,
			double aX,
			double aY) )
]

{ #category : #private }
PCCairoContext >> primSetTolerance: aFloat [

	^ self ffiCall: #( void cairo_set_tolerance ( self, double aFloat ))
]

{ #category : #'as yet unclassified' }
PCCairoContext >> primStrokePreserve [

	^ self ffiCall: #(void cairo_stroke_preserve (self))
]

{ #category : #'as yet unclassified' }
PCCairoContext >> primTranslate: aPoint [

	self primTranslateX: aPoint x y: aPoint y
]

{ #category : #'as yet unclassified' }
PCCairoContext >> primTranslateX: px y: py [
	
	^ self ffiCall: #(void cairo_translate (self, double px, double py))

]

{ #category : #private }
PCCairoContext >> pushClipRect: aRectangle [
	self newPath;
		rectangleX: aRectangle left
		y: aRectangle top
		width: aRectangle width
		height: aRectangle height;
		primClip
]

{ #category : #private }
PCCairoContext >> rectangleX: x y: y width: aWidth height: aHeight [

	^ self
		  primRectangleX: x asFloat
		  y: y asFloat
		  width: aWidth asFloat
		  height: aHeight asFloat
]

{ #category : #private }
PCCairoContext >> resetClip [
	^ self ffiCall: #(void cairo_reset_clip (self))
]

{ #category : #private }
PCCairoContext >> resetDash [
	self primResetDashes: 0.0
]

{ #category : #'as yet unclassified' }
PCCairoContext >> restoreAfter: aBlock [

	self primSaveState.
	aBlock value.
	self primRestoreState
]

{ #category : #private }
PCCairoContext >> setAA: antiAlias [

	"cairo_set_antialias ()

void                cairo_set_antialias                 (cairo_t *cr,
                                                         cairo_antialias_t antialias);

Set the antialiasing mode of the rasterizer used for drawing shapes. This value is a hint, and a particular backend may or may not support a particular value. At the current time, no backend supports CAIRO_ANTIALIAS_SUBPIXEL when drawing shapes.

Note that this option does not affect text rendering, instead see cairo_font_options_set_antialias().

"
	^ self ffiCall: #(void cairo_set_antialias (self, uint antiAlias))
]

{ #category : #private }
PCCairoContext >> setClipRect: aRectOrNil [
	aRectOrNil 
		ifNil: [ self resetClip ]
		ifNotNil: [ self pushClipRect: aRectOrNil ]
]

{ #category : #initialization }
PCCairoContext >> setFillRule: aCairoFillRule [
	^ self ffiCall: #( void cairo_set_fill_rule ( self, cairo_fill_rule_t aCairoFillRule ) )
]

{ #category : #private }
PCCairoContext >> setFontMatrix: aMatrix [
	"
void                cairo_set_font_matrix               (cairo_t *cr,
                                                         const cairo_matrix_t *matrix);
	"
	^ self ffiCall: #( void cairo_set_font_matrix (self , PCCairoMatrix  * aMatrix ))
]

{ #category : #private }
PCCairoContext >> setFontSize: aSize [
	
	^ self primSetFontSize: aSize asFloat
]

{ #category : #initialization }
PCCairoContext >> setOperatorClear [
	"Set 'clear' drawing mode.
	
	Drawing under this mode will clear the surface under the shape boundaries"
	
	^ self primSetOperator: CAIRO_OPERATOR_CLEAR
]

{ #category : #initialization }
PCCairoContext >> setOperatorOver [
	"Set 'over' drawing mode. This is default paint mode.
	
	Drawing under this mode will blend source with destination color using source alpha component"
			
	^ self primSetOperator: CAIRO_OPERATOR_OVER
]

{ #category : #private }
PCCairoContext >> setPathMatrix: aMatrix [
	^ self ffiCall: #(void cairo_set_matrix (self,
			PCCairoMatrix * aMatrix) )
]

{ #category : #private }
PCCairoContext >> setScaledFont: aFont [
	"Replaces the current font face, font matrix, and font options in the cairo_t with those of the cairo_scaled_font_t. Except for some translation, the current CTM of the cairo_t should be the same as that of the cairo_scaled_font_t, which can be accessed using cairo_scaled_font_get_ctm().
 "
	^ self ffiCall: #( void cairo_set_scaled_font (self , CairoScaledFont aFont))
]

{ #category : #private }
PCCairoContext >> setSourceR: red g: green b: blue a: alpha [

	^ self
		  primSetSourceR: red asFloat
		  g: green asFloat
		  b: blue asFloat
		  a: alpha asFloat
]

{ #category : #private }
PCCairoContext >> showGlyphs: glyphs size: numGlyphs [
	"A drawing operator that generates the shape from a string of UTF-8 characters, rendered according to the current font_face, font_size (font_matrix), and font_options. "
	^ self ffiCall: #(
	
		void cairo_show_glyphs ( self ,
			void * glyphs,
			int numGlyphs) )
]

{ #category : #private }
PCCairoContext >> showPage [
	self ffiCall: #( void cairo_show_page (self) )
]

{ #category : #private }
PCCairoContext >> showText: anUTF8String [
	"A drawing operator that generates the shape from a string of UTF-8 characters, rendered according to the current font_face, font_size (font_matrix), and font_options. "
	^ self ffiCall: #(void cairo_show_text (self, char * anUTF8String ))
]

{ #category : #private }
PCCairoContext >> stroke [
	^ self ffiCall: #(void cairo_stroke (self))
]

{ #category : #private }
PCCairoContext >> text: utf8String extents: extentsObj [ 
"cairo_text_extents ()

void                cairo_text_extents                  (cairo_t *cr,
                                                         const char *utf8,
                                                         cairo_text_extents_t *extents);
"
	^ self ffiCall: #( void cairo_text_extents (self, char *utf8String, cairo_text_extents_t *extentsObj) )
]

{ #category : #drawing }
PCCairoContext >> textPath: anUTF8EncodedString [
	"A drawing operator that generates the shape from a string of UTF-8 characters, rendered according to the current font_face, font_size (font_matrix), and font_options. "
	
	^ self ffiCall: #(void cairo_text_path (self, void* anUTF8EncodedString ))
]
