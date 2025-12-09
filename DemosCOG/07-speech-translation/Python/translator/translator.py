from dotenv import load_dotenv
from datetime import datetime
import os

# Import namespaces
# Import namespaces
from azure.core.credentials import AzureKeyCredential
import azure.cognitiveservices.speech as speech_sdk
import pygame # to play the WAV file


def main():
    try:
        global speech_config
        global translation_config
        # Get Configuration Settings
        load_dotenv()
        cog_key = os.getenv('KEY')
        cog_region = os.getenv('REGION')
        # Configure translation
        translation_config = speech_sdk.translation.SpeechTranslationConfig(cog_key, cog_region)
        translation_config.speech_recognition_language = 'en-US'
        translation_config.add_target_language('fr')
        translation_config.add_target_language('es')
        translation_config.add_target_language('hi')
        translation_config.add_target_language('pt')

        
        print('Ready to translate from',translation_config.speech_recognition_language)
        # Configure speech
        speech_config = speech_sdk.SpeechConfig(cog_key, cog_region)
        # Get user input
        targetLanguage = ''
        while targetLanguage != 'quit':
            targetLanguage = input('\nEnter a target language\n fr = French\n es = Spanish\n hi = Hindi\n pt = Portuguese\n Enter anything else to stop\n').lower()
            if targetLanguage in translation_config.target_languages:
                Translate(targetLanguage)
            else:
                targetLanguage = 'quit'
                
    except Exception as ex:
        print(ex)
def Translate(targetLanguage):
    translation = ''
    # Translate speech (wav)
    # audioFile = 'station.wav'

    # pygame.init()
    # audioplay = pygame.mixer.Sound(audioFile)
    #audioplay.play() # Playing the WAV File

    # audio_config = speech_sdk.AudioConfig(filename=audioFile)
    # translator = speech_sdk.translation.TranslationRecognizer(translation_config, audio_config = audio_config)
    # print("Getting speech from file...")
    # result = translator.recognize_once_async().get()
    # print('Translating "{}"'.format(result.text))
    # translation = result.translations[targetLanguage]
    # print(translation)

    audio_config = speech_sdk.AudioConfig(use_default_microphone=True)
    translator = speech_sdk.translation.TranslationRecognizer(translation_config, audio_config = audio_config)
    print("Speak now...")
    result = translator.recognize_once_async().get()
    print('Translating "{}"'.format(result.text))
    translation = result.translations[targetLanguage]
    print(translation)

    # Synthesize translation
    voices = {
            "fr": "fr-FR-HenriNeural",
            "es": "es-ES-ElviraNeural",
            "hi": "hi-IN-MadhurNeural",
            "pt": "pt-BR-LeticiaNeural"
    }
    speech_config.speech_synthesis_voice_name = voices.get(targetLanguage)
    speech_synthesizer = speech_sdk.SpeechSynthesizer(speech_config)
    speak = speech_synthesizer.speak_text_async(translation).get()
    if speak.reason != speech_sdk.ResultReason.SynthesizingAudioCompleted:
        print(speak.reason)

if __name__ == "__main__":
    main()