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

	| random numberOfCircles radius |
	space := self newSpace.
	random := Random seed: 1.
	numberOfCircles := 300.
	radius := 50.0.

	1 to: numberOfCircles do: [ :index |
		space addChild: (BlElement new
			background: (Color random: random);
			size: 100 asPoint;
			geometry: BlCircleGeometry new;
			relocate: (index * 2) @ 0;
			addAnimation: ((BlTransformAnimation translate: 0@200)
			  duration: numberOfSeconds seconds;
			  yourself);
			yourself) ].

	frames := 0.
	space addEventHandlerOn: BlSpaceRenderEndEvent do: [ :evt | 
		frames := frames + 1 ].
	space addEventHandlerOn: BlSpaceShownEvent do: [ :evt |
		realStartTimestamp := DateAndTime now ].

	space show.

]

{ #category : #hook }
PCBlocBenchmarker >> realStartTimestamp [

	^ realStartTimestamp
]
