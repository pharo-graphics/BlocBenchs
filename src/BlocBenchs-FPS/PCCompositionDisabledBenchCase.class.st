Class {
	#name : 'PCCompositionDisabledBenchCase',
	#superclass : 'PCCompositionBenchCase',
	#category : 'BlocBenchs-FPS-Cases',
	#package : 'BlocBenchs-FPS',
	#tag : 'Cases'
}

{ #category : 'instance creation' }
PCCompositionDisabledBenchCase >> newRawSDLCairoWindow [

	^ PCCompositionDisabledWindow newWith: self
]

{ #category : 'hook' }
PCCompositionDisabledBenchCase >> prepareAsStatic: anElement [

]
