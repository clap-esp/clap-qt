#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "ffmpeghandler.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    qmlRegisterType<FFmpegHandler>("FFmpegModule", 1, 0, "FFmpegHandler");
    const QUrl url(QStringLiteral("qrc:/clap_v1/Main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
