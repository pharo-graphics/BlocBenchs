Extension { #name : #AthensCairoCanvas }

{ #category : #'*BlocBenchs-PCRenderer' }
AthensCairoCanvas >> lineTo: aPoint [

	^ self primLineToX: aPoint x asFloat Y: aPoint y asFloat
]

{ #category : #'*BlocBenchs-PCRenderer' }
AthensCairoCanvas >> moveTo: aPoint [

	self primMoveToX: aPoint x asFloat Y: aPoint y asFloat
]

{ #category : #'*BlocBenchs-PCRenderer' }
AthensCairoCanvas >> paintGroupWith: aBlock [

	self primPushGroup.
	aBlock value.
	self
		primPopGroupToSource;
		primPaint
]

{ #category : #'*BlocBenchs-PCRenderer' }
AthensCairoCanvas >> popGroup [

	^ self primPopGroup initialize "(autoRelease)"
]

{ #category : #'*BlocBenchs-PCRenderer' }
AthensCairoCanvas >> primAppendPath: aPath [
	^ self ffiCall: #( void cairo_append_path (self , AthensCairoPath aPath))
]

{ #category : #'*BlocBenchs-PCRenderer' }
AthensCairoCanvas >> primApplyTransform: aCairoMatrix [

	^ self ffiCall: #( void cairo_transform (
		self, AthensCairoMatrix *aCairoMatrix) )

]

{ #category : #'*BlocBenchs-PCRenderer' }
AthensCairoCanvas >> primArcCenterX: centerX centerY: centerY radius: aRadius startAngle: aStartAngle endAngle: anEndAngle [ 

	self ffiCall: #(void cairo_arc (
			self,
			double centerX,
			double centerY,
			double aRadius,
			double aStartAngle,
			double anEndAngle) )
]

{ #category : #'*BlocBenchs-PCRenderer' }
AthensCairoCanvas >> primClipPreserve [

	^ self ffiCall:
		  #( void cairo_clip_preserve #( self ) )
]

{ #category : #'*BlocBenchs-PCRenderer' }
AthensCairoCanvas >> primClosePath [

	^ self ffiCall: #(void cairo_close_path (self))
]

{ #category : #'*BlocBenchs-PCRenderer' }
AthensCairoCanvas >> primCopyPath [ 

	^ self ffiCall: #( AthensCairoPath cairo_copy_path (self) )
]

{ #category : #'*BlocBenchs-PCRenderer' }
AthensCairoCanvas >> primInFillX: x Y: y [ 

	^ self ffiCall: #(bool cairo_in_fill (
		self,
		double x,
		double y))
]

{ #category : #'*BlocBenchs-PCRenderer' }
AthensCairoCanvas >> primLineToX: aX Y: aY [
	
	^ self ffiCall: #(void cairo_line_to (
		self, 
		double aX,
		double aY ) )
]

{ #category : #'*BlocBenchs-PCRenderer' }
AthensCairoCanvas >> primLoadIdentity [

	^ self ffiCall: #(
		void cairo_identity_matrix (self) )
]

{ #category : #'*BlocBenchs-PCRenderer' }
AthensCairoCanvas >> primMask: aPattern [

	^ self ffiCall: #(void cairo_mask ( self, AthensCairoPatternPaint aPattern))
]

{ #category : #'*BlocBenchs-PCRenderer' }
AthensCairoCanvas >> primNewPath [

	^ self ffiCall: #( void cairo_new_path ( self ) )
]

{ #category : #'*BlocBenchs-PCRenderer' }
AthensCairoCanvas >> primPaintAlpha: aNumber [

	^ self ffiCall: #(void cairo_paint_with_alpha (
			self,
			double aNumber ) )
]

{ #category : #'*BlocBenchs-PCRenderer' }
AthensCairoCanvas >> primPopGroup [

	^ self ffiCall: #(AthensCairoPatternPaint cairo_pop_group ( self ) )
]

{ #category : #'*BlocBenchs-PCRenderer' }
AthensCairoCanvas >> primPopGroupToSource [

	^ self ffiCall: #(void cairo_pop_group_to_source ( self ) )
]

{ #category : #'*BlocBenchs-PCRenderer' }
AthensCairoCanvas >> primPushGroup [

	^ self ffiCall: #(void cairo_push_group ( self ) )
]

{ #category : #'*BlocBenchs-PCRenderer' }
AthensCairoCanvas >> primSetMiterLimit: aNumber [

	^ self ffiCall: #( void cairo_set_miter_limit (
		self,
      double aNumber ) )
]

{ #category : #'*BlocBenchs-PCRenderer' }
AthensCairoCanvas >> primSetSourceR: red g: green b: blue [
	^ self ffiCall: #( 
		void cairo_set_source_rgb ( self ,
			double red,
			double green,
			double blue) )
]

{ #category : #'*BlocBenchs-PCRenderer' }
AthensCairoCanvas >> primSetSourceRGBAColor: aColor [

	^ self primSetSourceR: aColor red g: aColor green b: aColor blue a: aColor alpha
]

{ #category : #'*BlocBenchs-PCRenderer' }
AthensCairoCanvas >> primSetSourceRGBColor: aColor [

	^ self primSetSourceR: aColor red g: aColor green b: aColor blue
]

{ #category : #'*BlocBenchs-PCRenderer' }
AthensCairoCanvas >> primSetSourceSurface: aCairoSurface x: aX y: aY [

	^ self ffiCall: #( void cairo_set_source_surface (
			self,
			AthensCairoSurface aCairoSurface,
			double aX,
			double aY) )
]

{ #category : #'*BlocBenchs-PCRenderer' }
AthensCairoCanvas >> primStrokePreserve [

	^ self ffiCall: #(void cairo_stroke_preserve (self))
]

{ #category : #'*BlocBenchs-PCRenderer' }
AthensCairoCanvas >> primTranslate: aPoint [

	self primTranslateX: aPoint x y: aPoint y
]

{ #category : #'*BlocBenchs-PCRenderer' }
AthensCairoCanvas >> primTranslateX: px y: py [
	
	^ self ffiCall: #(void cairo_translate (self, double px, double py))

]
