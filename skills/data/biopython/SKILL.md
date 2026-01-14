---
name: biopython
description: Use when "Biopython", "bioinformatics", "sequence analysis", "FASTA", "GenBank", or asking about "DNA sequence", "protein sequence", "BLAST", "phylogenetics", "NCBI Entrez", "PDB structure", "sequence alignment"
version: 1.0.0
---

<!-- Adapted from: claude-scientific-skills/scientific-skills/biopython -->

# Biopython Computational Biology

Python tools for biological computation - sequences, alignments, databases, structures.

## When to Use

- Working with DNA/RNA/protein sequences
- Parsing biological files (FASTA, GenBank, PDB)
- Accessing NCBI databases (GenBank, PubMed)
- Running BLAST searches
- Sequence alignment and analysis
- Phylogenetic trees

## Quick Start

```python
from Bio import SeqIO
from Bio.Seq import Seq

# Create sequence
seq = Seq("ATGCGATCGATCG")
print(seq.complement())
print(seq.translate())

# Read FASTA file
for record in SeqIO.parse("sequences.fasta", "fasta"):
    print(f"{record.id}: {len(record.seq)} bp")
```

## Sequence Operations

```python
from Bio.Seq import Seq

seq = Seq("ATGCGATCGATCG")

# Basic operations
seq.complement()          # TACGCTAGCTAGC
seq.reverse_complement()  # CGATCGATCGCAT
seq.transcribe()          # AUGCGAUCGAUCG
seq.translate()           # MRS

# GC content
from Bio.SeqUtils import gc_fraction
gc = gc_fraction(seq)
```

## File I/O

```python
from Bio import SeqIO

# Read sequences
records = list(SeqIO.parse("input.fasta", "fasta"))
record = SeqIO.read("single.fasta", "fasta")  # Single sequence

# Write sequences
SeqIO.write(records, "output.fasta", "fasta")

# Convert formats
SeqIO.convert("input.gb", "genbank", "output.fasta", "fasta")

# Supported formats: fasta, genbank, fastq, embl, swiss, pdb-atom, etc.
```

## NCBI Entrez Access

```python
from Bio import Entrez

# Always set email
Entrez.email = "your.email@example.com"

# Search PubMed
handle = Entrez.esearch(db="pubmed", term="CRISPR", retmax=10)
results = Entrez.read(handle)
print(f"Found {results['Count']} results")

# Fetch GenBank record
handle = Entrez.efetch(db="nucleotide", id="NM_001301717", rettype="gb")
record = SeqIO.read(handle, "genbank")
print(record.description)

# Search protein database
handle = Entrez.esearch(db="protein", term="insulin[gene] AND human[organism]")
results = Entrez.read(handle)
```

## BLAST

```python
from Bio.Blast import NCBIWWW, NCBIXML

# Run BLAST online
result_handle = NCBIWWW.qblast("blastn", "nt", sequence)

# Parse results
blast_records = NCBIXML.parse(result_handle)
for record in blast_records:
    for alignment in record.alignments:
        for hsp in alignment.hsps:
            if hsp.expect < 1e-10:
                print(f"Hit: {alignment.title}")
                print(f"E-value: {hsp.expect}")
```

## Sequence Alignment

```python
from Bio import Align

# Pairwise alignment
aligner = Align.PairwiseAligner()
aligner.mode = 'global'  # or 'local'

alignments = aligner.align("ACCGGT", "ACGGT")
print(alignments[0])
print(f"Score: {alignments[0].score}")

# Read alignment file
from Bio import AlignIO
alignment = AlignIO.read("alignment.fasta", "fasta")
```

## PDB Structures

```python
from Bio.PDB import PDBParser, PDBIO

# Parse PDB file
parser = PDBParser()
structure = parser.get_structure("protein", "1abc.pdb")

# Navigate structure hierarchy
for model in structure:
    for chain in model:
        for residue in chain:
            for atom in residue:
                print(atom.get_coord())

# Calculate distances
atom1 = structure[0]['A'][100]['CA']
atom2 = structure[0]['A'][200]['CA']
distance = atom1 - atom2
```

## Phylogenetics

```python
from Bio import Phylo

# Read tree
tree = Phylo.read("tree.nwk", "newick")

# Display
Phylo.draw_ascii(tree)

# Traverse
for clade in tree.find_clades():
    print(clade.name)
```

## Common Patterns

### Download and Analyze

```python
from Bio import Entrez, SeqIO

Entrez.email = "your@email.com"

# Fetch sequence
handle = Entrez.efetch(db="nucleotide", id="NM_001301717", rettype="fasta")
record = SeqIO.read(handle, "fasta")

# Analyze
print(f"Length: {len(record.seq)}")
print(f"GC content: {gc_fraction(record.seq):.2%}")
```

### Batch Processing

```python
from Bio import SeqIO

# Process large file efficiently
with open("output.fasta", "w") as out:
    for record in SeqIO.parse("large.fasta", "fasta"):
        if len(record.seq) > 1000:
            SeqIO.write(record, out, "fasta")
```

## Best Practices

1. **Always set Entrez.email** (required by NCBI)
2. **Use iterators** for large files (`SeqIO.parse` not `list()`)
3. **Rate limit NCBI requests** (3/sec without API key)
4. **Handle exceptions** for network operations

## Resources

- Docs: <https://biopython.org/wiki/Documentation>
- Tutorial: <https://biopython.org/DIST/docs/tutorial/Tutorial.html>
