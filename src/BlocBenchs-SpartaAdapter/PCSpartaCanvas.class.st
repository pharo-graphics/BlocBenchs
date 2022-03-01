Class {
	#name : #PCSpartaCanvas,
	#superclass : #SpartaCanvas,
	#instVars : [
		'pureCairoCanvas',
		'session'
	],
	#category : #'BlocBenchs-SpartaAdapter'
}

{ #category : #geometry }
PCSpartaCanvas class >> extent: anExtent [

	^ self new initializeWith: (PCCanvas extent: anExtent)
]

{ #category : #accessing }
PCSpartaCanvas >> flush [
	
	pureCairoCanvas flush
]

{ #category : #'drawing - general' }
PCSpartaCanvas >> fullDraw: anElement [

	anElement pureCairoDrawOn: pureCairoCanvas.

	1halt. "CONTINUE HERE"
	
	^ {pureCairoCanvas extent}
]

{ #category : #initialization }
PCSpartaCanvas >> initializeWith: aPCCanvas [ 
	
	self initialize.
	
	pureCairoCanvas := aPCCanvas.
	session := Smalltalk session
]

{ #category : #testing }
PCSpartaCanvas >> isValid [
	
	^ session == Smalltalk session
]
