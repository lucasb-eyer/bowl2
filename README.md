# bowl2
Some stuff for Kaggle's NDSB2

# Utilities

## `showdicom.jl`

Requirements:

- `Pkg.install("DICOM")`
- `Pkg.clone("https://github.com/lucasb-eyer/Lucas.jl.git")`

Usage:

```
> julia showdicom.jl FILE1 FILE2 ... FILEN
```

Shows all dicom tags of the file(s) and their values.
