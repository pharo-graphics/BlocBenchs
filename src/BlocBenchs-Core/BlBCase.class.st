Class {
	#name : #BlBCase,
	#superclass : #Object,
	#instVars : [
		'runner',
		'result',
		'duration'
	],
	#category : #'BlocBenchs-Core'
}

{ #category : #running }
BlBCase class >> isAbstract [

	^ self == BlBCase
]

{ #category : #running }
BlBCase class >> run [
	
	^ self new run
]

{ #category : #'accessing - defaults' }
BlBCase >> defaultDuration [
	
	^ 10 seconds 
]

{ #category : #accessing }
BlBCase >> duration [
	
	^ duration ifNil: [ self defaultDuration ]
]

{ #category : #accessing }
BlBCase >> duration: aDuration [ 
	
	duration := aDuration
]

{ #category : #accessing }
BlBCase >> label [

	^ self class name
]

{ #category : #running }
BlBCase >> run [

	^ self runner runCase: self
]

{ #category : #running }
BlBCase >> runner [

	^ runner ifNil: [ runner := self defaultRunnerClass new ]
]
