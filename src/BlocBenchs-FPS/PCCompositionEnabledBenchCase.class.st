Class {
	#name : 'PCCompositionEnabledBenchCase',
	#superclass : 'PCCompositionBenchCase',
	#category : 'BlocBenchs-FPS-Cases',
	#package : 'BlocBenchs-FPS',
	#tag : 'Cases'
}

{ #category : 'instance creation' }
PCCompositionEnabledBenchCase >> newRawSDLCairoWindow [

	^ PCCompositionEnabledViaSDLWindow newWith: self
]

{ #category : 'hook' }
PCCompositionEnabledBenchCase >> prepareAsStatic: anElement [

	anElement beInSingleCompositionLayer
]
