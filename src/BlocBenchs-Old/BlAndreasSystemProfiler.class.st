Class {
	#name : #BlAndreasSystemProfiler,
	#superclass : #BlMeter,
	#instVars : [
		'profiler'
	],
	#category : 'BlocBenchs-Old-ProfileCases'
}

{ #category : #API }
BlAndreasSystemProfiler >> reportsAsPagesUsing: aBuilder [

	^ { 
	
	
	SpNotebookPage title: 'Report as String' provider: [
		(aBuilder newText
			   text: profiler report;
			   yourself) ].
		
	
	SpNotebookPage title: 'Flame Graph' provider: [
	
		profiler saucoAsReport 
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
					yourself)	;
			inspectionForFlameGraph: aBuilder.
			
		]
		 }

]

{ #category : #API }
BlAndreasSystemProfiler >> startMetering [

	profiler := AndreasSystemProfiler new.
	profiler startProfiling
]

{ #category : #API }
BlAndreasSystemProfiler >> stopMetering [

	profiler stopProfiling
]
