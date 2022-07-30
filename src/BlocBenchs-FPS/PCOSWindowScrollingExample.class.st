Class {
	#name : #PCOSWindowScrollingExample,
	#superclass : #OSWindowGenericRendererExample,
	#instVars : [
		'x',
		'y'
	],
	#category : #'BlocBenchs-FPS-Scrolling'
}

{ #category : #factory }
PCOSWindowScrollingExample >> createEventHandler [

	^ PCOSWindowScrollingExampleEventHandler new
		  example: self;
		  yourself
]

{ #category : #drawing }
PCOSWindowScrollingExample >> initialize [

	super initialize.
	
	x := y := 200.
]

{ #category : #private }
PCOSWindowScrollingExample >> launch [
	<script: 'self new open; inspect'>
	
	
]

{ #category : #accessing }
PCOSWindowScrollingExample >> maxFPS [

	^ 120
]

{ #category : #drawing }
PCOSWindowScrollingExample >> redraw [

	renderer
		color: Color blue;
		clear;
		color: Color orange;
		drawRectangle: (x @ y extent: 20 @ 20)
]

{ #category : #accessing }
PCOSWindowScrollingExample >> scrollHorizontal: aNumber [

	x := x + aNumber
]

{ #category : #accessing }
PCOSWindowScrollingExample >> scrollVertical: aNumber [

	y := y + aNumber
]
