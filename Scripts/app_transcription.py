import os
import sys
import json
from utils.audio_extractor import extract_audio_from_video
from utils.stt_functions import process_stt_deprecated # replace with process_stt
from utils.srt_functions import json_to_srt_transcription


# TRANSCRIPTION process - app
# This program is used for transcription

debug_mode = False # Debug mode setting
audio_path_wav = os.path.join(os.path.dirname(__file__), '..', '..' , 'clap-ai-core', 'API', 'audio_before_derush', 'audio_extrait.wav')
OUTPUT_STT_PATH = os.path.join(os.path.dirname(__file__), 'app_stt_output.json')

project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))

print('TRANSCRIPTION ?')

# ↓
# EXTRACT WAV process
video_path = ""
audio_path = " "
# example usage

if len(sys.argv) > 1:
    video_path = sys.argv[1]
    audio_path= sys.argv[2]
else:
    raise ValueError("Le chemin de la vidéo n'a pas été fourni !")

# video_path = os.path.join(os.path.dirname(__file__), '..', '..' , 'clap-ai-core', 'video', 'product_management.mp4')

# this function needs a video path as input
extract_audio_from_video(video_path)

# ↓
# STT
stt_result = process_stt_deprecated(audio_path) # replace with process_stt

# ↓
# LANG
# here, we will create a function to detect the language
lang = "fr"
# str_path = os.path.join(os.path.dirname(__file__), 'exports', f'app_subtitles_{lang}.srt')

# Définir le chemin du dossier `exports` dans le projet
exports_dir = os.path.join(project_root, 'exports')

# Vérifier si `exports/` existe, sinon le créer
if not os.path.exists(exports_dir):
    os.makedirs(exports_dir)

# Chemin du fichier SRT
str_path = os.path.join(exports_dir, f'app_subtitles_{lang}.srt')

# SRT
subtitles = json_to_srt_transcription(stt_result)
with open(str_path, "w", encoding="utf-8") as f:
    f.write(subtitles)
print(f"\nSRT output saved in {str_path}")

# ↓
# Save STT output in JSON
with open(OUTPUT_STT_PATH, 'w', encoding='utf-8') as json_file:
    json.dump(stt_result, json_file, ensure_ascii=False, indent=4)
print(f"\nJSON output STT saved in {OUTPUT_STT_PATH}")
