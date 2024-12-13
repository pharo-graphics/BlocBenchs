Class {
	#name : #BlBVersionsMeter,
	#superclass : #BlBMeter,
	#category : #'BlocBenchs-Core-Core'
}

{ #category : #accessing }
BlBVersionsMeter >> imageVersion [

	^ SystemVersion current imageVersionString , 
		String crlf, 
		SystemVersion current datedVersion
]

{ #category : #'as yet unclassified' }
BlBVersionsMeter >> osName [
	
	^ OSPlatform current in: [:p | 
		p platformName , ' ' , p processorArchitecture ] 
]

{ #category : #'as yet unclassified' }
BlBVersionsMeter >> osVersion [
	
	^ OSPlatform current version 
]

{ #category : #'as yet unclassified' }
BlBVersionsMeter >> reportResultsFrom: aBlBBlocBenchRunner in: aBlBResult [ 

	aBlBResult
		addField: #repositoriesVersions
		title: 'Repositories Versions'
		value: self repositoriesVersions.
		
	aBlBResult
		addField: #imageVersion
		title: 'Pharo Image Version'
		value: self imageVersion.
	
	aBlBResult
		addField: #vmVersion
		title: 'Pharo VM Version'
		value: self vmVersioon.
		
	aBlBResult
		addField: #osName
		title: 'Operating System Name'
		value: self osName.
		
	aBlBResult
		addField: #osVersion
		title: 'Operating System Version'
		value: self osVersion.	
]

{ #category : #'as yet unclassified' }
BlBVersionsMeter >> repositoriesVersions [
	
	^ IceRepository registry 
		reject: [ :e | e location isNil ]
		thenCollect: [ :e | {e name. e description} ]
]

{ #category : #'as yet unclassified' }
BlBVersionsMeter >> startMetering: aBlBBlocBenchRunner [ 

]

{ #category : #'as yet unclassified' }
BlBVersionsMeter >> stopMetering: aBlBBlocBenchRunner [ 

]

{ #category : #'as yet unclassified' }
BlBVersionsMeter >> vmVersioon [
	
	^ Smalltalk vm version
]
