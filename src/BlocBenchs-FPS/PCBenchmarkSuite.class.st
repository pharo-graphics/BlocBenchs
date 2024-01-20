Class {
	#name : #PCBenchmarkSuite,
	#superclass : #Object,
	#instVars : [
		'cases',
		'numberOfSeconds',
		'benchmarkers',
		'timeToWaitBetweenCases'
	],
	#category : #'BlocBenchs-FPS-Suite'
}

{ #category : #adding }
PCBenchmarkSuite >> addAlexandrieBenchmarker [

	benchmarkers add: PCBlocAlexandrieBenchmarker new
]

{ #category : #adding }
PCBenchmarkSuite >> addCase: aPCBenchCase [ 
	
	cases add: aPCBenchCase
]

{ #category : #adding }
PCBenchmarkSuite >> addHeadlessBenchmarker [

	benchmarkers add: PCHeadlessBenchmarker new
]

{ #category : #adding }
PCBenchmarkSuite >> addRawBenchmarker [

	benchmarkers add: PCRawBenchmarker new
]

{ #category : #accessing }
PCBenchmarkSuite >> benchmarkers [

	^ benchmarkers
]

{ #category : #accessing }
PCBenchmarkSuite >> benchmarkers: aCollection [

	benchmarkers := aCollection
]

{ #category : #accessing }
PCBenchmarkSuite >> cases [

	^ cases
]

{ #category : #accessing }
PCBenchmarkSuite >> cases: aCollection [

	cases := aCollection
]

{ #category : #initialization }
PCBenchmarkSuite >> initialize [

	super initialize.
	
	cases := OrderedCollection new.
	benchmarkers := OrderedCollection new.
	timeToWaitBetweenCases := 1 second.
	numberOfSeconds := 5.
]

{ #category : #accessing }
PCBenchmarkSuite >> numberOfSeconds [

	^ numberOfSeconds
]

{ #category : #accessing }
PCBenchmarkSuite >> numberOfSeconds: anObject [

	numberOfSeconds := anObject
]

{ #category : #running }
PCBenchmarkSuite >> run [

	cases do: [ :eachCase |
		eachCase numberOfSeconds: numberOfSeconds.
		benchmarkers do: [ :eachBenchmarker |
			Smalltalk garbageCollect. timeToWaitBetweenCases wait.
			
			eachBenchmarker
			   case: eachCase;
			   run;
			   shortReportOnStdout;
			   shortReportOnTranscript ] ]
]

{ #category : #running }
PCBenchmarkSuite >> runInForkWithGUI [

	| b p w remainingCasesToBench |
	self flag: #todo. "separate GUI from this logic"
	
	w := SpButtonPresenter new 
		label: 'Stop benchmark suite now';
		action: [ p terminate. b closeWindow. w close ];
		open.

	p := [
		remainingCasesToBench := cases size * benchmarkers size.
		cases do: [ :eachCase |
			eachCase numberOfSeconds: numberOfSeconds.
			benchmarkers do: [ :eachBenchmarker |

				w title: ('Remaining time: {1}' format: {
					(numberOfSeconds seconds + timeToWaitBetweenCases)
						* remainingCasesToBench }). 
				remainingCasesToBench := remainingCasesToBench - 1.

				Smalltalk garbageCollect. timeToWaitBetweenCases wait.
				
				b := eachBenchmarker.
				b
				   case: eachCase;
				   run;
				   shortReportOnStdout;
				   shortReportOnTranscript ] ].
			w close.
		] fork

]
