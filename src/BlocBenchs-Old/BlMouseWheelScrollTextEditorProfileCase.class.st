"
Profile case that emulates a user scrolling down using the wheel.
"
Class {
	#name : #BlMouseWheelScrollTextEditorProfileCase,
	#superclass : #BlTextEditorProfileCase,
	#category : #'BlocBenchs-Old-ProfileCases'
}

{ #category : #hooks }
BlMouseWheelScrollTextEditorProfileCase >> dispatchEvent [

	| anEvent |
	anEvent := BlMouseWheelEvent new
		timestamp: DateAndTime now;
		vector: (BlVector x: 0 y: -7);
		position: editorElement bounds inSpace center;
		yourself.
	
	editorElement space dispatchEvent: anEvent
]
