Class {
	#name : #PCBlSpartaCanvasBuilder,
	#superclass : #BlSpartaCanvasBuilder,
	#category : #'BlocBenchs-SpartaAdapter'
}

{ #category : #accessing }
PCBlSpartaCanvasBuilder class >> isSupported [
	
	^ true
]

{ #category : #accessing }
PCBlSpartaCanvasBuilder class >> label [
	
	^ 'PC'
]

{ #category : #accessing }
PCBlSpartaCanvasBuilder class >> priority [

	^ 0
]

{ #category : #testing }
PCBlSpartaCanvasBuilder class >> supportsBufferSurface [
	
	^ true
]

{ #category : #testing }
PCBlSpartaCanvasBuilder class >> supportsFormSurface [

	^ true
]

{ #category : #'instance creation' }
PCBlSpartaCanvasBuilder >> forFormOn: aBlHostRendererFormSurface [ 
	
	^ PCSpartaCanvas extent: aBlHostRendererFormSurface extent
]
