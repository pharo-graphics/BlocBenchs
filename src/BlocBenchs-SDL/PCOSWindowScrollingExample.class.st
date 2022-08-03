Class {
	#name : #PCOSWindowScrollingExample,
	#superclass : #OSWindowGenericRendererExample,
	#instVars : [
		'x',
		'y',
		'xAxis',
		'yAxis',
		'timeMS',
		'lastMS'
	],
	#category : #'BlocBenchs-SDL-Scrolling'
}

{ #category : #drawing }
PCOSWindowScrollingExample >> beFlatScrolling [

	xAxis := PCFlatScrollingAxis new.
	yAxis := PCFlatScrollingAxis new
]

{ #category : #drawing }
PCOSWindowScrollingExample >> beInertialScrolling [

	xAxis := PCInertialScrollingAxis new.
	yAxis := PCInertialScrollingAxis new
]

{ #category : #factory }
PCOSWindowScrollingExample >> createEventHandler [

	^ PCOSWindowScrollingExampleEventHandler new
		  example: self;
		  yourself
]

{ #category : #drawing }
PCOSWindowScrollingExample >> initialize [

	super initialize.
	
	x := self defaultExtent x // 2.
	y := self defaultExtent y // 2.
	lastMS := Time millisecondClockValue.
]

{ #category : #accessing }
PCOSWindowScrollingExample >> maxFPS [

	^ 120
]

{ #category : #accessing }
PCOSWindowScrollingExample >> mouseWheelEvent: anEvent [

	| deltaMS |

	"The event has no timestamp!"
	timeMS := Time millisecondClockValue.
	deltaMS := timeMS - lastMS.
	xAxis
		millsecondsPassed: deltaMS
		onScroll: anEvent scrollHorizontal
		do: [ :delta | x := x - delta ].
	yAxis
		millsecondsPassed: deltaMS
		onScroll: anEvent scrollVertical
		do: [ :delta | y := y - delta ].
	lastMS := timeMS
]

{ #category : #private }
PCOSWindowScrollingExample >> openFlatScrolling [
	<script: 'self new beFlatScrolling; open; inspect'>

]

{ #category : #private }
PCOSWindowScrollingExample >> openInertialScrolling [
	<script: 'self new beInertialScrolling; open; inspect'>

]

{ #category : #drawing }
PCOSWindowScrollingExample >> redraw [

	| deltaMS |
	timeMS := Time millisecondClockValue.
	deltaMS := timeMS - lastMS.
	xAxis millsecondsPassed: deltaMS do: [ :delta | x := x - delta ].
	yAxis millsecondsPassed: deltaMS do: [ :delta | y := y - delta ].
	lastMS := timeMS.

	renderer
		color: Color blue;
		clear;
		color: Color orange;
		drawRectangle: (x @ y extent: 10 @ 10)
]
