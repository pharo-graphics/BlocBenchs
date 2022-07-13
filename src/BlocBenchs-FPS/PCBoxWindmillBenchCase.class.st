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

	^ Color green muchDarker
]

{ #category : #hook }
PCBoxWindmillBenchCase >> boxBorderWidth [

	^ 1
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
PCBoxWindmillBenchCase >> boxRotationInDegreesWithPosition: position frame: frameCount [

	^ ((position x + position y + frameCount) degreesToRadians * 1.95) radiansToDegrees
]

{ #category : #accessing }
PCBoxWindmillBenchCase >> logicalExtent [

	^ 900 asPoint
]

{ #category : #hook }
PCBoxWindmillBenchCase >> newElement [
	"Answer the Bloc element to be added to the root of the space to setup the benchmark scenario."

	| aContainerElement boxElements frameCount |

	aContainerElement := BlElement new
		clipChildren: false;
		size: self logicalExtent;
		background: self backgroundColor;
		yourself.

	boxElements := self boxPositions collect: [ :eachPoint | 
		BlElement new
			size: self boxExtent;
			background: self boxColor;
			relocate: eachPoint;
			border: (BlBorder
				paint: self boxBorderColor
				width: self boxBorderWidth);
			yourself  ].
	aContainerElement addChildren: boxElements.

	frameCount := 0.
	aContainerElement addAnimation:
		(BlBasicAnimation new 
			onStepDo: [ :t |
				boxElements do:[ :each |
					each transformDo: [ :builder |
						builder
							centerOrigin;
							rotateBy: (self 
								boxRotationInDegreesWithPosition: each position
								frame: frameCount) ] ].
				frameCount := frameCount + 1 ];
			yourself).

	^ aContainerElement
]

{ #category : #'instance creation' }
PCBoxWindmillBenchCase >> newRawSDLCairoWindow [

	^ PCBoxWindmillCompositingWindow newWith: self
]
