#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "PythonExecutor.h"

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    PythonExecutor pythonExecutor;

    // Enregistrez le backend dans le contexte QML
    engine.rootContext()->setContextProperty("pythonExecutor", &pythonExecutor);

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
