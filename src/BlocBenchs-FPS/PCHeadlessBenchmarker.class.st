Class {
	#name : #PCHeadlessBenchmarker,
	#superclass : #PCBlocBenchmarker,
	#instVars : [
		'pulseProcess'
	],
	#category : #'BlocBenchs-FPS-Benchmarkers'
}

{ #category : #hook }
PCHeadlessBenchmarker >> closeWindow [
	super closeWindow.
	
	pulseProcess ifNotNil: #terminate.
	space universe pulse. "close was defered and neeeds to be processed"
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
		
	pulseProcess := [
		| delay |
		delay := Delay forMilliseconds: 1.
		[space requestNextPulse; pulse. space universe pulse. "delay wait" ] repeat.
"		space requestNextPulse; pulse."
		 ] forkAt: 40
]
