Extension { #name : #BlElement }

{ #category : #'*BlocBenchs-BoidsExample' }
BlElement >> boid [

	^ self userData at: #boid
]

{ #category : #'*BlocBenchs-BoidsExample' }
BlElement >> boid: aBoid [
	self userData at: #boid put: aBoid
]
