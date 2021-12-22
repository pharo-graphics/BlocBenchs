Extension { #name : #AthensCairoSurface }

{ #category : #'*BlocBenchs-PCRenderer' }
AthensCairoSurface >> pureCairoAsFormExtent: aPoint [
	"Based on asForm but simplified (e.g. avoid calling FFI twice for w and h)"

 	^ Form extent: aPoint depth: 32 bits: id
]
