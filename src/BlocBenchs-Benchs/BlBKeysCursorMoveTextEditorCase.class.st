"
Profile case that emulates a user pressing down arrow repeated times.
"
Class {
	#name : #BlBKeysCursorMoveTextEditorCase,
	#superclass : #BlBAbstractTextEditorCase,
	#category : #'BlocBenchs-Benchs-Bloc'
}

{ #category : #hooks }
BlBKeysCursorMoveTextEditorCase >> defaultLapseToWait [

	^ 100 milliSeconds
]

{ #category : #accessing }
BlBKeysCursorMoveTextEditorCase >> defaultNumberOfSimulatedEvents [

	^ 40
]

{ #category : #hooks }
BlBKeysCursorMoveTextEditorCase >> dispatchEvent [
	
	| key |
	key := KeyboardKey down.
	
	{ BlKeyDownEvent new. BlKeyUpEvent new } do: [ :anEvent |
		anEvent key: key.
		'aaa' traceCr.
		MorphicRenderLoop new doOneCycle.
		editorElement space dispatchEventWithTimestamp: anEvent ]
]
