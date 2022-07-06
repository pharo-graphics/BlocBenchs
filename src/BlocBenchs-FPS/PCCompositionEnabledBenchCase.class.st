Class {
	#name : #PCCompositionEnabledBenchCase,
	#superclass : #PCCompositionBenchCase,
	#category : #'BlocBenchs-FPS-Cases'
}

{ #category : #'instance creation' }
PCCompositionEnabledBenchCase >> newRawSDLCairoWindow [

	^ PCCompositionEnabledWindow newWith: self
]

{ #category : #hook }
PCCompositionEnabledBenchCase >> prepareAsStatic: anElement [

	anElement beInSingleCompositionLayer
]
