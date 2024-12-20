Class {
	#name : #BlBResultsTemplates,
	#superclass : #Object,
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

{ #category : #accessing }
BlBResultsTemplates >> header [

	^ '
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"  crossorigin="anonymous"></script>
    <title>{{pageTitle}}</title>
  </head>
'
]

{ #category : #accessing }
BlBResultsTemplates >> index [

	^ '
<!doctype html>
<html lang="en">
  {{> header }}
  <body>
    <h1>{{pageTitle}}</h1>

    <table class="table">
      <thead>
        <tr>
          <th scope="col">Bench Label</th>
          {{#imageVersions}}
          <th scope="col">{{.}}</th>
          {{/imageVersions}}
        </tr>
      </thead>
      <tbody>
        {{#benchs}}
        <tr>
          <td><a href="./cases/{{caseLabelAsFileName}}.html">{{caseLabel}}</a></td>
          {{#versionTicks}}
          <td>{{#.}}
					<span>{{{.}}}</span>
				  {{/.}}
			 </td>
          {{/versionTicks}}
        </tr>
        {{/benchs}}
      </tbody>
    </table>
  </body>
</html>
'
]

{ #category : #'as yet unclassified' }
BlBResultsTemplates >> partials [

	^ { 'header' -> self header } asDictionary 
]
