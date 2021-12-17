Class {
	#name : #PCBlocBenchmarker,
	#superclass : #PCBenchmarker,
	#instVars : [
		'space',
		'frames',
		'spartaCanvasBuilderClass',
		'realStartTimestamp'
	],
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #accessing }
PCBlocBenchmarker >> beCairo [
	
	spartaCanvasBuilderClass := BlSpartaCairoCanvasBuilder

]

{ #category : #accessing }
PCBlocBenchmarker >> beSkia [
	
	spartaCanvasBuilderClass := BlSpartaSkiaCanvasBuilder

]

{ #category : #hook }
PCBlocBenchmarker >> closeWindow [

	space close
]

{ #category : #hook }
PCBlocBenchmarker >> frameCount [
	
	^ frames
]

{ #category : #hook }
PCBlocBenchmarker >> host [

	^ BlMorphicWindowHost new
]

{ #category : #printing }
PCBlocBenchmarker >> label [

	^ 'Bloc ', spartaCanvasBuilderClass label
]

{ #category : #hook }
PCBlocBenchmarker >> newSpace [	

	self flag: #todo. "Side effect (original setting is not restored)"
	Bloc preferableSpartaCanvas: spartaCanvasBuilderClass.

	^ BlSpace new
		host: self host;
		title: self label;
		extent: 800@500;
		yourself

]

{ #category : #hook }
PCBlocBenchmarker >> openWindow [

	space := self newSpace.

	self populateSpace.

	"Counting frames"
	frames := 0.
	space addEventHandlerOn: BlSpaceRenderEndEvent do: [ :evt | 
		frames := frames + 1 ].

	"Let's consider that start happens when the space is actually shown."
	space addEventHandlerOn: BlSpaceShownEvent do: [ :evt |
		realStartTimestamp := DateAndTime now ].

	space show.

]

{ #category : #hook }
PCBlocBenchmarker >> populateSpace [

	| random numberOfCircles radius |
	random := Random seed: 1.
	numberOfCircles := 300.
	radius := 50.0.
	1 to: numberOfCircles do: [ :index |
		space addChild: (BlElement new
			relocate: (index * 2) @ 0;
			background: (Color random: random);
			size: (radius * 2) asPoint;
			geometry: BlCircleGeometry new;
			addAnimation: ((BlTransformAnimation translate: 0@200)
			  duration: numberOfSeconds seconds;
			  yourself);
			yourself) ].

]

{ #category : #hook }
PCBlocBenchmarker >> realStartTimestamp [

	^ realStartTimestamp
]
