Class {
	#name : #BlFrameMeter,
	#superclass : #BlMeter,
	#instVars : [
		'process',
		'framesAndMicrosendTimestamps',
		'frameCount'
	],
	#category : #'BlocBenchs-Old-ProfileCases'
}

{ #category : #private }
BlFrameMeter >> fpsFrom: frameAndMicrosendTimestampA to: frameAndMicrosendTimestampB [

	| totalSeconds |
	totalSeconds := (Duration microSeconds:
		frameAndMicrosendTimestampB value - frameAndMicrosendTimestampA value) totalSeconds.

	^ (frameAndMicrosendTimestampB key - frameAndMicrosendTimestampA key) / totalSeconds

]

{ #category : #accessing }
BlFrameMeter >> intermediateFPS [

	^ framesAndMicrosendTimestamps overlappingPairsCollect: [ :a :b | 
		  self fpsFrom: a to: b ]
]

{ #category : #private }
BlFrameMeter >> registerSampleNow [

	framesAndMicrosendTimestamps add:
		frameCount -> Time microsecondClockValue
]

{ #category : #printing }
BlFrameMeter >> reportAsStringOn: stream [

	stream
		<< 'Number of samples:';
		lf;
		tab;
		print: framesAndMicrosendTimestamps size;
		lf.

	framesAndMicrosendTimestamps size >= 1 ifFalse: [ ^ self ].

	stream
		<< 'Frame count:';
		lf;
		tab;
		print: framesAndMicrosendTimestamps last key;
		lf.

	framesAndMicrosendTimestamps size >= 2 ifFalse: [ ^ self ].

	stream
		<< 'FPS mean and error margin (90% confidence level):';
		lf;
		tab;
		<< (MeanConfidenceIntervalPrinter new print: self intermediateFPS);
		lf.

	framesAndMicrosendTimestamps size > 2 ifFalse: [ ^ self ].

	stream << 'FPS samples:'; lf.
	self intermediateFPS withIndexDo: [ :fps :index |
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
	"Start a high-priority process that will tally the space's frame id. The id of a space increases on every new frame.
	"

	| delay |
	framesAndMicrosendTimestamps := OrderedCollection new.
	delay := Delay forSeconds: 1.

	"Count frames"
	frameCount := 0.
	case space
		addEventHandlerOn: BlSpaceRenderEndEvent
		do: [ :evt |
		frameCount := frameCount + 1 ].


	[	process := Processor activeProcess.

		[[ process == Processor activeProcess ] whileTrue: [

			"Add a new sample"
			self registerSampleNow.
			
			delay wait.
		]] onErrorDo:[ :e | process := nil. e traceCr ]
	] forkAt: Processor highestPriority - 1

]

{ #category : #API }
BlFrameMeter >> stopMetering [

	process terminate.
	process := nil.
]

{ #category : #accessing }
BlFrameMeter >> totalFPS [

	^ self
		  fpsFrom: framesAndMicrosendTimestamps first
		  to: framesAndMicrosendTimestamps last
]

{ #category : #accessing }
BlFrameMeter >> totalSeconds [
	"Answer the number of elapsed seconds, expressed as a Float."

	^ (Duration microSeconds: framesAndMicrosendTimestamps last value
		   - framesAndMicrosendTimestamps first value) totalSeconds
]
