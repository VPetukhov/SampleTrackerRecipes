#!/usr/bin/env cwl-runner

# $dropest_dir/dropest -w -M -u -G 20 -g $gtf_file -c $config_file ../02_alignment/Aligned.out.bam

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [dropest, -w, -M, -u, -P]
stdout: logs.txt
requirements:
  - class: InlineJavascriptRequirement
inputs:
  config_file:
    type: string
    inputBinding:
      position: 1
      prefix: -c
  min_n_genes:
    type: int
    inputBinding:
      position: 3
      prefix: -G
  alignment_bam:
    type: File
    inputBinding:
      position: 5
outputs:
  count_data:
    type: File
    outputBinding:
      glob: cell.counts.rds
  logs:
    type: stdout
