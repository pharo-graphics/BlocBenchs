Class {
	#name : #BlKeysCursorMoveTextEditorProfileCase,
	#superclass : #BlTextEditorProfileCase,
	#category : #'BlocBenchs-Old-ProfileCases'
}

{ #category : #hooks }
BlKeysCursorMoveTextEditorProfileCase >> defaultLapseToWait [

	^ 100 milliSeconds
]

{ #category : #hooks }
BlKeysCursorMoveTextEditorProfileCase >> dispatchEvent [
	
	| key time |
	key := KeyboardKey right.
	time := DateAndTime now.
	{ 	BlKeyDownEvent new key: key; timestamp: time; yourself.
		BlKeyUpEvent new key: key; timestamp: time; yourself }
			do: [ :anEvent |
				editorElement space dispatchEvent: anEvent ]
]
