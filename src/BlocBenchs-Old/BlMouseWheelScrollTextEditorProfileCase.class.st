"
Profile case that emulates a user scrolling down using the wheel.
"
Class {
	#name : #BlMouseWheelScrollTextEditorProfileCase,
	#superclass : #BlTextEditorProfileCase,
	#category : #'BlocBenchs-Old-ProfileCases'
}

{ #category : #examples }
BlMouseWheelScrollTextEditorProfileCase class >> example [
	
	[ 	| case |
		case := self new
			hostClass: BlOSWindowSDL2Host;
			yourself.

		(BlProfileRunner newForCase: case)
			enableASProfiler;
			run;
			openMeterReports ] fork
]

{ #category : #hooks }
BlMouseWheelScrollTextEditorProfileCase >> dispatchEvent [

	| anEvent |
	anEvent := BlMouseWheelEvent new
		timestamp: editorElement space time now;
		vector: (BlVector x: 0 y: -7);
		position: editorElement bounds inSpace center;
		yourself.
	
	editorElement space dispatchEvent: anEvent
]
