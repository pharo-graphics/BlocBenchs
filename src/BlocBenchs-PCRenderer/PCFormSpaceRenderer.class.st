Class {
	#name : #PCFormSpaceRenderer,
	#superclass : #Object,
	#category : #'BlocBenchs-PCRenderer'
}

{ #category : #initialization }
PCFormSpaceRenderer >> initializeForSurface: aBlHostRendererFormSurface [ 


"
	^ (self class environment at: #SpartaCairoCanvas)
		createForData: aRendererSurface pointer
		extent: aRendererSurface extent
		stride: aRendererSurface stride
		format: (self class environment at: #SpartaCairoSurfaceFormat) CAIRO_FORMAT_ARGB32	"
]

{ #category : #rendering }
PCFormSpaceRenderer >> renderSpace: aBlSpace [
	"Render a space and return a collection of damaged rectangles"
	
	^ #()
]
