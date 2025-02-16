#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "notificationType.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/clap_v1/Main.qml"));
    qmlRegisterUncreatableType<NotificationTypeClass>("notification.type", 1, 0, "NotificationTypeClass", "Not creatable as it is an enum type");

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
