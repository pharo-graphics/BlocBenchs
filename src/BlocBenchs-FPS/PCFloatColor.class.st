"
I represent a Color with an optimization to efficiently answer the RGBA values.

While the traditional Color requires a conversion each time a RBGA values is queried (as numbers between [0..1]), my collaborators are directly those RBGA values.
	

"
Class {
	#name : 'PCFloatColor',
	#superclass : 'Object',
	#instVars : [
		'red',
		'blue',
		'green',
		'alpha'
	],
	#category : 'BlocBenchs-FPS-Raw',
	#package : 'BlocBenchs-FPS',
	#tag : 'Raw'
}

{ #category : 'instance creation' }
PCFloatColor class >> newFrom: aColor [

	^ self basicNew
		  initializeR: aColor red
		  g: aColor green
		  b: aColor blue
		  a: aColor alpha;
		  yourself
]

{ #category : 'instance creation' }
PCFloatColor class >> newRandom: aRandom [

	^ self newFrom: (Color random: aRandom)
]

{ #category : 'accessing' }
PCFloatColor >> alpha [

	^ alpha
]

{ #category : 'converting' }
PCFloatColor >> asColor [

	^ Color
		  r: red
		  g: green
		  b: blue
		  alpha: alpha
]

{ #category : 'accessing' }
PCFloatColor >> blue [

	^ blue
]

{ #category : 'accessing' }
PCFloatColor >> green [

	^ green
]

{ #category : 'initialization' }
PCFloatColor >> initializeR: redValue g: greenValue b: blueValue a: alphaValue [

	self initialize.

	red := redValue.
	green := greenValue.
	blue := blueValue.
	alpha := alphaValue
]

{ #category : 'testing' }
PCFloatColor >> isTranslucent [
	
	^ alpha < 1.0
]

{ #category : 'printing' }
PCFloatColor >> printOn: aStream [

	| places |
	places := 3.
	super printOn: aStream.

	aStream
		nextPutAll: ' (r: ';
		nextPutAll: (red printShowingDecimalPlaces: places);
		nextPutAll: ' g: ';
		nextPutAll: (green printShowingDecimalPlaces: places);
		nextPutAll: ' b: ';
		nextPutAll: (blue printShowingDecimalPlaces: places);
		nextPutAll: ' a: ';
		nextPutAll: (alpha printShowingDecimalPlaces: places);
		nextPutAll: ')'
]

{ #category : 'accessing' }
PCFloatColor >> red [

	^ red
]
