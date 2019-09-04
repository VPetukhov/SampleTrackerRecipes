#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: conos.R
inputs:
  input_files:
    type: string[]
    label: file
    format: http://localhost/rds
    inputBinding:
      position: 1
  name:
    type: string
    default: null
    inputBinding:
      prefix: --name
  n_jobs:
    type: int
    default: 1
    inputBinding:
      prefix: --jobs
  n_pcs:
    type: int
    default: 100
    inputBinding:
      prefix: --n-pcs
  n_od_genes:
    type: int
    default: 1000
    inputBinding:
      prefix: --n-od-genes
  k_neighbors:
    type: int
    default: 30
    inputBinding:
      prefix: -k
  k_inter_neighbors:
    type: int
    default: 5
    inputBinding:
      prefix: --k-self
  space:
    type: string
    default: PCA
    inputBinding:
      prefix: --space
  embedding:
    type: string
    default: largeVis
    inputBinding:
      prefix: --embedding
  resolution:
    type: int
    default: 1
    inputBinding:
      prefix: --resolution
outputs:
  plots:
    type: File
    outputBinding:
      glob: graph.pdf
  object:
    type: File
    outputBinding:
      glob: conos.rds
