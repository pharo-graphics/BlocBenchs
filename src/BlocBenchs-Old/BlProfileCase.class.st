"
I'm a Bloc case to be profiled. 

Concrete cases define several hooks:
- newElement, that answers a BlElement that will be added and shown in a space.
- executeBody, that defines the code to profile.

Cases have a hostClass and a spartaCanvasClass that must be set to the space and the Bloc global before openSpace.

"
Class {
	#name : #BlProfileCase,
	#superclass : #Object,
	#instVars : [
		'space',
		'spartaCanvasClass',
		'hostClass'
	],
	#category : #'BlocBenchs-Old-ProfileCases'
}

{ #category : #API }
BlProfileCase >> closeSpace [

	space close
]

{ #category : #API }
BlProfileCase >> executeBody [
]

{ #category : #accessing }
BlProfileCase >> hostClass [

	^ hostClass
]

{ #category : #accessing }
BlProfileCase >> hostClass: aBlHostClass [

	hostClass := aBlHostClass
]

{ #category : #initialization }
BlProfileCase >> initialize [

	super initialize.

	self resetSpace.
]

{ #category : #printing }
BlProfileCase >> label [

	| className ending beginning |
	beginning := 'Bl'.
	ending := 'ProfileCase'.

	className := self className.
	((className endsWith: ending) and: [ 
		 className beginsWith: beginning ]) ifFalse: [ self notYetImplemented ].

	^ (className allButFirst: beginning size) allButLast: ending size
]

{ #category : #hooks }
BlProfileCase >> newElement [
	"Answer the element under study."

	^ self subclassResponsibility
]

{ #category : #API }
BlProfileCase >> openSpace [

	self flag: #todo. "Handle Host and SpartaCanvas here? (instead of in runner)"

	space root
		addChild: self newElement;
		forceLayout.
		
	space
		title: self shortDescription;
		show.

]

{ #category : #copying }
BlProfileCase >> postCopy [

	self resetSpace
]

{ #category : #printing }
BlProfileCase >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPutAll: '(';
		print: hostClass label.
	aStream
		nextPutAll: ', ';
		print: spartaCanvasClass label;
		nextPutAll: ')'.

]

{ #category : #initialization }
BlProfileCase >> resetSpace [

	space := BlSpace new

]

{ #category : #printing }
BlProfileCase >> shortDescription [

	^ String streamContents: [ :aStream | 
		  aStream
			  nextPutAll: self label;
			  nextPutAll: ' | ';
			  nextPutAll: hostClass label;
			  nextPutAll: ' | ';
			  nextPutAll: spartaCanvasClass label ]
]

{ #category : #accessing }
BlProfileCase >> space [
	^ space
]

{ #category : #accessing }
BlProfileCase >> spartaCanvasClass [

	^ spartaCanvasClass
]

{ #category : #accessing }
BlProfileCase >> spartaCanvasClass: aSpartaCanvasClass [

	spartaCanvasClass := aSpartaCanvasClass
]
