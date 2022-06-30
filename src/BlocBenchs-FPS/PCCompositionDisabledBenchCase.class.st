Class {
	#name : #PCCompositionDisabledBenchCase,
	#superclass : #PCCompositionBenchCase,
	#category : #'BlocBenchs-FPS-Cases'
}

{ #category : #'instance creation' }
PCCompositionDisabledBenchCase >> newMorph [

	^ PCCompositionDisabledMorph new
		  case: self;
		  yourself
]

{ #category : #hook }
PCCompositionDisabledBenchCase >> prepareAsStatic: anElement [

]
