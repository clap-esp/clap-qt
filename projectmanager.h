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

    Q_INVOKABLE QJsonObject getProjectsList();

    Q_INVOKABLE QJsonObject deleteProject(const QString &folderName);

    Q_INVOKABLE bool copyFileInProject(const QString &fileType);

    Q_INVOKABLE bool copySubtitleJsonInTmp();

    Q_INVOKABLE void updateProjectMetadata(const QJsonObject &metaData);

    // Q_INVOKABLE QString addVideoToProject(const QString &projectPath, const QString &videoFilePath);

private:
    QString generateProjectName() const;
    QJsonObject getVideoMetadata(const QString &videoFilePath);
    QString findFolderByName(const QString &folderName);

};

#endif // PROJECTMANAGER_H
