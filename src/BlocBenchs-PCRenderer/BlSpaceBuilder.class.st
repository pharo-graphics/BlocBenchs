Class {
	#name : #BlSpaceBuilder,
	#superclass : #Object,
	#instVars : [
		'space',
		'random',
		'spaceExtent',
		'host',
		'alphabetGenerator'
	],
	#category : #'BlocBenchs-PCRenderer-Tests'
}

{ #category : #convenience }
BlSpaceBuilder class >> newSpaceWith: aUnaryBlockClosure [

	^ self new newSpaceWith: aUnaryBlockClosure
]

{ #category : #'adding elements' }
BlSpaceBuilder >> addCircle [

	^ self addToRoot
		geometry: BlCircleGeometry new;
		yourself
]

{ #category : #'adding elements' }
BlSpaceBuilder >> addRectangle [

	^ self addToRoot
		geometry: BlRectangleGeometry new;
		yourself
]

{ #category : #'adding elements' }
BlSpaceBuilder >> addTo: parentElement [

	| anElement |
	anElement := BlElement new
		id: alphabetGenerator next;
		background: (Color random: random);
		yourself.
	parentElement addChild: anElement.
	^ anElement

]

{ #category : #'adding elements' }
BlSpaceBuilder >> addToRoot [

	^ self addTo: space root
]

{ #category : #'adding elements' }
BlSpaceBuilder >> addTriangle [

	^ self addToRoot
		geometry: BlTriangleGeometry new;
		yourself
]

{ #category : #building }
BlSpaceBuilder >> buildSpace [
	"Make last set up before user can use the space."

	space
		host: host;
		extent: spaceExtent.

	"Hacky way to prepare stuff without showing the space:"
	space root
		size: spaceExtent;
		forceLayout.
]

{ #category : #initialization }
BlSpaceBuilder >> initialize [

	super initialize.
	
	space := BlSpace new.
	spaceExtent := 100 asPoint.
	host := BlMorphicWindowHost new.

	random := Random seed: 7.
	alphabetGenerator := Generator on: [ :generator |
		| index |
		index := 1.
		[ 	Character alphabet do: [ :each |
				| next suffix |
				next := each asUppercase asString.
				suffix := index = 1
					ifTrue: [ '' ]
					ifFalse: [ index asString ].
				generator yield: next, suffix ].
			index := index + 1 ] repeat ].

]

{ #category : #'instance creation' }
BlSpaceBuilder >> newSpaceWith: aUnaryBlockClosure [

	aUnaryBlockClosure value: self.
	^ self
		  buildSpace;
		  space
]

{ #category : #accessing }
BlSpaceBuilder >> space [

	^ space
]

{ #category : #accessing }
BlSpaceBuilder >> spaceExtent [

	^ spaceExtent
]

{ #category : #accessing }
BlSpaceBuilder >> spaceExtent: aPoint [

	spaceExtent := aPoint
]
