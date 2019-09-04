#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [droptag, -n, "./dt_reads"]
requirements:
  - class: InlineJavascriptRequirement
inputs: # TODO: add num of threads
  config_file:
    type: string
    inputBinding:
      position: 1
      prefix: -c
  read1_file:
    type: string
    inputBinding:
      position: 3
  read2_file:
    type: string
    inputBinding:
      position: 4
  gene_file:
    type: string
    inputBinding:
      position: 5
outputs:
  demultiplexed_fastqs:
    type:
      type: array
      items: File
    outputBinding:
      glob: "./dt_reads*.fastq.gz"
