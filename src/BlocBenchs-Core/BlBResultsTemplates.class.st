Class {
	#name : #BlBResultsTemplates,
	#superclass : #Object,
	#instVars : [
		'templatesDirectory'
	],
	#category : #'BlocBenchs-Core-Exporter'
}

{ #category : #'as yet unclassified' }
BlBResultsTemplates class >> checkIcon [

	^ '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512" width="20" height="20">
		<path d="M438.6 105.4c12.5 12.5 12.5 32.8 0 45.3l-256 256c-12.5 12.5-32.8 12.5-45.3 0l-128-128c-12.5-12.5-12.5-32.8 0-45.3s32.8-12.5 45.3 0L160 338.7 393.4 105.4c12.5-12.5 32.8-12.5 45.3 0z"/></svg>'
]

{ #category : #'as yet unclassified' }
BlBResultsTemplates class >> crossIcon [

	^ '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 384 512"  width="20" height="20">
<path d="M342.6 150.6c12.5-12.5 12.5-32.8 0-45.3s-32.8-12.5-45.3 0L192 210.7 86.6 105.4c-12.5-12.5-32.8-12.5-45.3 0s-12.5 32.8 0 45.3L146.7 256 41.4 361.4c-12.5 12.5-12.5 32.8 0 45.3s32.8 12.5 45.3 0L192 301.3 297.4 406.6c12.5 12.5 32.8 12.5 45.3 0s12.5-32.8 0-45.3L237.3 256 342.6 150.6z"/></svg>'
]

{ #category : #'as yet unclassified' }
BlBResultsTemplates class >> dashIcon [

	^ '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512" width="20" height="20">
<path d="M432 256c0 17.7-14.3 32-32 32L48 288c-17.7 0-32-14.3-32-32s14.3-32 32-32l352 0c17.7 0 32 14.3 32 32z"/></svg>'
]

{ #category : #'as yet unclassified' }
BlBResultsTemplates class >> equalsIcon [

	^ '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512"  width="20" height="20">
	<path d="M48 128c-17.7 0-32 14.3-32 32s14.3 32 32 32l352 0c17.7 0 32-14.3 32-32s-14.3-32-32-32L48 128zm0 192c-17.7 0-32 14.3-32 32s14.3 32 32 32l352 0c17.7 0 32-14.3 32-32s-14.3-32-32-32L48 320z"/></svg>'
]

{ #category : #copying }
BlBResultsTemplates >> copyAllResourcesTo: aDirectory [

	(templatesDirectory / 'resources') copyAllTo: aDirectory 
]

{ #category : #accessing }
BlBResultsTemplates >> header [

	^ (templatesDirectory / 'header.html') contents
]

{ #category : #accessing }
BlBResultsTemplates >> index [

	^ (templatesDirectory / 'index.html') contents
]

{ #category : #initialization }
BlBResultsTemplates >> initialize [

	super initialize.

	templatesDirectory := (IceRepository registry detect: [ :e |
		                       e name = 'BlocBenchs' ]) location / 'templates'.
]

{ #category : #'as yet unclassified' }
BlBResultsTemplates >> partials [

	^ { 'header' -> self header } asDictionary 
]
