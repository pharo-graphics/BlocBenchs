Class {
	#name : #BlHostRendererNullSurface,
	#superclass : #BlHostRendererSurface,
	#instVars : [
		'externalForm'
	],
	#category : #'BlocBenchs-NullRenderer'
}

{ #category : #testing }
BlHostRendererNullSurface class >> supportedBy: aHost [
	"Return true if a given object supports this surface, false otherwise"
	<return: #Boolean>
	
	^ aHost isKindOf: BlMorphicWindowHostNullRenderer
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
