"
I'm a benchmarker for Cairo and Skia renderers, i.e. the regular or traditional ones.
"
Class {
	#name : #PCBlocRegularRendererBenchmarker,
	#superclass : #PCBlocBenchmarker,
	#instVars : [
		'spartaCanvasBuilderClass'
	],
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #accessing }
PCBlocRegularRendererBenchmarker >> beCairo [
	
	spartaCanvasBuilderClass := BlSpartaCairoCanvasBuilder

]

{ #category : #accessing }
PCBlocRegularRendererBenchmarker >> beSkia [
	
	spartaCanvasBuilderClass := BlSpartaSkiaCanvasBuilder

]

{ #category : #accessing }
PCBlocRegularRendererBenchmarker >> host [

	^ BlMorphicWindowHost new
]

{ #category : #initialization }
PCBlocRegularRendererBenchmarker >> initialize [

	super initialize.
	
	self beCairo.
]

{ #category : #accessing }
PCBlocRegularRendererBenchmarker >> label [

	^ 'Bloc ', spartaCanvasBuilderClass label
]

{ #category : #accessing }
PCBlocRegularRendererBenchmarker >> run [

	self flag: #todo. "Side effect (original setting is not restored)"
	Bloc preferableSpartaCanvas: spartaCanvasBuilderClass.

	^ super run
]
