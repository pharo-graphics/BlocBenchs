"
I'm a Bloc host that doesn't open any kind of window and do not copy bytes from the rendered surface.

However, I processes its frames normally. I don't generate mouse or keyboard events but I process tasks that are enqueued (for example, the tasks enqueued by animations).

"
Class {
	#name : #PCHeadlessHost,
	#superclass : #Object,
	#category : #'BlocBenchs-FPS-Host-Headless'
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
"	aHostSpace renderer: AeRenderer new."
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
