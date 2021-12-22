Class {
	#name : #PCRenderer,
	#superclass : #BlHostRenderer,
	#instVars : [
		'cairoSurface',
		'hostSpace',
		'cairoCanvas',
		'shouldFill'
	],
	#category : #'BlocBenchs-PCRenderer'
}

{ #category : #visiting }
PCRenderer >> acceptBlPaintBackground: aBlPaintBackground [

	| aColor |
	aColor := aBlPaintBackground paint color.
	aColor isTranslucent
		ifTrue: [
			cairoCanvas
				primSetSourceR: aColor red
				g: aColor green
				b: aColor blue
				a: aColor alpha ]
		ifFalse: [
			cairoCanvas
				primSetSourceR: aColor red
				g: aColor green
				b: aColor blue ]

]

{ #category : #visiting }
PCRenderer >> acceptBlTransparentBackground: aBlTransparentBackground [ 

	"Nothing to do"
]

{ #category : #initialization }
PCRenderer >> createFormSpaceRenderer [

	^ PCFormSpaceRenderer new
]

{ #category : #'api - drawing' }
PCRenderer >> drawCircle: topLeftPoint radius: radiusPoint [

	| center |
	center := topLeftPoint + radiusPoint.
	cairoCanvas
		primArcCenterX: center x
		centerY: center y
		radius: radiusPoint x "TODO: ellipse"
		startAngle: 0.0
		endAngle: Float twoPi;
		fill

]

{ #category : #'api - drawing' }
PCRenderer >> drawRectangle: aRectangle [

	cairoCanvas
		rectangleX: aRectangle left
		y: aRectangle top
		width: aRectangle width
		height: aRectangle height;
		fill
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
	cairoSurface := AthensCairoSurface extent: aBlHostSpace physicalSize asPoint.

	textMeasurer := BlMockedTextMeasurer new
		ascent: -10;
		descent: 5;
		glyphWidth: 10;
		height: 15;
		yourself

]

{ #category : #'api - updates' }
PCRenderer >> performUpdates [


]

{ #category : #'host space - geometry' }
PCRenderer >> physicalSize [

	^ cairoSurface extent asPhysicalSize
]

{ #category : #rendering }
PCRenderer >> renderSpace: aBlSpace [

	"TODO use: cairoSurface privContext instead of drawDuring: to avoid redundant overhead.
	cairoCanvas := cairoSurface privContext.
	...
	cairoSurface flush.
	"

	cairoSurface drawDuring: [  :aCairoCanvas |
		cairoCanvas := aCairoCanvas.
		aBlSpace root pureCairoDrawOn: self ].

	^ #()
]

{ #category : #rendering }
PCRenderer >> renderSurface: aPCRenderer damaged: aCollection [ 

	hostSpace morphicWindow form: cairoSurface asForm
]

{ #category : #accessing }
PCRenderer >> scaleFactor [

	^ 1.0
]

{ #category : #testing }
PCRenderer >> shouldUpdateEveryFrame [

	^ true
]
