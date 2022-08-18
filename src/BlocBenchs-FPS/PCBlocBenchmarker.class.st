"
I'm a benchmarker for Bloc renderers, always in a Morphic Window host.

"
Class {
	#name : #PCBlocBenchmarker,
	#superclass : #PCBenchmarker,
	#instVars : [
		'space',
		'firstMS',
		'lastMS',
		'framesDeltaMS'
	],
	#category : #'BlocBenchs-FPS-Benchmarkers'
}

{ #category : #hook }
PCBlocBenchmarker >> closeWindow [

	space close
]

{ #category : #hook }
PCBlocBenchmarker >> elapsedTimeSinceFirstDraw [

	^ (Time millisecondClockValue - firstMS) milliSeconds
]

{ #category : #hook }
PCBlocBenchmarker >> frameCount [
	
	^ framesDeltaMS size
]

{ #category : #hook }
PCBlocBenchmarker >> framesDeltaMS [
	
	^ framesDeltaMS
]

{ #category : #hook }
PCBlocBenchmarker >> host [

	^ self subclassResponsibility
]

{ #category : #hook }
PCBlocBenchmarker >> openWindow [

	space := BlSpace new
		host: self host;
		title: self labelWithCase;
		extent: case logicalExtent;
		yourself.

	space addChild: case newElement.

	"For each frame, register the elapsed time."
	"Prepare collection for 250 frames per second"
	framesDeltaMS := OrderedCollection new: case numberOfSeconds * 250.
	space addEventHandlerOn: BlSpaceRenderEndEvent do: [ :evt |
		| currentMS deltaMS |
		currentMS := Time millisecondClockValue.
		deltaMS := currentMS - lastMS.
		framesDeltaMS add: deltaMS.
		lastMS := currentMS ].

	"Let's consider that start happens when the space is actually shown."
	space addEventHandlerOn: BlSpaceShownEvent do: [ :evt |
		firstMS := Time millisecondClockValue.
		lastMS := firstMS. ].

	space show.

]
