Class {
	#name : #PCContainsPointCalc,
	#superclass : #Object,
	#instVars : [
		'surface',
		'session',
		'cairoCanvas'
	],
	#classInstVars : [
		'instance'
	],
	#category : #'BlocBenchs-PCRenderer'
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

{ #category : #initialization }
PCContainsPointCalc >> ensureReady [

	session == Smalltalk session ifTrue: [ ^ self ].
	session := Smalltalk session.

	surface := AthensCairoSurface extent: 1@1.
	cairoCanvas := surface privContext.

]

{ #category : #'as yet unclassified' }
PCContainsPointCalc >> is: aPoint inFillOfVertices: vertices [

	vertices readStreamDo: [ :aStream |
		cairoCanvas moveTo: aStream next.
		[ aStream atEnd ] whileFalse: [ 
			cairoCanvas lineTo: aStream next	] ].

	^ cairoCanvas primInFillX: aPoint x Y: aPoint y
]

{ #category : #accessing }
PCContainsPointCalc >> surface [

	^ surface
]
