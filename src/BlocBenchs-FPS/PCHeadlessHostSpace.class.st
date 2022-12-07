Class {
	#name : #PCHeadlessHostSpace,
	#superclass : #Object,
	#instVars : [
		'canvas',
		'windowExtent',
		'space'
	],
	#category : #'BlocBenchs-FPS-Host-Headless'
}

{ #category : #converting }
PCHeadlessHostSpace >> asForm [
	"Useful for debugging"

	^ canvas asForm	
]

{ #category : #accessing }
PCHeadlessHostSpace >> canvas: aCanvas [

	canvas := aCanvas
]

{ #category : #enumerating }
PCHeadlessHostSpace >> fetchedEventsDo: aFullBlockClosure [ 

	
]

{ #category : #'host space - events' }
PCHeadlessHostSpace >> generateEvents [

	
]

{ #category : #testing }
PCHeadlessHostSpace >> hasResized [

	^ false
]

{ #category : #'host space - geometry' }
PCHeadlessHostSpace >> logicalSize [
	
	^ canvas extent asLogicalSize
]

{ #category : #testing }
PCHeadlessHostSpace >> needsRebuild [

	^ false
]

{ #category : #rendering }
PCHeadlessHostSpace >> render: aBlSpace [ 

	canvas fullDraw: aBlSpace root.

]

{ #category : #'host space - rendering' }
PCHeadlessHostSpace >> requestRedraw [

	
]

{ #category : #'host space - displaying' }
PCHeadlessHostSpace >> show [

]

{ #category : #accessing }
PCHeadlessHostSpace >> space: aBlSpace [

	space := aBlSpace
]

{ #category : #'host space - geometry' }
PCHeadlessHostSpace >> windowExtent: aPoint [

]
