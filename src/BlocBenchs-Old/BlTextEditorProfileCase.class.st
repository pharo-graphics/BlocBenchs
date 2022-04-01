"
I'm a profiling case where a text editor is scrolled down multiple times.
"
Class {
	#name : #BlTextEditorProfileCase,
	#superclass : #BlProfileCase,
	#instVars : [
		'editorElement',
		'numberOfScrollDowns',
		'lapseToWaitBetween'
	],
	#category : #'BlocBenchs-Old-ProfileCases'
}

{ #category : #hooks }
BlTextEditorProfileCase >> executeBody [ 

	self lapseToWaitBetween wait.
	self numberOfScrollDowns timesRepeat: [ |b|
		self lapseToWaitBetween wait.
		b := [ BlSpace simulateMouseWheelOn: editorElement by: (BlVector x: 0 y: -7) ].

		self flag: #todo. "Not sure what's the best way to send the simulated event"
		BlUseAsyncFeatures 
			ifEnabledDo: [ editorElement inUIProcessDo: b ]
			otherwise: b.
"		space enqueueTask: (BlTaskAction new action: b; yourself)"
		].
	self lapseToWaitBetween wait.

]

{ #category : #accessing }
BlTextEditorProfileCase >> lapseToWaitBetween [

	^ lapseToWaitBetween ifNil: [ lapseToWaitBetween := 1 seconds ]
]

{ #category : #accessing }
BlTextEditorProfileCase >> lapseToWaitBetween: aDuration [

	lapseToWaitBetween := aDuration
]

{ #category : #hooks }
BlTextEditorProfileCase >> newElement [

	| editor |
	editor := BrTextEditor new
		text: (String loremIpsum: 20000) asRopedText;
		useSyncStylerStrategy;
		yourself.
		
	editorElement := BrEditorElement new
		editor: editor;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ];
		yourself.

	^ editorElement
]

{ #category : #accessing }
BlTextEditorProfileCase >> numberOfScrollDowns [

	^ numberOfScrollDowns ifNil: [ numberOfScrollDowns := 12 ]
]

{ #category : #accessing }
BlTextEditorProfileCase >> numberOfScrollDowns: anInteger [

	numberOfScrollDowns := anInteger
]
