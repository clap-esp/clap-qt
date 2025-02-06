#ifndef PROJECTMANAGER_H
#define PROJECTMANAGER_H

#include <QObject>
#include <QString>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QFile>
#include <QDir>
#include <QDateTime>
#include <QStandardPaths>
#include <QMediaPlayer>
#include <QVideoSink>
#include <QEventLoop>


class projectManager : public QObject
{
    Q_OBJECT
public:
    explicit projectManager(QObject *parent = nullptr);

    Q_INVOKABLE QString createProject(const QString &videoFilePath, const QString &projectName);
    // Q_INVOKABLE QString addVideoToProject(const QString &projectPath, const QString &videoFilePath);

private:
    QString generateProjectName() const;
    QJsonObject getVideoMetadata(const QString &videoFilePath);
};

#endif // PROJECTMANAGER_H
