import cv2
import json
import os
import sys

OUTPUT_THUMBNAILS_PATH = os.path.join(os.path.dirname(__file__), '..', '..', '..', '..','API','tmp', 'thumbnails')

def generate_thumbnails(video_path, output_folder, interval=3000):
    if not os.path.exists(output_folder):
        os.makedirs(output_folder)

    cap = cv2.VideoCapture(video_path)
    fps = cap.get(cv2.CAP_PROP_FPS)
    duration = int(cap.get(cv2.CAP_PROP_FRAME_COUNT) / fps * 1000)

    thumbnail_data = {
        "video_path": video_path,
        "thumbnails": []
    }

    current_time = 0
    index = 0

    while current_time < duration:
        cap.set(cv2.CAP_PROP_POS_MSEC, current_time)
        ret, frame = cap.read()
        if not ret:
            break

        image_path = os.path.join(output_folder, f"thumb_{index}.jpg")
        cv2.imwrite(image_path, frame)

        thumbnail_data["thumbnails"].append({
            "time": current_time,
            "path": image_path
        })

        current_time += interval
        index += 1

        print(f"[LOG] Miniature générée : {image_path}")

    cap.release()

    json_path = os.path.join(output_folder, "thumbnails.json")
    with open(json_path, "w") as json_file:
        json.dump(thumbnail_data, json_file, indent=4)

    print("[LOG] Toutes les miniatures ont été générées avec succès.")

    return json_path

if len(sys.argv) > 1:
    video_path = sys.argv[1]
else:
    raise ValueError("Le chemin de la vidéo n'a pas été fourni !")

generate_thumbnails(video_path, OUTPUT_THUMBNAILS_PATH)
