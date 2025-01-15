Class {
	#name : #BlBBoxWindmillBlocCase,
	#superclass : #BlBBlocCase,
	#traits : 'TBlBBoxWindmillLogic',
	#classTraits : 'TBlBBoxWindmillLogic classTrait',
	#category : #'BlocBenchs-Benchs-Bloc'
}

{ #category : #'instance creation' }
BlBBoxWindmillBlocCase >> newElement [
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
