Trait {
	#name : #PCTCairoLibrary,
	#category : #'BlocBenchs-PCRenderer-CairoFFI'
}

{ #category : #'library path' }
PCTCairoLibrary classSide >> ffiLibraryName [
	^ PCCairoLibrary
]

{ #category : #'library path' }
PCTCairoLibrary >> ffiLibraryName [
	^ self class ffiLibraryName
]
