"
Evaluate:

```
BlMouseMoveBenchmark new runInFork.
```
"
Class {
	#name : #BlMouseMoveBenchmark,
	#superclass : #Object,
	#instVars : [
		'delayBetweenEventDispatchs',
		'geometries',
		'benchDuration',
		'extent',
		'nestingLevel'
	],
	#category : #'BlocBenchs-Old-MouseMove'
}

{ #category : #examples }
BlMouseMoveBenchmark class >> exampleRun [

	| aProcess w |
	aProcess := [
	{  BlSpartaSkiaCanvasBuilder.
		BlSpartaCairoCanvasBuilder }
			do: [ :eachCanvasClass |
				{ 	400 asPoint.
					"800 asPoint" }
						do: [ :eachExtent |
							{ 10. 5. 1 }
								do: [ :eachNestingLevel |
									('{1} {2} (levels={3}):' format: {
										eachCanvasClass label.
										eachExtent.
										eachNestingLevel }) traceCr.

									Bloc preferableSpartaCanvas: eachCanvasClass.
									
									self new
										extent: eachExtent;
										nestingLevel: eachNestingLevel;
										run ] ] ].
		w close.
	] fork.

	w := SpButtonPresenter new 
		label: 'Stop now';
		action: [ aProcess terminate. w close ];
		openWithSpec.
]

{ #category : #accessing }
BlMouseMoveBenchmark >> benchDuration: anObject [

	benchDuration := anObject
]

{ #category : #private }
BlMouseMoveBenchmark >> benchFindEventTargetOn: aSpace at: mouseMovePosition [

	^ [ aSpace root findMouseEventTargetAt: mouseMovePosition ]
		benchFor: benchDuration

]

{ #category : #accessing }
BlMouseMoveBenchmark >> delayBetweenEventDispatchs: anObject [

	delayBetweenEventDispatchs := anObject
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

{ #category : #initialization }
BlMouseMoveBenchmark >> initialize [ 

	super initialize.

	extent := 200@200.

	benchDuration := 5 seconds.
	
	delayBetweenEventDispatchs := 5 milliSeconds.

	nestingLevel := 3.

	geometries := {
		BlEllipseGeometry new.
		BlRoundedRectangleGeometry cornerRadius: 20.
		BlSquareGeometry new.
		BlRectangleGeometry new.
"		BlPolygonGeometry vertices: { 0@0. 1000@0. 1000@1000 }."
		BlCircleGeometry new.
		BlTriangleGeometry new }

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
BlMouseMoveBenchmark >> nestingLevel: anObject [

	nestingLevel := anObject
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
			relocate: 0@0;
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
		addChild: elements first;
		addChild:
			(self newPointerElement
				relocate: eventPosition;
				yourself);
		extent: extent;
		title: aGeometry asString;
		show;
		yourself.
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
