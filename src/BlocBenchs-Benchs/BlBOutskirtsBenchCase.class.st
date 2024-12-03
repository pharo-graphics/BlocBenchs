Class {
	#name : #BlBOutskirtsBenchCase,
	#superclass : #BlBAbstractTranslatingFiguresCase,
	#instVars : [
		'backgroundColor',
		'outskirts',
		'mustClipChildren',
		'useExplicitBorderPathGeometry'
	],
	#category : #'BlocBenchs-Benchs-Bloc'
}

{ #category : #benchmarking }
BlBOutskirtsBenchCase class >> benchMatrix [ 
	
	^ super benchMatrix 
		forSelector: #mustClipChildren addOptions: #(true false);
		forSelector: #outskirts addOptions: { BlOutskirts centered. BlOutskirts inside. BlOutskirts outside };
		forSelector: #backgroundColor addOptions: { Color transparent. Color orange.  Color green alpha: 0.1. };
		forSelector: #useExplicitBorderPathGeometry addOptions: #(true false)
]

{ #category : #hook }
BlBOutskirtsBenchCase >> backgroundColor [
	
	^ backgroundColor
]

{ #category : #hook }
BlBOutskirtsBenchCase >> backgroundColor: aColor [
	
	backgroundColor := aColor
]

{ #category : #hook }
BlBOutskirtsBenchCase >> borderColorWith: random [
		
	^ (Color random: random) alpha: 0.3
]

{ #category : #hook }
BlBOutskirtsBenchCase >> borderWidth [

	^ 12
]

{ #category : #printing }
BlBOutskirtsBenchCase >> defaultLabel [

	^ '{1} outskirts: {2} border: {3} clipping: {4} & explicitBorder: {5}' format: {
		super defaultLabel.
		outskirts class name.
		backgroundColor.
		mustClipChildren.
		useExplicitBorderPathGeometry }
]

{ #category : #accessing }
BlBOutskirtsBenchCase >> figureExtent [

	^ 100 asPoint
]

{ #category : #accessing }
BlBOutskirtsBenchCase >> mustClipChildren [

	^ mustClipChildren
]

{ #category : #accessing }
BlBOutskirtsBenchCase >> mustClipChildren: aBoolean [

	mustClipChildren := aBoolean
]

{ #category : #hook }
BlBOutskirtsBenchCase >> newChildWith: random [

	^ BlElement new
		  geometry: BlRectangleGeometry new;
		  background: (Color gray alpha: 0.5);
		  size: self figureExtent / 2;
		  yourself
]

{ #category : #hook }
BlBOutskirtsBenchCase >> newFigureGeometry [
	
	| cornerRadius |
	cornerRadius := 25.
	^ useExplicitBorderPathGeometry 
		ifTrue: [ BlRoundedRectangleGeometry cornerRadius: cornerRadius ]
		ifFalse: [
			"A hand-made octogon"
			(BlPolygonGeometry vertices: { 
				 cornerRadius @ 0.
				 self figureExtent x - cornerRadius @  0.
				 self figureExtent x @ cornerRadius.
				 self figureExtent x @ (self figureExtent y - cornerRadius).
				 self figureExtent x - cornerRadius @ self figureExtent y.
				 cornerRadius @ self figureExtent y.
				 0 @ (self figureExtent y - cornerRadius).
				 0 @ cornerRadius }) ]
]

{ #category : #hook }
BlBOutskirtsBenchCase >> newFigureWith: random [

	^ BlElement new
		  border: (BlBorder paint: (self borderColorWith: random) width: self borderWidth);
		  background: self backgroundColor;
		  outskirts: self outskirts;
		  geometry: self newFigureGeometry;
		  size: self figureExtent;
		  clipChildren: self mustClipChildren;
		  addChild: (self newChildWith: random);
		  yourself
]

{ #category : #hook }
BlBOutskirtsBenchCase >> outskirts [
		
	^ outskirts
]

{ #category : #hook }
BlBOutskirtsBenchCase >> outskirts: aBlOutskirts [

	outskirts := aBlOutskirts
]

{ #category : #accessing }
BlBOutskirtsBenchCase >> useExplicitBorderPathGeometry: aBoolean [

	useExplicitBorderPathGeometry := aBoolean
]
