from PIL import Image
import pytesseract
import json
import os

nodes = [f for f in os.listdir('nodes') if os.path.isfile(os.path.join('nodes', f))]

output = {}
for filename in nodes:
    i = filename.split("_")[1].split(".")[0]
    text = pytesseract.image_to_string(Image.open("nodes/"+filename), config="digits --psm 7")
    print("Node "+i+": "+text)
    output[i] = text

with open('node_names.json', 'w') as fp:
    json.dump(output, fp)