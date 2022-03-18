Class {
	#name : #PCCairoSurfaceForm,
	#superclass : #Form,
	#instVars : [
		'surface'
	],
	#category : #'BlocBenchs-PCRenderer-CairoFFI'
}

{ #category : #'as yet unclassified' }
PCCairoSurfaceForm >> isNull [

	^ false
]

{ #category : #accessing }
PCCairoSurfaceForm >> surface [
	^ surface
]

{ #category : #accessing }
PCCairoSurfaceForm >> surface: anObject [
	surface := anObject
]
