Class {
	#name : #BlocBenchsSmokeTest,
	#superclass : #TestCase,
	#category : #'BlocBenchs-Tests'
}

{ #category : #accessing }
BlocBenchsSmokeTest >> defaultTimeLimit [

	^ 5 minutes
]

{ #category : #tests }
BlocBenchsSmokeTest >> testAeBenchManySiblingsRunner [

	AeBenchFigureGridRunner new run
]

{ #category : #tests }
BlocBenchsSmokeTest >> testBlProfileRunner [

	BlProfileRunner exampleAll
]

{ #category : #tests }
BlocBenchsSmokeTest >> testPCBenchmarker1 [

	PCBenchmarker exampleAllBenchs
]

{ #category : #tests }
BlocBenchsSmokeTest >> testPCBenchmarker2 [

	PCBenchmarker exampleAllBenchsWithRaw
]

{ #category : #tests }
BlocBenchsSmokeTest >> testPCBenchmarker3 [

	PCBenchmarker exampleProfileCaseWithFlameGraph
]

{ #category : #tests }
BlocBenchsSmokeTest >> testPCOSWindowScrollingExample1 [

	PCOSWindowScrollingExample new
		beFlatScrolling;
		open
]

{ #category : #tests }
BlocBenchsSmokeTest >> testPCOSWindowScrollingExample2 [

	PCOSWindowScrollingExample new
		beInertialScrolling;
		open
]

{ #category : #tests }
BlocBenchsSmokeTest >> testSDLShapedWindowExample [

	OSPlatform current isMacOS ifTrue: [ 
		SDLShapedWindowExample exampleByColorKey ]
]
