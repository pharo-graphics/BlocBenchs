Class {
	#name : #PCInertialScrollingAxis,
	#superclass : #PCOSWindowAxisScrollingStrategy,
	#instVars : [
		'inertia',
		'freeMovementLimitMS'
	],
	#category : #'BlocBenchs-SDL-Scrolling'
}

{ #category : #initialization }
PCInertialScrollingAxis >> initialize [

	super initialize.
	inertia := 0.0.
	freeMovementLimitMS := 150.0.
]

{ #category : #'as yet unclassified' }
PCInertialScrollingAxis >> millsecondsPassed: msDelta do: aFullBlockClosure [ 
	
	inertia := inertia * ((freeMovementLimitMS - msDelta) / freeMovementLimitMS).
	
	aFullBlockClosure value: inertia
]

{ #category : #'as yet unclassified' }
PCInertialScrollingAxis >> millsecondsPassed: msDelta onScroll: scrollDelta do: aFullBlockClosure [ 
	
	scrollDelta sign = inertia sign ifFalse: [ 
		inertia := 0 ].
	inertia := inertia + scrollDelta.
"	accelByMS := 2.
	((accelByMS - msDelta) / accelByMS)."
	
	aFullBlockClosure value: "inertia" scrollDelta
]
