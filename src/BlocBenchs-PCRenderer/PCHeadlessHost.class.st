"
I'm a host that proocesses its frames normally, but doesn't open any kind of window and do not copy bytes from the rendered surface to any place. Also, I don't generate mouse or keyboard events, but any events enqueued such as the ones from animations.

"
Class {
	#name : #PCHeadlessHost,
	#superclass : #Object,
	#category : #'BlocBenchs-PCRenderer-Host-Headless'
}

{ #category : #accessing }
PCHeadlessHost class >> stop [
	
	
]

{ #category : #enumerating }
PCHeadlessHost class >> uiProcessDo: aFullBlockClosure [ 
	
	^ aFullBlockClosure value: Processor activeProcess
]

{ #category : #'host - api' }
PCHeadlessHost >> createHostSpaceFor: aBlSpace [ 
	
	| aHostSpace |
	aHostSpace := PCHeadlessHostSpace new.
"	aHostSpace universe: aBlSpace universe.
	aHostSpace host: self."
"	aHostSpace space: aBlSpace." "Only because BlHostRenderer>>render: wants to know it?"
"	aHostSpace renderer: PCRenderer new."
	aBlSpace hostSpace: aHostSpace.

]

{ #category : #'host - api' }
PCHeadlessHost >> destroyHostSpaceFor: aBlSpace [

	aBlSpace detachHostSpace
]

{ #category : #testing }
PCHeadlessHost >> isRunning [

	^ true
]

{ #category : #testing }
PCHeadlessHost >> isStillAvailable [

	^ true
]
