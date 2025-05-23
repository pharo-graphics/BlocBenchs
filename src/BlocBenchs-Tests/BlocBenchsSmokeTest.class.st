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
BlocBenchsSmokeTest >> expectedFailures [

	^ OSPlatform current isLinux
		ifFalse: [ #() ]
		ifTrue: [ #(testSDLShapedWindowExample) ]
]

{ #category : #tests }
BlocBenchsSmokeTest >> testAeBenchManySiblingsRunner [

	AeBenchFigureGridRunner new run
]

{ #category : #tests }
BlocBenchsSmokeTest >> testBlMouseMoveBenchmark [

	BlMouseMoveBenchmark exampleRun
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
BlocBenchsSmokeTest >> testRectangleBlurBenchmark [

	AeBenchBlurRectangleRunner benchAllVsGaussian
]

{ #category : #tests }
BlocBenchsSmokeTest >> testSDLShapedWindowExample [

	2 timesRepeat: [
		[ (SDL2 pollEvent: SDL_Event new) > 0 ] whileTrue.
		0.1 seconds wait ].

	SDLShapedWindowExample exampleByColorKey
]
