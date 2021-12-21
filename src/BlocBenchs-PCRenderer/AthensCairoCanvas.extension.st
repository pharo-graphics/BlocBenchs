Extension { #name : #AthensCairoCanvas }

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
AthensCairoCanvas >> primSetSourceR: red g: green b: blue [
	^ self ffiCall: #( 
		void cairo_set_source_rgb ( self ,
			double red,
			double green,
			double blue) )
]
