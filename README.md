# bbmap
Small bbmap container


# how to run

```
# Run tools with proper bash support
docker run --platform linux/amd64 -v "$(pwd):/data"  picotainers/bbmap:latest bbduk.sh in=input.fastq out=filtered.fastq
docker run --platform linux/amd64 -v "$(pwd):/data"  picotainers/bbmap:latest bbmap.sh in=reads.fq ref=reference.fa out=mapped.sam

```
