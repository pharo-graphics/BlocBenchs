"
I'm a profiling case where a text editor is scrolled down multiple times.
"
Class {
	#name : 'BlTextEditorProfileCase',
	#superclass : 'BlProfileCase',
	#instVars : [
		'editorElement',
		'lapseToWaitBetween',
		'numberOfSimulatedEvents'
	],
	#category : 'BlocBenchs-Old-ProfileCases',
	#package : 'BlocBenchs-Old',
	#tag : 'ProfileCases'
}

{ #category : 'accessing' }
BlTextEditorProfileCase >> defaultLapseToWait [

	^ 0.5 seconds
]

{ #category : 'accessing' }
BlTextEditorProfileCase >> defaultNumberOfSimulatedEvents [

	^ 15
]

{ #category : 'hooks' }
BlTextEditorProfileCase >> dispatchEvent [

	self subclassResponsibility
]

{ #category : 'hooks' }
BlTextEditorProfileCase >> executeBody [ 

	self lapseToWaitBetween wait.
	self numberOfSimulatedEvents timesRepeat: [ |b|
		self lapseToWaitBetween wait.
		b := [ self dispatchEvent ].

		self flag: #todo. "Not sure what's the best way to send the simulated event"
		BlUseAsyncFeatures 
			ifEnabledDo: [ editorElement inUIProcessDo: b ]
			otherwise: b.
"		space enqueueTask: (BlTaskAction new action: b; yourself)"
		].
	self lapseToWaitBetween wait.

]

{ #category : 'accessing' }
BlTextEditorProfileCase >> lapseToWaitBetween [

	^ lapseToWaitBetween ifNil: [ lapseToWaitBetween := self defaultLapseToWait ]
]

{ #category : 'accessing' }
BlTextEditorProfileCase >> lapseToWaitBetween: aDuration [

	lapseToWaitBetween := aDuration
]

{ #category : 'hooks' }
BlTextEditorProfileCase >> newElement [

	| model |
	model := ToAlbumModel new
		text: (String loremIpsum: 20000) asRopedText;
		yourself.
		
	editorElement := model onWidget.

	^ editorElement
]

{ #category : 'accessing' }
BlTextEditorProfileCase >> numberOfSimulatedEvents [

	^ numberOfSimulatedEvents ifNil: [
		numberOfSimulatedEvents := self defaultNumberOfSimulatedEvents ]
]

{ #category : 'accessing' }
BlTextEditorProfileCase >> numberOfSimulatedEvents: anInteger [

	numberOfSimulatedEvents := anInteger
]

{ #category : 'hooks' }
BlTextEditorProfileCase >> spaceExtent [

	^ 400 @ 800
]
