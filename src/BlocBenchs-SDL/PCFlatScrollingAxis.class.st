Class {
	#name : #PCFlatScrollingAxis,
	#superclass : #PCOSWindowAxisScrollingStrategy,
	#category : #'BlocBenchs-SDL-Scrolling'
}

{ #category : #'as yet unclassified' }
PCFlatScrollingAxis >> millsecondsPassed: msDelta do: aFullBlockClosure [ 
	

]

{ #category : #'as yet unclassified' }
PCFlatScrollingAxis >> millsecondsPassed: msDelta onScroll: scrollDelta do: aFullBlockClosure [ 
	
	aFullBlockClosure value: scrollDelta negated
]
