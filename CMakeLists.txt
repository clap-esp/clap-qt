cmake_minimum_required(VERSION 3.16)

project(clap_v1 VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.4 REQUIRED COMPONENTS Quick Multimedia)

qt_standard_project_setup()

qt_add_executable(appclap_v1

)

qt_add_qml_module(appclap_v1
    URI clap_v1
    VERSION 1.0
    QML_FILES
        Main.qml
        BarMenu.qml
        windows/ImportWindow.qml
        windows/ParameterWindow.qml
        windows/MainWindow.qml
        Video/VideoWidget.qml
        Video/ButtonPlayer.qml
        SpeechConversion/TextBlock.qml
        SpeechConversion/SpeechConversionWidget.qml
        SpeechConversion/Header.qml
        Timeline/ScrollableTimeline.qml
        Timeline/TimelineView.qml
        Timeline/VideoClip.qml
        Elements/CheckBoxCustom.qml
        Elements/ButtonCustom.qml
        Utils/Notification/Error.qml
        Utils/Notification/Success.qml
        Utils/Constants.qml
        Utils/IsoLanguageCode.qml
        Notification/NotificationWidget.qml
        Loading/LoadingWidget.qml
        API/utils/__init__.py
        API/utils/audio_extractor.py
        API/utils/common_functions.py
        API/utils/compact_json_encoder.py
        API/utils/format_functions.py
        API/utils/lang_functions.py
        API/utils/lang_map.py
        API/utils/ner_functions.py
        API/utils/srt_functions.py
        API/utils/stt_functions.py
        API/utils/speech_to_text.py
        API/utils/logger.py
        API/app_derush.py
        API/app_transcription.py
        API/app_translation.py
        API/generate_thumbnails.py
        ProjectsList/ProjectsList.qml
        ProjectsList/SuppressConfirmation.qml
        requirements.txt

    RESOURCES
        images/settings.png
        images/camera.png
        images/logo-no-background.png
        images/pause.png images/play.png
        images/video.png
        images/translate.png
        images/exportation.png
        images/wand.png
        images/dots.png
        images/info.png
        Utils/Icons/camera.png
        Utils/Icons/fast-forward.png
        Utils/Icons/logo.png
        Utils/Icons/pause.png
        Utils/Icons/play.png
        Utils/Icons/rewind.png
        Notification/Icons/erreur.png
        Notification/Icons/error.png
        Notification/Icons/success.png
        Notification/Icons/warning.png

    SOURCES
        main.cpp
        notificationType.cpp
        notificationType.h
        pythonexecutor.cpp
        pythonexecutor.h
        projectmanager.cpp
        projectmanager.h
)


find_package(Qt6 REQUIRED COMPONENTS Quick Concurrent)
target_link_libraries(appclap_v1 PRIVATE Qt6::Quick Qt6::Concurrent)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appclap_v1 PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appclap_v1
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

# file(COPY ${CMAKE_SOURCE_DIR}/Data DESTINATION ${CMAKE_BINARY_DIR})

target_link_libraries(appclap_v1
    PRIVATE Qt6::Quick Qt6::Multimedia
)

include(GNUInstallDirs)
install(TARGETS appclap_v1
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

