Class {
	#name : #PCSingleLayerBenchCase,
	#superclass : #PCLayerCompositionBenchCase,
	#category : #'BlocBenchs-FPS-Cases'
}

{ #category : #'instance creation' }
PCSingleLayerBenchCase >> newMorph [

	^ PCLayerCompositionOnMorph new
		  case: self;
		  yourself
]

{ #category : #hook }
PCSingleLayerBenchCase >> prepareToRefresh: anElement [

	super prepareToRefresh: anElement.

	anElement beInSingleCompositionLayer
]
