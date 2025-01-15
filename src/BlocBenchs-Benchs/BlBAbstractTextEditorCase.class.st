"
I'm a profiling case where a text editor is scrolled down multiple times.
"
Class {
	#name : #BlBAbstractTextEditorCase,
	#superclass : #BlBBlocCase,
	#instVars : [
		'editorElement',
		'lapseToWaitBetween',
		'numberOfSimulatedEvents'
	],
	#category : #'BlocBenchs-Benchs-Bloc'
}

{ #category : #running }
BlBAbstractTextEditorCase class >> isAbstract [ 

	^ self == BlBAbstractTextEditorCase
]

{ #category : #accessing }
BlBAbstractTextEditorCase >> defaultLapseToWait [

	^ 0.5 seconds
]

{ #category : #accessing }
BlBAbstractTextEditorCase >> defaultNumberOfSimulatedEvents [

	^ 15
]

{ #category : #hooks }
BlBAbstractTextEditorCase >> dispatchEvent [

	self subclassResponsibility
]

{ #category : #accessing }
BlBAbstractTextEditorCase >> lapseToWaitBetween [

	^ lapseToWaitBetween ifNil: [ lapseToWaitBetween := self defaultLapseToWait ]
]

{ #category : #accessing }
BlBAbstractTextEditorCase >> lapseToWaitBetween: aDuration [

	lapseToWaitBetween := aDuration
]

{ #category : #hooks }
BlBAbstractTextEditorCase >> newElement [

	^ editorElement := ToAlbum new
		  text: (String loremIpsum: 20000) asRopedText;
		  withRowNumbers;
		  enqueueTask: (BlRepeatedTaskAction new
				   delay: self lapseToWaitBetween;
				   action: [ self dispatchEvent ]);
		  yourself
]

{ #category : #accessing }
BlBAbstractTextEditorCase >> numberOfSimulatedEvents [

	^ numberOfSimulatedEvents ifNil: [
		numberOfSimulatedEvents := self defaultNumberOfSimulatedEvents ]
]

{ #category : #accessing }
BlBAbstractTextEditorCase >> numberOfSimulatedEvents: anInteger [

	numberOfSimulatedEvents := anInteger
]

{ #category : #hooks }
BlBAbstractTextEditorCase >> spaceExtent [

	^ 500 @ 900
]
