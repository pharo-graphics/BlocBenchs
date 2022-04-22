Class {
	#name : #PCContainsPointCalc,
	#superclass : #Object,
	#instVars : [
		'session',
		'cairoContext'
	],
	#classInstVars : [
		'instance'
	],
	#category : #'BlocBenchs-PCRenderer-Core'
}

{ #category : #accessing }
PCContainsPointCalc class >> instance [

	^ instance
		ifNil: [ instance := self new ]
		ifNotNil: [ 
		  instance
			  ensureReady;
			  yourself ]
]

{ #category : #accessing }
PCContainsPointCalc class >> resetInstance [
	<script>

	instance := nil
]

{ #category : #initialization }
PCContainsPointCalc >> ensureReady [

	| cairoSurface |
	session == Smalltalk session ifTrue: [ ^ self ].
	session := Smalltalk session.

	cairoSurface := AeCairoImageSurface extent: 1@1.
	cairoContext := AeCairoContext create: cairoSurface.

]

{ #category : #testing }
PCContainsPointCalc >> is: aPoint inFillOfVertices: vertices [

	vertices readStreamDo: [ :aStream |
		cairoContext moveTo: aStream next.
		[ aStream atEnd ] whileFalse: [ 
			cairoContext lineTo: aStream next	] ].

	^ cairoContext primInFillX: aPoint x y: aPoint y
]
