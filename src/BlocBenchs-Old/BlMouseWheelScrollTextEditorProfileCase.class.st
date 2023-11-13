Class {
	#name : #BlMouseWheelScrollTextEditorProfileCase,
	#superclass : #BlTextEditorProfileCase,
	#category : 'BlocBenchs-Old-ProfileCases'
}

{ #category : #hooks }
BlMouseWheelScrollTextEditorProfileCase >> dispatchEvent [

	BlSpace simulateMouseWheelOn: editorElement by: (BlVector x: 0 y: -7)
]
