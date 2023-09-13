Class {
	#name : #BlocBenchsSmokeTest,
	#superclass : #TestCase,
	#category : #'BlocBenchs-Tests'
}

{ #category : #accessing }
BlocBenchsSmokeTest >> defaultTimeLimit [

	^ 2 minutes
]

{ #category : #tests }
BlocBenchsSmokeTest >> testAeBenchManySiblingsRunner [

	AeBenchManySiblingsRunner new run
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

	PCOSWindowScrollingExample new beFlatScrolling; open; inspect
]

{ #category : #tests }
BlocBenchsSmokeTest >> testPCOSWindowScrollingExample2 [

	PCOSWindowScrollingExample new beInertialScrolling; open; inspect
]

{ #category : #tests }
BlocBenchsSmokeTest >> testSDLShapedWindowExample [

	SDLShapedWindowExample exampleByColorKey
]
