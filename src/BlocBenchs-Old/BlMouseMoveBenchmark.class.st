"
I am a benchmark for mouse event handling. 

I open a space with a tree of elements, and dispatch artificial mouse move events in the center.

The results are presented at Transcript. Open it and evaluate:
`BlMouseMoveBenchmark new runInFork`.

There is also an example on class-side.

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
		{ BlOSWindowSDL2Host } do: [ :eachHostClass |
			{ 400 asPoint } do: [ :eachExtent |
				{ 20. 5 } do: [ :eachNestingLevel |
					('{1} {2} (nesting levels={3}):' format: {
						eachHostClass label.
						eachExtent.
						eachNestingLevel }) traceCr.

					self new
						host: eachHostClass new;
						extent: eachExtent;
						nestingLevel: eachNestingLevel;
						geometries: {
							BlRoundedRectangleGeometry cornerRadius: 40.
							"BlAnnulusSectorGeometry new
								startAngle: 45;
								endAngle: 270;
								innerRadius: 0.0;
								outerRadius: 1.0;
								yourself" };
						run ] ] ].
		w close ] fork.

	w := SpButtonPresenter new
		     label: 'Stop now';
		     action: [
			     aProcess terminate.
			     w close ];
		     open
]

{ #category : #accessing }
BlMouseMoveBenchmark >> benchDuration: aDuration [

	benchDuration := aDuration
]

{ #category : #private }
BlMouseMoveBenchmark >> doLittleWait [

	^ 500 milliSeconds wait
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
			position: aPoint;
			yourself.
		aSpace dispatchEventWithTimestamp: anEvent ] repeat
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
	outputDataFrame := DataFrame withColumnNames: #('BlMouseMoveEvent rate' 'findMouseTargetAt rate').
	
	geometries do: [ :aGeometry |
		self
			runFor: aGeometry
			addingResultsOn: outputDataFrame   ].

	DataFrameMarkdownPrinter new
		stream: Transcript;
		dataFrame: outputDataFrame;
		write.

	'' traceCr.

]

{ #category : #private }
BlMouseMoveBenchmark >> runFor: aGeometry addingResultsOn: aDataFrame [

	| count elements aSpace firstTime lastTime resultForHandledEvents resultForFindMouseTargetAt eventPosition random |
	count := 0.
	firstTime := nil.
	random := Random seed: 7.
	eventPosition := extent // 2.

	elements := (1 to: nestingLevel) collect: [ :index |
		            BlElement new
			            position: 0 @ 0;
			            extent: extent;
			            geometry: aGeometry;
			            background: (Color random: random);
			            addEventHandlerOn: BlMouseMoveEvent
				            do: [ :evt |
					            count := count + 1.
					            firstTime ifNil: [
					               firstTime := evt timestamp ].
					            lastTime := evt timestamp ];
			            transformDo: [ :builder | builder scaleBy: 0.9 ];
			            yourself ].

	elements reduceRight: [ :a :b | a addChild: b ].

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
		title: host class label , ' - ' , aGeometry asString;
		show.
	self doLittleWait.

	self mouseMoveOn: aSpace at: eventPosition.

	resultForHandledEvents := BenchmarkResult new
		                          iterations: count;
		                          elapsedTime: lastTime - firstTime;
		                          yourself.

	resultForFindMouseTargetAt := [
		aSpace root findMouseEventTargetAt: eventPosition
		] benchFor: benchDuration.

	aSpace close.
	self doLittleWait.

	aDataFrame
		addRow: {
			self frequencyStringFor: resultForHandledEvents.
			self frequencyStringFor: resultForFindMouseTargetAt }
		named: aGeometry className
]

{ #category : #running }
BlMouseMoveBenchmark >> runInFork [

	[ self run ] fork
]
