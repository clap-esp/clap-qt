import os
import numpy as np
from moviepy.video.io.VideoFileClip import VideoFileClip

project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..' ))
OUTPUT_AUDIO_DIR=os.path.join(project_root,'API', 'tmp', 'audio_before_derush')

print(f'\n output audio directory => {OUTPUT_AUDIO_DIR}')

def extract_audio_from_video(video_path):
    # Path
    print(f"\nProcessing extraction in progress...")

    if OUTPUT_AUDIO_DIR and not os.path.exists(OUTPUT_AUDIO_DIR):
        os.makedirs(OUTPUT_AUDIO_DIR, exist_ok=True)
    output_audio_path = os.path.join(OUTPUT_AUDIO_DIR, 'audio_extrait.wav')
    # Extract audio
    clip = VideoFileClip(video_path)
    audio = clip.audio
    # Save WAV
    audio.write_audiofile(output_audio_path, codec='pcm_s16le')
    print(f'\naudio extracted in ===>, {output_audio_path}')
    clip.close()



# project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))


# output_audio_path = os.path.join(project_root, 'audio_before_derush')

# print('output audio path', output_audio_path)
# def extract_audio_from_video(video_path):
#     video = VideoFileClip(video_path)
#     audio = video.audio
#     if output_audio_path and not os.path.exists(output_audio_path):
#         os.makedirs(output_audio_path)
#     audio.write_audiofile(output_audio_path + '/audio_extrait.wav', codec='pcm_s16le')  # WAV format
#     video.close()
#     audio.close()

# import librosa
# from moviepy.editor import VideoFileClip

# cwd = os.getcwd()

# def remove_audio_file(audio: str) -> None:
#     """
#     Deletes the generated audio file after its features have been extracted.

#     :param audio: str - Path to the audio file to be removed.
#     :return: None
#     """
#     if os.path.exists(audio):
#         try:
#             os.remove(audio)
#         except OSError as e:
#             print(f"Something went wrong while removing {audio}: {e}")


# def make_dir(dir_path) -> None:
#     """
#     Creates a directory if it doesn't already exist.

#     :param dir_path: str - Path to the directory to be created.
#     :return: None
#     """
#     if not os.path.exists(dir_path):
#         try:
#             os.makedirs(dir_path)
#         except OSError as e:
#             print(f"Something went wrong while creating {dir_path}: {e}")


# def extract_audio_features(video) -> tuple[int | float, np.ndarray]:
#     """
#     Extracts audio features from a video file and returns the features and sampling rate.

#     :param video: str - Path to the video file from which audio features are extracted.
#     :return: tuple - A tuple containing the extracted audio features (ndarray) and the sampling rate (float).
#     """
#     print(f"Extracting audio features from video: {video}")
#     try:
#         print(cwd)
#         # Load video and extract audio
#         video_clip = VideoFileClip(video)
#         audio_clip: AudioFileClip = video_clip.audio

#         # Define the path for the temporary audio file
#         audio_file_path = os.path.join(cwd, "tmp", "audio.mp3")
#         dir_path = audio_file_path.rsplit("/", 1)[0]
#         make_dir(dir_path)

#         # Save audio to the temporary file
#         audio_clip.write_audiofile(audio_file_path)

#         # Close the video and audio clips
#         video_clip.close()
#         audio_clip.close()

#         # Load audio and extract features
#         audio = librosa.load(audio_file_path)
#         print(f"Extracted features: {audio}")

#         # Remove geneated audio once features has been extracted.
#         remove_audio_file(audio_file_path)

#         return audio[1], audio[0]

#     except Exception as e:
#         print(f"An error as occurred while extracting Audio from Video: {e}")
