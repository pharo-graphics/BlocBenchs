Class {
	#name : #PCTopSolidLayerBenchCase,
	#superclass : #PCLayerCompositionBenchCase,
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #hook }
PCTopSolidLayerBenchCase >> indexOfElementToRefresh [

	^ self indexOfTopElement
]
