"
Profile case that emulates a user pressing down arrow repeated times.
"
Class {
	#name : #BlKeysCursorMoveTextEditorProfileCase,
	#superclass : #BlTextEditorProfileCase,
	#category : #'BlocBenchs-Old-ProfileCases'
}

{ #category : #examples }
BlKeysCursorMoveTextEditorProfileCase class >> example [
	
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
BlKeysCursorMoveTextEditorProfileCase >> defaultLapseToWait [

	^ 100 milliSeconds
]

{ #category : #accessing }
BlKeysCursorMoveTextEditorProfileCase >> defaultNumberOfSimulatedEvents [

	^ 40
]

{ #category : #hooks }
BlKeysCursorMoveTextEditorProfileCase >> dispatchEvent [
	
	| key time |
	key := KeyboardKey down.
	time := editorElement space time now.
	{ BlKeyDownEvent new. BlKeyUpEvent new }
		do: [ :anEvent |
			anEvent
				key: key;
				timestamp: time.
			editorElement space dispatchEvent: anEvent ]
]
