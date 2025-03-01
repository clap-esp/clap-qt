import math
import os
from pydub import AudioSegment
import speech_recognition as sr

debug_mode = None
def log(message):
    if debug_mode:
        print(message)


def process_stt(audio_file_path): # for whisper
    pass

    # utiliser ce path pour les chunk
    # tmp_dir = os.path.join(os.path.dirname(__file__), '..', 'tmp')
    # chunks_dir = os.path.join(tmp_dir, 'chunks')
    # if not os.path.exists(chunks_dir):
    #     os.makedirs(chunks_dir)

    # audio = AudioSegment.from_wav(audio_file_path)





def process_stt_deprecated(audio_file_path, chunk_length_ms=4000):
    """Process the audio file and return a list of transcribed sentences with timestamps"""
    print(f"\nProcessing STT in progress...")
    print(f'\nAudio in process stt ====>{audio_file_path}')

    # Path
    tmp_dir = os.path.join(os.path.dirname(__file__), '..', 'tmp')
    chunks_dir = os.path.join(tmp_dir, 'chunks')
    if not os.path.exists(chunks_dir):
        os.makedirs(chunks_dir)

    audio = AudioSegment.from_wav(audio_file_path)

    # calculate number of chunks
    audio_length_ms = len(audio)
    num_chunks = math.ceil(audio_length_ms / chunk_length_ms)
    log(f"\nNumber of segments: {num_chunks}")
    log(f"Print each segment in terminal:")

    recognizer = sr.Recognizer()
    results = []

    for i in range(num_chunks):
        start_ms = i * chunk_length_ms
        end_ms = min((i + 1) * chunk_length_ms, audio_length_ms)
        chunk = audio[start_ms:end_ms]
        chunk_filename = os.path.join(chunks_dir, f"chunk_{i}.wav")

        chunk.export(chunk_filename, format="wav")  # export the chunk

        with sr.AudioFile(chunk_filename) as source:
            audio_data = recognizer.record(source)
            text = recognize(audio_data, recognizer)

            if text:  # only add to results if text was recognized
                result = {
                    "time_start": start_ms / 1000.0,  # Convert ms to seconds
                    "time_end": end_ms / 1000.0,
                    "text": text
                }
                results.append(result)

            log(f"{i}. {text}")

        os.remove(chunk_filename) # remove the chunk file as progresses

    return results


def recognize(audio_data, recognizer):
    """Method to recognize speech with audio chunk"""
    try:
        text = recognizer.recognize_google(audio_data)
        return text
    except sr.UnknownValueError:
        return "[Bruit]" # by default... this is temporary !!!
    except sr.RequestError as e:
        return f"Error requesting Google service: {e}"

def create_chunks_directory(dir_path):
    """Create the audio segment directory"""
    if not os.path.exists(dir_path):
        os.makedirs(dir_path)
