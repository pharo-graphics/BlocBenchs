Class {
	#name : #BlAndreasSystemProfiler,
	#superclass : #BlMeter,
	#instVars : [
		'profiler'
	],
	#category : #'BlocBenchs-MeteringCases'
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
					'Fenster'
					'Sparta-Cairo'
					'Sparta-Skia'
					'Sparta')
					from: (Color fromHexString: 'b721ff');
				mapPrefixes: #(
					'Bloc-Universe'
					'Bloc-Space'
					'BlocHost'
					'Bloc')
					from: (Color fromHexString: 'F1C40F');
				mapPrefixes: #(
					'BlocPac'
					'Brick'
					'Spec-Brick')
					from: (Color fromHexString: '009efd');
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
