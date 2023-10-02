Class {
	#name : #PCHeadlessBenchmarker,
	#superclass : #PCBlocBenchmarker,
	#instVars : [
		'pulseLoop'
	],
	#category : 'BlocBenchs-FPS-Benchmarkers'
}

{ #category : #hook }
PCHeadlessBenchmarker >> closeWindow [
	super closeWindow.
	
	"To verify it worked reasonably"
	space root aeAsForm inspect.
	
	pulseLoop stop.
"	pulseProcess ifNotNil: #terminate."
	space universe pulse. "close was deferred and needs to be processed"
]

{ #category : #accessing }
PCHeadlessBenchmarker >> host [

	^ PCHeadlessHost new
]

{ #category : #accessing }
PCHeadlessBenchmarker >> label [

	^ 'Bloc Alexandrie Headless'
]

{ #category : #hook }
PCHeadlessBenchmarker >> openWindow [
	super openWindow.
	
	firstMS := Time millisecondClockValue.
	lastMS := firstMS.
	
	"This host provides no pulse loop, for the moment, so we do it:"
	pulseLoop := BlHostPulseLoop forHost: PCHeadlessHost.
	pulseLoop pulsePeriod: 1 milliSecond.
	pulseLoop start.
	
"	pulseLoop := [
		[ space universe pulse ] repeat
		] forkAt: 40
"
]
