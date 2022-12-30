Class {
	#name : #BlAndreasSystemProfiler,
	#superclass : #BlMeter,
	#instVars : [
		'profiler'
	],
	#category : #'BlocBenchs-Old-ProfileCases'
}

{ #category : #API }
BlAndreasSystemProfiler >> reportsAsPagesUsing: aBuilder [

	^ { 
	
	
	SpNotebookPage title: 'VM Stats' provider: [
		(aBuilder newText
			   text: (String streamContents: [ :strm |
			profiler reportGCStatsOn: strm.
			profiler reportProcessStatsOn: strm.
			]);
			   yourself) ].
		
	
	SpNotebookPage title: 'Flame Graph' provider: [
	
		profiler saucoAsReport 
			colorMap: (SaCategoryPrefixColorMap new 
					mapPrefixes: #(
						'Alexandrie')
						from: Color purple;
					mapPrefixes: #(
						'BlocHost'
						'Bloc-Text'
						'Bloc')
						from: Color orange;
					mapPrefixes: #(
						'BlocPac'
						'Brick'
						'Spec-Brick')
						from: Color lightBlue;
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
