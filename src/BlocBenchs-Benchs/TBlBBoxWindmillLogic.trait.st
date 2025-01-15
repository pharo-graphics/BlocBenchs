Trait {
	#name : #TBlBBoxWindmillLogic,
	#category : #'BlocBenchs-Benchs'
}

{ #category : #model }
TBlBBoxWindmillLogic >> backgroundColor [

	^ Color black
]

{ #category : #model }
TBlBBoxWindmillLogic >> boxBorderColor [

	^ Color blue muchDarker alpha: 0.5
]

{ #category : #model }
TBlBBoxWindmillLogic >> boxBorderWidth [

	^ 10
]

{ #category : #model }
TBlBBoxWindmillLogic >> boxColor [

	^ Color white
]

{ #category : #model }
TBlBBoxWindmillLogic >> boxExtent [

	^ 140 @ 40
]

{ #category : #model }
TBlBBoxWindmillLogic >> boxPositions [
	"Answer the logical positions for the boxes"

	^ self boxPositions: 1@1
]

{ #category : #model }
TBlBBoxWindmillLogic >> boxPositions: aDeviceScale [
	"Answer the positions for the boxes in the pixel space"
	
	^ (0 to: self logicalExtent x * aDeviceScale x by: 50 * aDeviceScale x) flatCollect: [ :x | 
		  (0 to: self logicalExtent y * aDeviceScale y by: 50 * aDeviceScale y) collect: [ :y | 
			  (x @ y) - (self boxExtent * aDeviceScale / 2) ] ]
]

{ #category : #model }
TBlBBoxWindmillLogic >> boxRotationInDegreesWithPosition: position elapsedMS: elapsedMS [

	^ ((position x + position y + (elapsedMS/50.0) ) degreesToRadians * 1.95) radiansToDegrees
]

{ #category : #accessing }
TBlBBoxWindmillLogic >> logicalExtent [

	^ 800 asPoint
]
