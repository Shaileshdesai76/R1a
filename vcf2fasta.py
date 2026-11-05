#!/usr/bin/env python3
import sys, subprocess
from collections import Counter

vcf, out = sys.argv[1], sys.argv[2]
samples = subprocess.check_output(["bcftools","query","-l",vcf]).decode().split()
seqs = [[] for _ in samples]
ref_counts = Counter()
nsites = 0
REF_GT = {"0","0/0","0|0"}
ALT_GT = {"1","1/1","1|1"}

p = subprocess.Popen(["bcftools","query","-f","%REF\t%ALT[\t%GT]\n",vcf],
                     stdout=subprocess.PIPE, text=True)
for line in p.stdout:
    f = line.rstrip("\n").split("\t")
    ref, alt, gts = f[0], f[1], f[2:]
    col = [ref if g in REF_GT else alt if g in ALT_GT else "N" for g in gts]
    if len(set(c for c in col if c != "N")) < 2:
        continue                      # not variable after genotype conversion
    for s, c in zip(seqs, col):
        s.append(c)
    ref_counts[ref] += 1
    nsites += 1

with open(out, "w") as o:
    for name, s in zip(samples, seqs):
        o.write(f">{name}\n{''.join(s)}\n")

print(f"samples: {len(samples)}  variable sites: {nsites}", file=sys.stderr)
print("ref base at variable sites:", dict(ref_counts), file=sys.stderr)
