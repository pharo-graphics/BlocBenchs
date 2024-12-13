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

{ #category : #accessing }
BlBVersionsMeter >> osName [
	
	^ OSPlatform current in: [:p | 
		p platformName , ' ' , p processorArchitecture ] 
]

{ #category : #accessing }
BlBVersionsMeter >> osVersion [
	
	^ OSPlatform current version 
]

{ #category : #reporting }
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

{ #category : #accessing }
BlBVersionsMeter >> repositoriesVersions [
	
	^ IceRepository registry 
		reject: [ :e | e location isNil ]
		thenCollect: [ :e | {e name. e description} ]
]

{ #category : #mettering }
BlBVersionsMeter >> startMetering: aBlBBlocBenchRunner [ 

]

{ #category : #mettering }
BlBVersionsMeter >> stopMetering: aBlBBlocBenchRunner [ 

]

{ #category : #accessing }
BlBVersionsMeter >> vmVersioon [
	
	^ Smalltalk vm version
]
