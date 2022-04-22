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

{ #category : #initialization }
PCContainsPointCalc >> ensureReady [

	session == Smalltalk session ifTrue: [ ^ self ].
	session := Smalltalk session.

	cairoContext := AeCairoContext extent: 1@1.

]

{ #category : #testing }
PCContainsPointCalc >> is: aPoint inFillOfVertices: vertices [

	vertices readStreamDo: [ :aStream |
		cairoContext moveTo: aStream next.
		[ aStream atEnd ] whileFalse: [ 
			cairoContext lineTo: aStream next	] ].

	^ cairoContext primInFillX: aPoint x Y: aPoint y
]
