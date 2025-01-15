Class {
	#name : #BlBError,
	#superclass : #Error,
	#instVars : [
		'exception'
	],
	#category : #'BlocBenchs-Core-Errors'
}

{ #category : #signalling }
BlBError class >> signalFor: anException [

	self new
		exception: anException;
		messageText: anException messageText;
		signal
]

{ #category : #accessing }
BlBError >> exception [

	^ exception
]

{ #category : #accessing }
BlBError >> exception: anObject [

	exception := anObject
]
