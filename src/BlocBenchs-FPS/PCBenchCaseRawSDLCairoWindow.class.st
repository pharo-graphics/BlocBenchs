Class {
	#name : #PCBenchCaseRawSDLCairoWindow,
	#superclass : #PCRawSDLCairoWindow,
	#instVars : [
		'case',
		'random',
		'lastMS',
		'startMS',
		'deltaMS',
		'framesDeltaMS'
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
PCBenchCaseRawSDLCairoWindow >> elapsedMillisecondsSinceFirstDraw [

	^ lastMS - startMS
]

{ #category : #hook }
PCBenchCaseRawSDLCairoWindow >> elapsedTimeSinceFirstDraw [

	^ self elapsedMillisecondsSinceFirstDraw milliSeconds
]

{ #category : #accessing }
PCBenchCaseRawSDLCairoWindow >> frameCount [

	^ framesDeltaMS size
]

{ #category : #accessing }
PCBenchCaseRawSDLCairoWindow >> framesDeltaMS [

	^ framesDeltaMS
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

	startMS := Time millisecondClockValue.
	deltaMS := 0.0.
	lastMS := startMS.

	random := case newRandom.

	"Prepare collection for 250 frames per second"
	framesDeltaMS := OrderedCollection new: case numberOfSeconds * 250.

]

{ #category : #accessing }
PCBenchCaseRawSDLCairoWindow >> resetMainTexture [

	super resetMainTexture.
	
	self resetAnimation.
]

{ #category : #hook }
PCBenchCaseRawSDLCairoWindow >> step [

	self stepAnimation.
	super step.

]

{ #category : #hook }
PCBenchCaseRawSDLCairoWindow >> stepAnimation [

	| currentMS |
	currentMS := Time millisecondClockValue.
	deltaMS := currentMS - lastMS.
	lastMS := currentMS.

	framesDeltaMS add: deltaMS.

]
