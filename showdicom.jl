using DICOM, Lucas

for name in ARGS
    print("FILE: ", name)
    dcm = dcm_parse(open(name));
    for el in dcm
        display(el)
        println()
    end
end
