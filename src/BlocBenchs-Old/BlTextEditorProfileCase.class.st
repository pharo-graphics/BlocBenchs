"
I'm a profiling case where a text editor is scrolled down multiple times.
"
Class {
	#name : #BlTextEditorProfileCase,
	#superclass : #BlProfileCase,
	#instVars : [
		'editorElement',
		'lapseToWaitBetween',
		'numberOfSimulatedEvents'
	],
	#category : #'BlocBenchs-Old-ProfileCases'
}

{ #category : #accessing }
BlTextEditorProfileCase >> defaultLapseToWait [

	^ 0.5 seconds
]

{ #category : #accessing }
BlTextEditorProfileCase >> defaultNumberOfSimulatedEvents [

	^ 15
]

{ #category : #hooks }
BlTextEditorProfileCase >> dispatchEvent [

	self subclassResponsibility
]

{ #category : #API }
BlTextEditorProfileCase >> executeBody [ 

	| task semaphore |
	semaphore := Semaphore new.
	task := BlRepeatedTaskAction new.
	task delay: self lapseToWaitBetween.
	task action: [
		self dispatchEvent.
		semaphore signal ].
	space enqueueTask: task.

	"Make this process wait until all events have been dispatched"
	self numberOfSimulatedEvents timesRepeat: [ semaphore wait ].
	task stop.
	
	"Wait a bit more so the last event can be processed"
	self lapseToWaitBetween wait
]

{ #category : #accessing }
BlTextEditorProfileCase >> lapseToWaitBetween [

	^ lapseToWaitBetween ifNil: [ lapseToWaitBetween := self defaultLapseToWait ]
]

{ #category : #accessing }
BlTextEditorProfileCase >> lapseToWaitBetween: aDuration [

	lapseToWaitBetween := aDuration
]

{ #category : #hooks }
BlTextEditorProfileCase >> newElement [

	^ editorElement := ToAlbum new
		text: (String loremIpsum: 20000) asRopedText;
		withRowNumbers;
		yourself.

]

{ #category : #accessing }
BlTextEditorProfileCase >> numberOfSimulatedEvents [

	^ numberOfSimulatedEvents ifNil: [
		numberOfSimulatedEvents := self defaultNumberOfSimulatedEvents ]
]

{ #category : #accessing }
BlTextEditorProfileCase >> numberOfSimulatedEvents: anInteger [

	numberOfSimulatedEvents := anInteger
]

{ #category : #hooks }
BlTextEditorProfileCase >> spaceExtent [

	^ 500 @ 900
]
