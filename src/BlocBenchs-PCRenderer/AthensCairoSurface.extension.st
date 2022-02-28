Extension { #name : #AthensCairoSurface }

{ #category : #'*BlocBenchs-PCRenderer' }
AthensCairoSurface >> getType [
	"https://www.cairographics.org/manual/cairo-cairo-surface-t.html#cairo-surface-get-type"
	
	^ self ffiCall: #(
		uint cairo_surface_get_type ( self ) )
]

{ #category : #'*BlocBenchs-PCRenderer' }
AthensCairoSurface >> pureCairoAsFormExtent: aPoint [
	"Based on asForm but simplified (e.g. avoid calling FFI twice for w and h)"

 	^ Form extent: aPoint depth: 32 bits: id
]
