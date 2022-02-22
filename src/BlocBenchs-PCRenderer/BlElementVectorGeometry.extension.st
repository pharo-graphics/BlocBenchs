Extension { #name : #BlElementVectorGeometry }

{ #category : #'*BlocBenchs-PCRenderer' }
BlElementVectorGeometry >> containsPoint: aPoint in: aBlElement [
	"Note: we have to pass BlElement in order to give geometry a chance to use element properties
	as as border during the testing process"

	^ Bloc hasSparta
		ifTrue: [
			self
				containsPoint: aPoint
				in: aBlElement
				on: Bloc preferableSpartaCanvas offscreen ]
		ifFalse: [ 
			self pureCairoContainsPoint: aPoint in: aBlElement ]
]

{ #category : #'*BlocBenchs-PCRenderer' }
BlElementVectorGeometry >> pureCairoContainsPoint: aPoint in: aBlElement [
	"Answer whether aPoint is contained by a this geometry."

	^ self subclassResponsibility
]
