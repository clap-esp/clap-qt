import cv2
import json
import os
import sys
from utils.logger import build_logger

logger= build_logger('THUMBNAILS GENERATION', level=20)

if len(sys.argv) > 3:
    video_path = sys.argv[1]
    project_name = sys.argv[2]
    project_app_data =sys.argv[3]

else:
    raise ValueError("Le chemin de la vidéo n'a pas été fourni !")


OUTPUT_DEFAULT_PROJECT_THUMBNAIL=os.path.join(project_app_data, project_name, "thumbs")
OUTPUT_PROJECT_METADATA_PATH=os.path.join(project_app_data, project_name, "metadata")

logger.info(f'path ===>{OUTPUT_DEFAULT_PROJECT_THUMBNAIL} ')
logger.info(f'new path ===>{project_app_data} ')


def generate_thumbnails(video_path,  interval=1000):

    cap = cv2.VideoCapture(video_path)
    fps = cap.get(cv2.CAP_PROP_FPS)
    duration = int(cap.get(cv2.CAP_PROP_FRAME_COUNT) / fps * 1000)
    thumbnail_data_config={
        "thumbnails": []
    }

    current_time = 0
    index = 0

    while current_time < duration:
        cap.set(cv2.CAP_PROP_POS_MSEC, current_time)
        ret, frame = cap.read()
        if not ret:
            break

        if index == 0 :

            path= os.path.join(OUTPUT_DEFAULT_PROJECT_THUMBNAIL, "project_thumbnail.jpg")
            logger.info(os.access(OUTPUT_DEFAULT_PROJECT_THUMBNAIL, os.W_OK))
            cv2.imwrite(path,frame)


        resized_frame = cv2.resize(frame, (100,50))
        image_config_path= os.path.join(OUTPUT_DEFAULT_PROJECT_THUMBNAIL,f"thumb_{index}.jpg" )
        cv2.imwrite(image_config_path, resized_frame)

        thumbnail_data_config["thumbnails"].append({
            "path": image_config_path
        })

        current_time += interval
        index += 1

    cap.release()

    json_config_path=os.path.join(OUTPUT_PROJECT_METADATA_PATH, "thumbnails.json")
    with open(json_config_path, "w") as json_file:
        json.dump(thumbnail_data_config, json_file, indent=4)

    logger.info(f'Toutes les miniatures ont été générées avec succès.')

    return json_path



generate_thumbnails(video_path)
