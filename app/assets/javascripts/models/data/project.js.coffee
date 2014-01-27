ns = @edsc.models.data

ns.Project = do (ko) ->

  class Project
    constructor: ->
      @_datasetIds = ko.observableArray()
      @_visibleDatasetIds = ko.observableArray()
      @_datasetsById = {}
      @datasets = ko.computed(read: @getDatasets, write: @setDatasets, owner: this)

    getDatasets: ->
      @_datasetsById[id] for id in @_datasetIds()

    setDatasets: (datasets) ->
      datasetIds = []
      datasetsById = {}
      for ds in datasets
        id = ds.id()
        datasetIds.push(id)
        datasetsById[id] = ds
      @_datasetsById = datasetsById
      @_datasetIds(datasetIds)
      null

    isEmpty: () ->
      @_datasetIds.isEmpty()

    toggleDataset: (dataset) =>
      if @hasDataset(dataset)
        @removeDataset(dataset)
      else
        @addDataset(dataset)
      null

    addDataset: (dataset) =>
      id = dataset.id()
      @_datasetsById[id] = dataset
      @_datasetIds.remove(id)
      @_datasetIds.push(id)
      null

    removeDataset: (dataset) =>
      id = dataset.id()
      delete @_datasetsById[id]
      @_datasetIds.remove(id)
      if @hasVisibleDataset(dataset)
        @_visibleDatasetIds.remove(dataset.id())
      null

    hasDataset: (other) =>
      @_datasetIds.indexOf(other.id()) != -1

    hasVisibleDataset: (dataset) =>
      @_visibleDatasetIds.indexOf(dataset.id()) != -1

    toggleVisibleDataset: (dataset) =>
      if @hasVisibleDataset(dataset)
        @_visibleDatasetIds.remove(dataset.id())
      else
        @_visibleDatasetIds.push(dataset.id())

  exports = Project
