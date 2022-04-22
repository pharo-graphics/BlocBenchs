Trait {
	#name : #AeTCairoLibrary,
	#category : #'BlocBenchs-CairoFFI-Library'
}

{ #category : #'library path' }
AeTCairoLibrary classSide >> ffiLibraryName [
	^ AeCairoLibrary
]

{ #category : #'library path' }
AeTCairoLibrary >> ffiLibraryName [
	^ self class ffiLibraryName
]
