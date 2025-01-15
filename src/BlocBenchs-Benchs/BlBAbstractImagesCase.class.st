Class {
	#name : #BlBAbstractImagesCase,
	#superclass : #BlBAbstractTranslatingFiguresCase,
	#traits : 'TBlBAbstractImagesLogic',
	#classTraits : 'TBlBAbstractImagesLogic classTrait',
	#category : #'BlocBenchs-Benchs-Bloc'
}

{ #category : #running }
BlBAbstractImagesCase class >> isAbstract [ 

	^ self == BlBAbstractImagesCase
]

{ #category : #hook }
BlBAbstractImagesCase >> newFigureWith: random [

	| container |
	container := BlElement new.
	container clipChildren: false.
	
	1 to: self numberOfRows do:[ :index |
		container addChild:
			((self newImageElementWith: random)
				position: 0 @ (index * self offsetBetweenFigures y);
				yourself) ].

	^ container
]

{ #category : #hook }
BlBAbstractImagesCase >> newImageElementWith: random [

	^ self subclassResponsibility
]
