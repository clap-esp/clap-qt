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
        Video/VideoTimeline.qml
        Video/ButtonPlayer.qml
        Video/VideoSlider.qml
        Video/TimeCode.qml
        SpeechConversion/TextBlock.qml
        SpeechConversion/SpeechConversionWidget.qml
        SpeechConversion/Header.qml
        Elements/CheckBoxCustom.qml
        Elements/ButtonCustom.qml
        Utils/Notification/Error.qml
        Utils/Notification/Success.qml
        Utils/Constants.qml
        Notification/NotificationComponent.qml
        Data/transcription.json

    RESOURCES
        images/camera.png
        images/logo-no-background.png
        images/pause.png images/play.png
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
)

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

target_link_libraries(appclap_v1
    PRIVATE Qt6::Quick Qt6::quickmultimedia
)

include(GNUInstallDirs)
install(TARGETS appclap_v1
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
