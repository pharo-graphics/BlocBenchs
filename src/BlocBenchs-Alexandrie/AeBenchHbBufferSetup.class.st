Class {
	#name : 'AeBenchHbBufferSetup',
	#superclass : 'Object',
	#category : 'BlocBenchs-Alexandrie',
	#package : 'BlocBenchs-Alexandrie'
}

{ #category : 'bench' }
AeBenchHbBufferSetup >> compareAlternatives [
	<script: 'self new compareAlternatives'>

	| ref ps |
	ref :=
		AeHbBuffer new
			direction: AeHbDirection leftToRight;
			script: AeHbScript latin;
			language: AeHbLanguage en;
			yourself.
	ps := ref segmentProperties.
			
	{[ AeHbBuffer new
			direction: AeHbDirection leftToRight;
			script: AeHbScript latin;
			language: AeHbLanguage en ].
	[ AeHbBuffer new guessSegmentProperties ].
	[ AeHbBuffer new segmentProperties: ps ]}
		collect: [ :each |
			(each bench executionsPerSecond // 1000) traceCr ].
]
