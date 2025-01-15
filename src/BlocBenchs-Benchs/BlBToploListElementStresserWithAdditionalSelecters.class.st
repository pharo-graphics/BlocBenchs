Class {
	#name : #BlBToploListElementStresserWithAdditionalSelecters,
	#superclass : #BlBBlocCase,
	#category : #'BlocBenchs-Benchs-Bloc'
}

{ #category : #initialization }
BlBToploListElementStresserWithAdditionalSelecters >> initialize [

	super initialize.
	label := 'Toplo list stress'
]

{ #category : #'instance creation' }
BlBToploListElementStresserWithAdditionalSelecters >> newElement [

	^ ToListElementStresserWithAdditionalSelecters new tabsPanel
]
