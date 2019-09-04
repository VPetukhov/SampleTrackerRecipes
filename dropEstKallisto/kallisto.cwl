#!/usr/bin/env cwl-runner

# kallisto quant --pseudobam --single -i ~/genome_indexes/kallisto/mm10.index -o ./k50 -l 50 -s 10 ../01_dropTag/SCG_71_C2_S2_R1_001.fastq.gz.tagged.1.fastq.gz

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [kallisto, quant, --pseudobam, --single, -o, "alignment"]
stdout: alignment.sam
inputs:
  kallisto_index:
    type: string
    inputBinding:
      position: 1
      prefix: -i
  fragment_length:
    type: int
    inputBinding:
      position: 2
      prefix: -l
  fragment_sd:
    type: int
    inputBinding:
      position: 3
      prefix: -s
  fastqs:
    type: File[]
    inputBinding:
      position: 4
outputs:
  alignment_sam:
    type: stdout
