EpMonitor disableDuring: [
  Author useAuthor: 'Load' during: [
    [	Metacello new
        baseline: 'BlocBenchs';
        repository: 'github://pharo-graphics/BlocBenchs:dev-1.0/src';
        onConflictUseIncoming;
        ignoreImage;
        load.
    ]	on: MCMergeOrLoadWarning
      do: [ :warning | warning load ] ] ]
