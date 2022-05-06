Class {
	#name : #PCHeadlessHostSpace,
	#superclass : #Object,
	#instVars : [
		'canvas'
	],
	#category : #'BlocBenchs-FPS-Host-Headless'
}

{ #category : #converting }
PCHeadlessHostSpace >> asForm [
	"Useful for debugging"

	^ canvas asForm	
]

{ #category : #private }
PCHeadlessHostSpace >> ensureCanvas [

	canvas ifNil:[
		canvas := AeCanvas extent: self extentAsPoint ]

]

{ #category : #private }
PCHeadlessHostSpace >> extentAsPoint [

	^ 500 asPoint
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
	
	^ self extentAsPoint asLogicalSize
]

{ #category : #testing }
PCHeadlessHostSpace >> needsRebuild [

	^ false
]

{ #category : #rendering }
PCHeadlessHostSpace >> render: aBlSpace [ 

	self ensureCanvas.
	canvas fullDraw: aBlSpace root.

]

{ #category : #'host space - rendering' }
PCHeadlessHostSpace >> requestRedraw [

	
]

{ #category : #'host space - displaying' }
PCHeadlessHostSpace >> show [

]

{ #category : #'host space - geometry' }
PCHeadlessHostSpace >> windowExtent: aPoint [ 

]
