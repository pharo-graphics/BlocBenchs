Class {
	#name : #BlHostRendererNullSurface,
	#superclass : #BlHostRendererSurface,
	#instVars : [
		'externalForm'
	],
	#category : #'BlocBenchs-FPS-Host-NullRenderer'
}

{ #category : #testing }
BlHostRendererNullSurface class >> supportedBy: aHost [
	"Return true if a given object supports this surface, false otherwise"
	
	^ aHost class = BlNullRendererMorphicWindowHost
]

{ #category : #initialization }
BlHostRendererNullSurface >> createSpaceRendererOn: anObject [
	<return: #BlHostSpaceRenderer>

	^ BlNullHostSpaceRenderer new
]

{ #category : #initialization }
BlHostRendererNullSurface >> createSurfaceRendererOn: aBlHostSpace [ 
	
	^ BlNullHostSurfaceRenderer new
]

{ #category : #geometry }
BlHostRendererNullSurface >> extent [
	"Return an actual extent of the underlying surface.
	Note: #extent may be different from canvas or window extents"

	^ self notYetImplemented
]
