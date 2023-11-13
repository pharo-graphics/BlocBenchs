Class {
	#name : #BlKeysCursorMoveTextEditorProfileCase,
	#superclass : #BlTextEditorProfileCase,
	#category : 'BlocBenchs-Old-ProfileCases'
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
	time := DateAndTime now.
	{ 	BlKeyDownEvent new key: key; timestamp: time; yourself.
		BlKeyUpEvent new key: key; timestamp: time; yourself }
			do: [ :anEvent |
				editorElement space dispatchEvent: anEvent ]
]
