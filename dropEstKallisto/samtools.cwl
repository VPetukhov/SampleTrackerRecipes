#!/usr/bin/env cwl-runner

# samtools view -Sb output.sam > output.bam

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [samtools, view, -Sb]
stdout: alignment.bam
inputs:
  sam_file:
    type: File
    inputBinding:
      position: 1
      prefix:
outputs:
  bam_file:
    type: stdout
