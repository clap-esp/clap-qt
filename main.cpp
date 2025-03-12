#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "projectmanager.h"
#include "notificationType.h"
#include "pythonexecutor.h"
#include <QProcessEnvironment>
#include <QDir>
#include "globalVariableManager.h"

int main(int argc, char *argv[])
{

    qputenv("QML_XHR_ALLOW_FILE_READ", "1");
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    projectManager projectManager;
    engine.rootContext()->setContextProperty("projectManager", &projectManager);

    engine.rootContext()->setContextProperty("globalVariable", &globalVariable);


    const QUrl url(QStringLiteral("qrc:/clap_v1/Main.qml"));
    qmlRegisterUncreatableType<NotificationTypeClass>("notification.type", 1, 0, "NotificationTypeClass", "Not creatable as it is an enum type");
    qmlRegisterType<PythonExecutor>("python.executor", 1, 0, "PythonExecutor");

    QString currentProjectDirectoryPath=QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/";
    engine.rootContext()->setContextProperty("currentProjectDirectoryPath", currentProjectDirectoryPath);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
