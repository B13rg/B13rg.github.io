from pdf2image import convert_from_path
import pytesseract
# pip install --user pdf2img pytesseract
# brew install tesseract

filename = "CIA-RDP82-00047R000100160001-1"

images = convert_from_path("./"+filename+".pdf", dpi=600)
for i, image in enumerate(images):
    image.save(f"{filename}_output_{i}.png", "PNG")
    image = image.convert("L")  # Grayscale
    image = image.point(lambda p: p > 128 and 255)  # Binary threshold
    text = pytesseract.image_to_string(image, lang='eng')
    with open(f"{filename}_text_{i}.txt", "w") as f:
        f.write(text)
