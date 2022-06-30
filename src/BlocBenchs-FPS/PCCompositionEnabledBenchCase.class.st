Class {
	#name : #PCCompositionEnabledBenchCase,
	#superclass : #PCCompositionBenchCase,
	#category : #'BlocBenchs-FPS-Cases'
}

{ #category : #'instance creation' }
PCCompositionEnabledBenchCase >> newMorph [

	^ PCCompositionEnabledMorph new
		  case: self;
		  yourself
]

{ #category : #hook }
PCCompositionEnabledBenchCase >> prepareAsStatic: anElement [

	anElement beInSeparateCompositionLayer
]
