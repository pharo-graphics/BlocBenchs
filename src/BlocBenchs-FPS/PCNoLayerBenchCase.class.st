Class {
	#name : #PCNoLayerBenchCase,
	#superclass : #PCLayerCompositionBenchCase,
	#category : #'BlocBenchs-FPS-Cases'
}

{ #category : #'instance creation' }
PCNoLayerBenchCase >> newMorph [

	^ PCLayerCompositionOffMorph new
		  case: self;
		  yourself
]
