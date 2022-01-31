Extension { #name : #AthensCairoCanvas }

{ #category : #'*BlocBenchs-PureCairo' }
AthensCairoCanvas >> primClipPreserve [

	^ self ffiCall:
		  #( void cairo_clip_preserve #( self ) )
]
