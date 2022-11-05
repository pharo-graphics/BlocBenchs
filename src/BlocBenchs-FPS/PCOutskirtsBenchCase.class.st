Class {
	#name : #PCOutskirtsBenchCase,
	#superclass : #PCTranslatingFiguresBenchCase,
	#instVars : [
		'backgroundColor',
		'outskirts',
		'mustClipChildren',
		'backgroundLabel'
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

{ #category : #hook }
PCOutskirtsBenchCase >> figureGeometry [
		
	^ BlRoundedRectangleGeometry cornerRadius: 25
]

{ #category : #initialization }
PCOutskirtsBenchCase >> initialize [

	super initialize.
	
	self
		mustClipChildren: true;
		outskirts: BlOutskirts inside;
		beTranslucentBackgroundColor.
]

{ #category : #accessing }
PCOutskirtsBenchCase >> label [

	^ '{1} border & clipping={3} & {2} background' format: {
		outskirts class name splitCamelCase last.
		backgroundLabel.
		mustClipChildren }
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
		  clipChildren: false;
		  geometry: BlRectangleGeometry new;
		  background: Color gray translucent;
		  size: 20 asPoint;
		  yourself
]

{ #category : #hook }
PCOutskirtsBenchCase >> newFigureWith: random [

	^ BlElement new
		  border: (BlBorder paint: (self borderColorWith: random) width: self borderWidth);
		  background: self backgroundColor;
		  outskirts: self outskirts;
		  geometry: self figureGeometry;
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
