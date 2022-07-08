Class {
	#name : #PCBenchCaseRawSDLCairoWindow,
	#superclass : #PCRawSDLCairoWindow,
	#instVars : [
		'case',
		'frameCount',
		'lastMS',
		'startMS',
		'deltaMS',
		'random'
	],
	#category : #'BlocBenchs-FPS-Raw'
}

{ #category : #'instance creation' }
PCBenchCaseRawSDLCairoWindow class >> newWith: aPCBenchCase [

	^ self basicNew
		  initializeWith: aPCBenchCase;
		  yourself
]

{ #category : #hook }
PCBenchCaseRawSDLCairoWindow >> elapsedTimeSinceFirstDraw [

	^ (lastMS - startMS) milliSeconds
]

{ #category : #accessing }
PCBenchCaseRawSDLCairoWindow >> frameCount [

	^ frameCount
]

{ #category : #accessing }
PCBenchCaseRawSDLCairoWindow >> initializeWith: aPCBenchCase [

	self initialize.
	
	case := aPCBenchCase.

]

{ #category : #'instance creation' }
PCBenchCaseRawSDLCairoWindow >> open [

	self
		openWithTitle: case label
		position: 30 asPoint "Reserve space for the title bar"
		extent: case logicalExtent
]

{ #category : #accessing }
PCBenchCaseRawSDLCairoWindow >> resetAnimation [
	"Prepare to start drawing the animation from the biggining.
	Subclasses can assume that Cairo and SDL surfaces are initialized."

	frameCount := 0.

	startMS := Time millisecondClockValue.
	deltaMS := 0.0.
	lastMS := startMS.

	random := case newRandom.

]

{ #category : #accessing }
PCBenchCaseRawSDLCairoWindow >> resetMainTexture [

	super resetMainTexture.
	
	self resetAnimation.
]

{ #category : #hook }
PCBenchCaseRawSDLCairoWindow >> step [

	| currentMS |
	frameCount := frameCount + 1.
	
	currentMS := Time millisecondClockValue.
	deltaMS := currentMS - lastMS.
	lastMS := currentMS.
	
	super step.

]
