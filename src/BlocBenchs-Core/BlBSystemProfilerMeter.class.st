Class {
	#name : #BlBSystemProfilerMeter,
	#superclass : #BlBMeter,
	#instVars : [
		'profiler'
	],
	#category : #'BlocBenchs-Core-Core'
}

{ #category : #'as yet unclassified' }
BlBSystemProfilerMeter >> reportResultsFrom: aBlBBlocBenchRunner in: aBlBResult [ 

	| flameGraph |
	
	flameGraph := profiler saucoAsReport 
			colorMap:
				(SaCategoryPrefixColorMap new 
					mapPrefixes: #(
						'OSWindow'
						'Alexandrie')
						from: Color lightBlue;
					mapPrefixes: #(
						'Bloc-Text'
						'BlocHost'
						'Bloc')
						from: Color orange;
					mapPrefixes: #(
						'Album'
						'Toplo')
						from: Color pink;
					yourself)	.
	
	aBlBResult 
		addField: #systemProfilerReport 
		title: 'System Profiler Report'
		value: profiler report.

	aBlBResult 
		addField: #flameGraph 
		title: 'Flame Graph'
		value: flameGraph.

]

{ #category : #'as yet unclassified' }
BlBSystemProfilerMeter >> startMetering: aBlBBlocBenchRunner [ 
	
	profiler := AndreasSystemProfiler new.
	profiler startProfiling
]

{ #category : #'as yet unclassified' }
BlBSystemProfilerMeter >> stopMetering: aBlBBlocBenchRunner [ 
	
	profiler stopProfiling
]
