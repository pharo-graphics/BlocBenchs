"
I'm a parameterized bench case to cover the variants of element geometries as rendered by Bloc-Alexanderie's canvas.
"
Class {
	#name : #PCOutskirtsBenchCase,
	#superclass : #PCTranslatingFiguresBenchCase,
	#instVars : [
		'backgroundColor',
		'outskirts',
		'mustClipChildren',
		'backgroundLabel',
		'useExplicitBorderPathGeometry'
	],
	#category : #'BlocBenchs-FPS-Cases'
}

{ #category : #hook }
PCOutskirtsBenchCase >> backgroundColor [
	
	^ backgroundColor
]

{ #category : #hook }
PCOutskirtsBenchCase >> backgroundColor: aColor [
	
	backgroundColor := aColor
]

{ #category : #hook }
PCOutskirtsBenchCase >> beNoBackgroundColor [
	
	backgroundColor := Color transparent.
	backgroundLabel := 'No'
]

{ #category : #hook }
PCOutskirtsBenchCase >> beOpaqueBackgroundColor [
	
	backgroundColor := Color orange.
	backgroundLabel := 'Opaque'
]

{ #category : #hook }
PCOutskirtsBenchCase >> beTranslucentBackgroundColor [
	
	backgroundColor := Color green alpha: 0.1.
	backgroundLabel := 'Translucent'
]

{ #category : #hook }
PCOutskirtsBenchCase >> borderColorWith: random [
		
	^ (Color random: random) alpha: 0.3
]

{ #category : #hook }
PCOutskirtsBenchCase >> borderWidth [

	^ 12
]

{ #category : #accessing }
PCOutskirtsBenchCase >> figureExtent [

	^ 100 asPoint
]

{ #category : #initialization }
PCOutskirtsBenchCase >> initialize [

	super initialize.
	
	self
		mustClipChildren: true;
		outskirts: BlOutskirts inside;
		beTranslucentBackgroundColor;
		useExplicitBorderPathGeometry: true.
]

{ #category : #printing }
PCOutskirtsBenchCase >> label [

	^ '{1} border & clipping={3} & {2} background' format: {
		outskirts class name splitCamelCase last.
		backgroundLabel.
		mustClipChildren.
		useExplicitBorderPathGeometry }
]

{ #category : #accessing }
PCOutskirtsBenchCase >> mustClipChildren [

	^ mustClipChildren
]

{ #category : #accessing }
PCOutskirtsBenchCase >> mustClipChildren: aBoolean [

	mustClipChildren := aBoolean
]

{ #category : #hook }
PCOutskirtsBenchCase >> newChildWith: random [

	^ BlElement new
		  geometry: BlRectangleGeometry new;
		  background: (Color gray alpha: 0.5);
		  size: self figureExtent / 2;
		  yourself
]

{ #category : #hook }
PCOutskirtsBenchCase >> newFigureGeometry [
	
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
PCOutskirtsBenchCase >> newFigureWith: random [

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
PCOutskirtsBenchCase >> outskirts [
		
	^ outskirts
]

{ #category : #hook }
PCOutskirtsBenchCase >> outskirts: aBlOutskirts [

	outskirts := aBlOutskirts
]

{ #category : #accessing }
PCOutskirtsBenchCase >> useExplicitBorderPathGeometry: aBoolean [

	useExplicitBorderPathGeometry := aBoolean
]
