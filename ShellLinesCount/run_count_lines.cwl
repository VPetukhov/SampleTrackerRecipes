#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: line_counter.sh
inputs:
  message:
    type: string
    inputBinding:
      position: 1
  input_file:
    type: string
    label: file
    inputBinding:
      position: 2
outputs:
  result:
    type: File
    outputBinding:
      glob: sum.txt
