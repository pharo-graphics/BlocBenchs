Class {
	#name : #BlBOverlayAnimationCase,
	#superclass : #BlBBlocCase,
	#instVars : [
		'useCompositionLayer'
	],
	#category : #'BlocBenchs-Benchs-Bloc'
}

{ #category : #benchmarking }
BlBOverlayAnimationCase class >> benchMatrix [

	^ super benchMatrix
		  forSelector: #useCompositionLayer
		  addOptions: #( true false )
]

{ #category : #'instance creation' }
BlBOverlayAnimationCase >> createChildElement [

	| element |
	element := BlElement new
		  background: Color random;
		  height: 50;
		  width: 50;
		  yourself.

	element layout: (BlGridLayout new columnCount: 10).
	element layout cellSpacing: 0.
	
	element addChildren: ((1 to: 100) collect: [ :i | 
			BlElement new
					  background: Color random;
					  height: 5;
					  width: 5;
					  yourself ]).
		
	^ element
	
]

{ #category : #accessing }
BlBOverlayAnimationCase >> defaultLabel [

	^ '{1} withCompositionLayer: {2}' format: {
		super defaultLabel.
		useCompositionLayer }
]

{ #category : #'instance creation' }
BlBOverlayAnimationCase >> newElement [

	| container transparent spinner |
	container := BlElement new.
	container layout: (BlGridLayout new columnCount: 16).
	container layout cellSpacing: 3.
	container constraintsDo: [ :c |
		c vertical matchParent.
		c horizontal matchParent ].

	300 timesRepeat: [
		container addChild: (self createChildElement) ].

	spinner := BlElement new.
	spinner constraintsDo: [ :c | 
		c frame vertical alignCenter.
		c frame horizontal alignCenter ].
	spinner height: 50.
	spinner width: 50.
	spinner background: Color blue.
	
	spinner addAnimation: ((BlTransformAnimation rotate: 180)
		              duration: 0.5 seconds;
		              easing: BlLinearInterpolator new;
		              target: spinner;
						  beInfinite;
		              yourself ).
	
	transparent := BlElement new.
	transparent layout: BlFrameLayout new.
	transparent background: (Color gray alpha: 0.5).
	transparent constraintsDo: [ :c |
		c vertical matchParent.
		c horizontal matchParent ].
	transparent addChild: spinner.

	useCompositionLayer ifTrue: [	
		container beInSingleCompositionLayer.
		transparent beInSingleCompositionLayer ].
	
	^ BlElement new
		constraintsDo: [ :c |
			c vertical matchParent.
			c horizontal matchParent ];
		addChild: container;
		addChild: transparent;
		yourself

]

{ #category : #accessing }
BlBOverlayAnimationCase >> useCompositionLayer: aValue [

	useCompositionLayer := aValue
]
