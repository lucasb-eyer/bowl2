# bowl2
Some stuff for Kaggle's NDSB2

# Utilities

## `dicom.jl`

Requirements:

- `Pkg.install("DocOpt")`
- `Pkg.install("DICOM")`
- `Pkg.clone("https://github.com/lucasb-eyer/Lucas.jl.git")`

Type `julia dicom.jl` to see the commandline reference.
Simple examples follow.

```
# Show all tags of two files.
> julia dicom.jl show file1.dcm file2.dcm

# Show the pixel-spacing tag of three files.
> julia dicom.jl show --tag=0x0028,0x0030 file1.dcm file2.dcm file3.dcm

# Show all tags of all training files. (Long!)
> julia dicom.jl show --dir=train

# Write the (2D, single slice) image in CSV format to `file1.dcm.csv`:
> julia dicom.jl dump file1.dcm
```
