Class {
	#name : #PCBlocMorphicRendererBenchmarker,
	#superclass : #PCBlocBenchmarker,
	#instVars : [
		'spartaCanvasBuilderClass'
	],
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #accessing }
PCBlocMorphicRendererBenchmarker >> beCairo [
	
	spartaCanvasBuilderClass := BlSpartaCairoCanvasBuilder

]

{ #category : #accessing }
PCBlocMorphicRendererBenchmarker >> beSkia [
	
	spartaCanvasBuilderClass := BlSpartaSkiaCanvasBuilder

]

{ #category : #accessing }
PCBlocMorphicRendererBenchmarker >> host [

	^ BlMorphicWindowHost new
]

{ #category : #initialization }
PCBlocMorphicRendererBenchmarker >> initialize [

	super initialize.
	
	self beCairo.
]

{ #category : #accessing }
PCBlocMorphicRendererBenchmarker >> label [

	^ 'Bloc ', spartaCanvasBuilderClass label
]

{ #category : #accessing }
PCBlocMorphicRendererBenchmarker >> newSpace [	

	self flag: #todo. "Side effect (original setting is not restored)"
	Bloc preferableSpartaCanvas: spartaCanvasBuilderClass.

	^ super newSpace
]
