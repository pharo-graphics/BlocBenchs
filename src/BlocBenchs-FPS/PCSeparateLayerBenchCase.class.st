Class {
	#name : #PCSeparateLayerBenchCase,
	#superclass : #PCLayerCompositionBenchCase,
	#category : #'BlocBenchs-FPS-Cases'
}

{ #category : #'instance creation' }
PCSeparateLayerBenchCase >> newMorph [

	^ PCLayerCompositionOnMorph new
		  case: self;
		  yourself
]

{ #category : #hook }
PCSeparateLayerBenchCase >> prepareToRefresh: anElement [

	super prepareToRefresh: anElement.

	anElement beInSeparateCompositionLayer
]
