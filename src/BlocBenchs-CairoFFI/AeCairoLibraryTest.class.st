Class {
	#name : #AeCairoLibraryTest,
	#superclass : #TestCase,
	#category : #'BlocBenchs-CairoFFI-Tests'
}

{ #category : #tests }
AeCairoLibraryTest >> testVersionString [

	self assert:
		(AeCairoLibrary uniqueInstance versionString beginsWith: '1.')
]
