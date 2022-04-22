Class {
	#name : #AeCairoSurfaceForm,
	#superclass : #Form,
	#instVars : [
		'surface'
	],
	#category : #'BlocBenchs-CairoFFI-Form'
}

{ #category : #'as yet unclassified' }
AeCairoSurfaceForm >> isNull [

	^ false
]

{ #category : #accessing }
AeCairoSurfaceForm >> surface [
	^ surface
]

{ #category : #accessing }
AeCairoSurfaceForm >> surface: anAeCairoSurface [
	surface := anAeCairoSurface
]
