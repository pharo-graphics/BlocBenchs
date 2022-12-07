"
I'm a benchmarker for Sparta (Cairo and Skia).
"
Class {
	#name : #PCBlocSpartaBenchmarker,
	#superclass : #PCBlocBenchmarker,
	#instVars : [
		'spartaCanvasBuilderClass'
	],
	#category : #'BlocBenchs-FPS-Benchmarkers'
}

{ #category : #accessing }
PCBlocSpartaBenchmarker >> beCairo [
	
	spartaCanvasBuilderClass := BlSpartaCairoCanvasBuilder

]

{ #category : #accessing }
PCBlocSpartaBenchmarker >> beSkia [
	
	spartaCanvasBuilderClass := BlSpartaSkiaCanvasBuilder

]

{ #category : #accessing }
PCBlocSpartaBenchmarker >> host [

	^ BlOSWindowSDL2Host new
]

{ #category : #initialization }
PCBlocSpartaBenchmarker >> initialize [

	super initialize.
	
	self beCairo.
]

{ #category : #accessing }
PCBlocSpartaBenchmarker >> label [

	^ 'Bloc Sparta ', spartaCanvasBuilderClass label
]

{ #category : #accessing }
PCBlocSpartaBenchmarker >> run [

	self flag: #todo. "Side effect (original setting is not restored)"
	Bloc preferableSpartaCanvas: spartaCanvasBuilderClass.

	^ super run
]
