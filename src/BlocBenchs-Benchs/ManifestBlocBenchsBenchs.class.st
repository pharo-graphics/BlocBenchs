"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestBlocBenchsBenchs,
	#superclass : #PackageManifest,
	#category : #'BlocBenchs-Benchs-Manifest'
}

{ #category : #'code-critics' }
ManifestBlocBenchsBenchs class >> ruleClassNotReferencedRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGPackageDefinition #(#'BlocBenchs-Benchs')) #'2024-12-03T13:20:52.64557+01:00') )
]
