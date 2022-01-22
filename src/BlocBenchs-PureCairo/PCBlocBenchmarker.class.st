"
I'm a benchmarker for Bloc renderers, always in a Morphic Window host.

"
Class {
	#name : #PCBlocBenchmarker,
	#superclass : #PCBenchmarker,
	#instVars : [
		'space',
		'frames',
		'realStartTimestamp'
	],
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #hook }
PCBlocBenchmarker >> closeWindow [

	space close
]

{ #category : #hook }
PCBlocBenchmarker >> elapsedTimeSinceFirstDraw [

	^ DateAndTime now - realStartTimestamp
]

{ #category : #hook }
PCBlocBenchmarker >> frameCount [
	
	^ frames
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
		extent: case surfaceExtent;
		yourself.

	space addChild: case newElement.

	"Counting frames"
	frames := 0.
	space addEventHandlerOn: BlSpaceRenderEndEvent do: [ :evt | 
		frames := frames + 1 ].

	"Let's consider that start happens when the space is actually shown."
	space addEventHandlerOn: BlSpaceShownEvent do: [ :evt |
		realStartTimestamp := DateAndTime now ].

	space show.

]
