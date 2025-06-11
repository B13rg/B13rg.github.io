from pdf2image import convert_from_path

filename = "CIA-RDP82-00047R000100160001-1"

images = convert_from_path("./"+filename+".pdf", dpi=300)
for i, image in enumerate(images):
    image.save(f"{filename}_output_{i}.png", "PNG")