Class {
	#name : #BlFrameMeter,
	#superclass : #BlMeter,
	#category : #'BlocBenchs-Old-ProfileCases'
}

{ #category : #printing }
BlFrameMeter >> reportAsStringOn: stream [

	| stats fpsSamples |
	
	stats := case space spaceStatistics.
	fpsSamples := stats fpsSamples allButFirst collect: [:e | e second].

	stream
		<< 'Number of samples:';
		lf;
		tab;
		print: fpsSamples size;
		lf.

	stream
		<< 'Frame count:';
		lf;
		tab;
		print: stats totalFrames;
		lf.

	fpsSamples ifEmpty: [ ^ self ].

	stream
		<< 'FPS mean and error margin (90% confidence level):';
		lf;
		tab;
		<< (MeanConfidenceIntervalPrinter new print: fpsSamples);
		lf.

	stream << 'FPS samples:'; lf.
	fpsSamples withIndexDo: [ :fps :index |
		stream
			tab;
			print: index;
			<< '-';
			print: index + 1;
			<< ': ';
			<< (fps printShowingDecimalPlaces: 1);
			<< ' fps';
			lf ]

]

{ #category : #API }
BlFrameMeter >> reportsAsPagesUsing: aBuilder [

	^ { (SpNotebookPage title: 'Frame Report' provider: [ 
		   aBuilder newText
			   text: self reportAsString;
			   yourself ]) }
]

{ #category : #API }
BlFrameMeter >> startMetering [

	case space enableStatistics
]

{ #category : #API }
BlFrameMeter >> stopMetering [
	
	
]
