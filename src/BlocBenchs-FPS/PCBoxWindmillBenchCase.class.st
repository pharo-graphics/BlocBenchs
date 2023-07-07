"
Inspired on RSAnimationExamples>>#example01BoxWindmill


"
Class {
	#name : #PCBoxWindmillBenchCase,
	#superclass : #PCBenchCase,
	#category : #'BlocBenchs-FPS-Cases'
}

{ #category : #hook }
PCBoxWindmillBenchCase >> backgroundColor [

	^ Color black
]

{ #category : #hook }
PCBoxWindmillBenchCase >> boxBorderColor [

	^ Color blue muchDarker alpha: 0.5
]

{ #category : #hook }
PCBoxWindmillBenchCase >> boxBorderWidth [

	^ 10
]

{ #category : #hook }
PCBoxWindmillBenchCase >> boxColor [

	^ Color white
]

{ #category : #hook }
PCBoxWindmillBenchCase >> boxExtent [

	^ 140 @ 40
]

{ #category : #hook }
PCBoxWindmillBenchCase >> boxPositions [
	"Answer the logical positions for the boxes"

	^ self boxPositions: 1@1
]

{ #category : #hook }
PCBoxWindmillBenchCase >> boxPositions: aDeviceScale [
	"Answer the positions for the boxes in the pixel space"
	
	^ (0 to: self logicalExtent x * aDeviceScale x by: 50 * aDeviceScale x) flatCollect: [ :x | 
		  (0 to: self logicalExtent y * aDeviceScale y by: 50 * aDeviceScale y) collect: [ :y | 
			  (x @ y) - (self boxExtent * aDeviceScale / 2) ] ]
]

{ #category : #hook }
PCBoxWindmillBenchCase >> boxRotationInDegreesWithPosition: position elapsedMS: elapsedMS [

	^ ((position x + position y + (elapsedMS/50.0) ) degreesToRadians * 1.95) radiansToDegrees
]

{ #category : #accessing }
PCBoxWindmillBenchCase >> logicalExtent [

	^ 800 asPoint
]

{ #category : #hook }
PCBoxWindmillBenchCase >> newElement [
	"Answer the Bloc element to be added to the root of the space to setup the benchmark scenario."

	| aContainerElement boxElements startMS |

	aContainerElement := BlElement new
		clipChildren: false;
		size: self logicalExtent;
		background: self backgroundColor;
		yourself.

	boxElements := self boxPositions collect: [ :eachPoint | 
		BlElement new
			outskirts: BlOutskirts centered;
			size: self boxExtent;
			background: self boxColor;
			position: eachPoint;
			border: (BlBorder
				paint: self boxBorderColor
				width: self boxBorderWidth);
			yourself  ].
	aContainerElement addChildren: boxElements.

	startMS := Time millisecondClockValue.
	aContainerElement addAnimation:
		(BlBasicAnimation new 
			onStepDo: [ :t |
				boxElements do:[ :each |
					each transformDo: [ :builder |
						builder
							centerOrigin;
							rotateBy: (self 
								boxRotationInDegreesWithPosition: each position
								elapsedMS: Time millisecondClockValue - startMS) ] ] ];
			yourself).

	^ aContainerElement
]

{ #category : #'instance creation' }
PCBoxWindmillBenchCase >> newRawSDLCairoWindow [

	^ PCBoxWindmillCompositingWindow newWith: self
]
