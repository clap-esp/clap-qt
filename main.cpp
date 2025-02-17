#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "notificationType.h"
#include "pythonexecutor.h"
#include <QProcessEnvironment>


int main(int argc, char *argv[])
{

    qputenv("QML_XHR_ALLOW_FILE_READ", "1");
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/clap_v1/Main.qml"));
    qmlRegisterUncreatableType<NotificationTypeClass>("notification.type", 1, 0, "NotificationTypeClass", "Not creatable as it is an enum type");
    qmlRegisterType<PythonExecutor>("python.executor", 1, 0, "PythonExecutor");



    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
