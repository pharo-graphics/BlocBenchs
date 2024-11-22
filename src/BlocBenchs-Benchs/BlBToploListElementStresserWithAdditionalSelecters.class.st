Class {
	#name : #BlBToploListElementStresserWithAdditionalSelecters,
	#superclass : #BlBBlocCase,
	#category : #'BlocBenchs-Benchs-Bloc'
}

{ #category : #printing }
BlBToploListElementStresserWithAdditionalSelecters >> label [

	^ 'Toplo list stress'
]

{ #category : #'instance creation' }
BlBToploListElementStresserWithAdditionalSelecters >> newElement [

	^ ToListElementStresserWithAdditionalSelecters new tabsPanel
]
