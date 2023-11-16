"
I am a benchmark for mouse event handling. 

I open a space with a tree of elements, and dispatch artificial mouse move events in the center.

The results are presented at Transcript. Open it and evaluate:
`BlMouseMoveBenchmark new runInFork`.

There is also an example in class-side.
"
Class {
	#name : #BlMouseMoveBenchmark,
	#superclass : #Object,
	#instVars : [
		'geometries',
		'benchDuration',
		'extent',
		'nestingLevel',
		'delayBetweenEventDispatchs',
		'host'
	],
	#category : #'BlocBenchs-Old-MouseMove'
}

{ #category : #examples }
BlMouseMoveBenchmark class >> exampleRun [

	| aProcess w |
	aProcess := [
	{ 	BlOSWindowSDL2Host }
			do: [ :eachHostClass |
				{ 	400 asPoint.
					"800 asPoint" }
						do: [ :eachExtent |
							{ 20. "10. 1" }
								do: [ :eachNestingLevel |
									('{1} {2} (nesting levels={3}):' format: {
										eachHostClass label.
										eachExtent.
										eachNestingLevel }) traceCr.

									self new
										host: eachHostClass new;
										extent: eachExtent;
										nestingLevel: eachNestingLevel;
										run ] ] ].
		w close.
	] fork.

	w := SpButtonPresenter new 
		label: 'Stop now';
		action: [ aProcess terminate. w close ];
		open
]

{ #category : #accessing }
BlMouseMoveBenchmark >> benchDuration: aDuration [

	benchDuration := aDuration
]

{ #category : #private }
BlMouseMoveBenchmark >> benchFindEventTargetOn: aSpace at: mouseMovePosition [

	^ [ aSpace root findMouseEventTargetAt: mouseMovePosition ]
		benchFor: benchDuration

]

{ #category : #accessing }
BlMouseMoveBenchmark >> delayBetweenEventDispatchs: aDuration [

	delayBetweenEventDispatchs := aDuration
]

{ #category : #private }
BlMouseMoveBenchmark >> doLittleWait [

	^ 500 milliSeconds
]

{ #category : #accessing }
BlMouseMoveBenchmark >> extent: aPoint [

	extent := aPoint
]

{ #category : #private }
BlMouseMoveBenchmark >> frequencyStringFor: aBenchmarkResult [

	^ String streamContents: [ :stream | 
		  aBenchmarkResult frequency printOn: stream showingDecimalPlaces: 2 ]
]

{ #category : #accessing }
BlMouseMoveBenchmark >> geometries: aCollection [

	geometries := aCollection
]

{ #category : #accessing }
BlMouseMoveBenchmark >> host: aBlOSWindowSDL2Host [ 

	host := aBlOSWindowSDL2Host
]

{ #category : #initialization }
BlMouseMoveBenchmark >> initialize [ 

	super initialize.

	extent := 200@200.

	benchDuration := 5 seconds.
	
	delayBetweenEventDispatchs := 5 milliSeconds.

	nestingLevel := 3.

	host := BlOSWindowSDL2Host new.

	geometries := {
		BlRoundedRectangleGeometry cornerRadius: 40.
		"BlAnnulusSectorGeometry new
			startAngle: 45;
			endAngle: 270;
			innerRadius: 0.0;
			outerRadius: 1.0;
			yourself" }

]

{ #category : #private }
BlMouseMoveBenchmark >> mouseMoveOn: aSpace at: aPoint [
	
	| aProcess |

	[ aProcess := [
		self
			mouseMoverLoopOn: aSpace
			at: aPoint ] fork
	] ensure: [
		benchDuration wait.
		aProcess terminate ]

]

{ #category : #private }
BlMouseMoveBenchmark >> mouseMoverLoopOn: aSpace at: aPoint [
	
	[ 	| anEvent |
		delayBetweenEventDispatchs wait.
		anEvent := BlMouseMoveEvent new
			timestamp: DateAndTime now;
			position: aPoint;
			yourself.
		aSpace dispatchEvent: anEvent ] repeat
]

{ #category : #accessing }
BlMouseMoveBenchmark >> nestingLevel: aNumber [

	nestingLevel := aNumber
]

{ #category : #private }
BlMouseMoveBenchmark >> newPointerElement [

	^ BlElement new
		geometry: (BlPolygonGeometry vertices: { 0@0. 10@0. 5@3. 10@8. 8@10. 3@5. 0@10 } );
		border: (BlBorder paint: Color white width: 1);
		background: Color black;
		preventMouseEvents;
		yourself
]

{ #category : #running }
BlMouseMoveBenchmark >> run [

	| outputDataFrame |
	outputDataFrame := DataFrame withColumnNames: #('Indirect' 'Direct').
	
	geometries do: [ :aGeometry |
		| results |
		results := self runOn: aGeometry.
		
	outputDataFrame
		addRow: {
			self frequencyStringFor: results first.
			self frequencyStringFor: results second }
		named: aGeometry className  ].

	DataFrameMarkdownPrinter new
		stream: Transcript;
		dataFrame: outputDataFrame;
		write.

	'' traceCr.

]

{ #category : #running }
BlMouseMoveBenchmark >> runInFork [

	[ self run ] fork
]

{ #category : #private }
BlMouseMoveBenchmark >> runOn: aGeometry [

	| count elements aSpace firstTime lastTime resultForIndirectCheck resultForDirectCheck eventPosition random |
	count := 0.
	firstTime := nil.
	random := Random seed: 7.
	eventPosition := extent // 2.

	elements := (1 to: nestingLevel) collect: [ :index |
		BlElement new
			position: 0@0;
			size: extent;
			geometry: aGeometry;
			background: (Color random: random);
			when: BlMouseMoveEvent do: [ :evt |
				count := count+1.
				firstTime ifNil: [ firstTime := evt timestamp ].
				lastTime := evt timestamp ];
			transformDo: [ :builder | builder scaleBy: 0.9 ];
			yourself ].

	elements reduceRight: [:a :b | a addChild: b ].

	aSpace := BlSpace new
		host: host;
		yourself.
	
	aSpace root
		addChild: elements first;
		addChild:
			(self newPointerElement
				position: eventPosition;
				yourself).
				
	aSpace
		extent: extent;
		title: host class label, ' - ', aGeometry asString;
		show.
	self doLittleWait.

	self mouseMoveOn: aSpace at: eventPosition.
	
	resultForIndirectCheck := 
		BenchmarkResult new
			iterations: count;
			elapsedTime: lastTime - firstTime;
			yourself.

	resultForDirectCheck := self
		benchFindEventTargetOn: aSpace
		at: eventPosition.

	aSpace close.
	self doLittleWait.

	^ { resultForIndirectCheck. resultForDirectCheck }

]
