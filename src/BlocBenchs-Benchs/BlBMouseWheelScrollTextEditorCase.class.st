"
Profile case that emulates a user scrolling down using the wheel.
"
Class {
	#name : #BlBMouseWheelScrollTextEditorCase,
	#superclass : #BlBAbstractTextEditorCase,
	#category : #'BlocBenchs-Benchs-Bloc'
}

{ #category : #hooks }
BlBMouseWheelScrollTextEditorCase >> dispatchEvent [

	| anEvent |
	anEvent := BlMouseWheelEvent new
		vector: (BlVector x: 0 y: -7);
		position: editorElement bounds inSpace center;
		yourself.
	
	editorElement space dispatchEventWithTimestamp: anEvent
]
