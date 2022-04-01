Class {
	#name : #PCRenderer,
	#superclass : #BlHostRenderer,
	#instVars : [
		'hostSpace',
		'pureCairoCanvas'
	],
	#category : #'BlocBenchs-PCRenderer-Host-MorphicWindow'
}

{ #category : #initialization }
PCRenderer >> createFormSpaceRenderer [

	^ PCFormSpaceRenderer new
]

{ #category : #initialization }
PCRenderer >> initializeForHostSpace: aBlHostSpace [
	"Initialize this renderer for a given host space.
	Please note, that it I be called multiple times"
	
	session := Smalltalk session.
	
	"we should mark it as a current one before initializing a canvas as it may rely on opengl context"
	aBlHostSpace makeCurrent.
	
	surface := self.
	surfaceRenderer := self.
	spaceRenderer := self.

	hostSpace := aBlHostSpace.
	pureCairoCanvas := PCCanvas extent: aBlHostSpace physicalSize asPoint.

	textMeasurer := BlMockedTextMeasurer new
]

{ #category : #'api - updates' }
PCRenderer >> performUpdates [


]

{ #category : #accessing }
PCRenderer >> physicalSize [

	^ pureCairoCanvas extent asPhysicalSize
]

{ #category : #rendering }
PCRenderer >> renderSpace: aBlSpace [

	^ pureCairoCanvas fullDraw: aBlSpace root
]

{ #category : #rendering }
PCRenderer >> renderSurface: aPCRenderer damaged: aCollection [ 

	hostSpace morphicWindow form: pureCairoCanvas asForm
]

{ #category : #accessing }
PCRenderer >> scaleFactor [

	^ 1.0
]

{ #category : #testing }
PCRenderer >> shouldUpdateEveryFrame [

	^ true
]
