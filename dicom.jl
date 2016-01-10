using DICOM, Lucas
using DocOpt

args = docopt("""showdicom.jl

Usage:
  dicom.jl show [-v] [--tag=<tag>] (--dir=<dir> | <files>...)
  dicom.jl (dump | debug) [-v] (--dir=<dir> | <files>...)
  dicom.jl -h | --help

Options:
  -h --help     Show this screen.
  -v --verbose  Show more verbose output.
  --tag=<tag>   Shows only one specific tag (tag syntax is 0xabcd,0x1234).
  --dir=<dir>   Use all files of `dir`, which is either `train` or `test`.
""")

if args["--tag"] != nothing
    args["--tag"] = tuple([parse(UInt16, t) for t in split(args["--tag"], ',')]...)
end

if args["--dir"] != nothing
    println("Collecting files...")
    args["<files>"] = UTF8String[]
    for d in readdir(args["--dir"])
        patientdir = joinpath(args["--dir"], d, "study")
        for s in readdir(patientdir)
            for f in readdir(joinpath(patientdir, s))
                if splitext(f)[2] == ".dcm"
                    push!(args["<files>"], joinpath(patientdir, s, f))
                end
            end
        end
    end
end

for name in args["<files>"]
    if args["--verbose"]
        println("FILE: ", name)
        println("=====")
    end
    dcm = dcm_parse(open(name));

    if args["show"]
        for el in dcm
            if args["--tag"] == nothing || el.tag == args["--tag"]
                print(el.tag, ": ")
                display(el)
                println()
            end
        end
    elseif args["dump"]
        # Dumps the image into a csv file.
        if (el = DICOM.lookup(dcm, (0x7fe0,0x0010))) != false
            writecsv("$name.csv", el.data[1][:,:,1])
            # TODO: Possibly also dump these. at least look into them!
            tags = Dict(
                (0x0008,0x0008) => "imtype",  # Image Type
                (0x0008,0x0060) => "modality",  # Modality: ASCIIString["MR"]
                (0x0008,0x0070) => "manuf",  # Manufacturer: ASCIIString["SIEMENS"]
                (0x0008,0x103e) => "series",  # Series Description: ASCIIString["2ch"]
                (0x0008,0x1090) => "model",  # Manufacturer's Model Name: ASCIIString["Aera"]
                (0x0018,0x0022) => "opts",  # Scan Options: ASCIIString["CT"]
                (0x0018,0x0023) => "aqtype",  # MR Acquisition Type: ASCIIString["2D"]
                (0x0018,0x0050) => "slice_thick",  # Slice Thickness: [8.0]
                (0x0018,0x1314) => "flip_angle",  # Flip Angle: [56.0]
                (0x0018,0x5100) => "pos",  # Patient Position: ASCIIString["HFS"]
                (0x0020,0x0032) => "imgpos",  # Image Position (Patient): [-87.771005468217,93.799321675558,195.08339402037]
                (0x0020,0x0037) => "imgori",  # Image Orientation (Patient): [0.8127451738409,-0.5549969637339,0.1772671787004,0.2130993502411,3.956532e-8,-0.9770305353093]
                (0x0020,0x1041) => "sliceloc",  # Slice Location: [53.505870937259]
                (0x0028,0x0004) => "photometric",  # Photometric Interpretation: ASCIIString["MONOCHROME2"]
                (0x0028,0x0030) => "pixelsp",  # Pixel Spacing: [1.40625,1.40625]
                (0x0028,0x1050) => "win_cent",  # Window Center: [344.0]
                (0x0028,0x1051) => "win_width",  # Window Width: [848.0]
                (0x0028,0x1055) => "win_expl",  # Window Center & Width Explanation: ASCIIString["Algo1"]
                (0x7fe0,0x0010) => "data",  # Variable Pixel Data: 256x192x1 Array{UInt16,3}:
            )
        end
    elseif args["debug"]
        # TODO: Write whatever code you're curious about right now here!

        # Show image size
        #if (el = DICOM.lookup(dcm, (0x7fe0,0x0010))) != false
        #    println(size(el.data[1]))
        #end

        # Check if "max pixel" == max(pixels) or not
        # Yes, it is.
        #maxpix = DICOM.lookup(dcm, (0x0028,0x0107)).data[1]
        #imgdata = DICOM.lookup(dcm, (0x7fe0,0x0010)).data[1]
        #println(maximum(imgdata) == maxpix)
    end
end
