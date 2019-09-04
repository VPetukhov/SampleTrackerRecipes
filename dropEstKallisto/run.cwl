#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
inputs:
  config_file:
    type: string
    label: file
    format: http://localhost/xml
  read1_file:
    type: string
    label: file
    format: http://localhost/gz
  read2_file:
    type: string
    label: file
    format: http://localhost/gz
  gene_file:
    type: string
    label: file
    format: http://localhost/gz
  kallisto_index:
    type: string
    label: file
    format: http://localhost/index
  fragment_length:
    type: int
    default: 50
  fragment_sd:
    type: int
    default: 10
  min_n_genes:
    type: int
    default: 15

outputs:
  aligned_bam:
    type: File
    outputSource: samtools/bam_file
  count_data:
    type: File
    outputSource: dropest/count_data

steps:
  droptag:
    run: droptag.cwl
    in:
      config_file: config_file
      read1_file: read1_file
      read2_file: read2_file
      gene_file: gene_file
    out: [demultiplexed_fastqs]

  kallisto:
    run: kallisto.cwl
    in:
      kallisto_index: kallisto_index
      fragment_length: fragment_length
      fragment_sd: fragment_sd
      fastqs: droptag/demultiplexed_fastqs
    out: [alignment_sam]

  samtools:
    run: samtools.cwl
    in:
      sam_file: kallisto/alignment_sam
    out: [bam_file]

  dropest:
    run: dropest.cwl
    in:
      config_file: config_file
      min_n_genes: min_n_genes
      alignment_bam: samtools/bam_file
    out: [count_data]
