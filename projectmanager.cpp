#include "projectmanager.h"

projectManager::projectManager(QObject *parent) : QObject(parent) {}

QString projectManager::generateProjectName() const {
    return "Projet_" + QDateTime::currentDateTime().toString("yyyyMMdd_HHmmss");
}

QString projectManager::createProject(const QString &videoFilePath, const QString &projectName) {
    QFileInfo fileInfo(videoFilePath);
    if (!fileInfo.exists()) {
        return "Error: File does not exist -> " + videoFilePath;
    }

    QString basePath = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation) + "/Clap/Projets/";
    QDir baseDir(basePath);
    if (!baseDir.exists()) {
        baseDir.mkpath(basePath);
    }

    QString finalProjectName = projectName.trimmed().isEmpty() ? generateProjectName() : projectName.trimmed();

    QString projectPath = basePath + finalProjectName + "/";
    QDir projectDir(projectPath);
    if (!projectDir.exists()) {
        projectDir.mkpath("metadata");
        projectDir.mkpath("thumbs");
    } else {
        return "Error: Project name already exists.";
    }

    QJsonObject videoMetadata = getVideoMetadata(videoFilePath);

    QString metadataFilePath = projectPath + "metadata/project.json";
    QFile jsonFile(metadataFilePath);
    if (jsonFile.open(QIODevice::WriteOnly)) {
        QJsonObject projectData;
        projectData["name"] = finalProjectName;
        projectData["creation_date"] = QDateTime::currentDateTime().toString(Qt::ISODate);

        QJsonArray videos;
        videos.append(videoMetadata);

        projectData["videos"] = videos;

        QJsonDocument doc(projectData);
        jsonFile.write(doc.toJson());
        jsonFile.close();
    }

    return projectPath;
}

QJsonObject projectManager::getVideoMetadata(const QString &videoFilePath) {
    QJsonObject metadata;
    QMediaPlayer mediaPlayer;
    QVideoSink videoSink;
    mediaPlayer.setSource(QUrl::fromLocalFile(videoFilePath));
    mediaPlayer.setVideoSink(&videoSink);

    metadata["filePath"] = videoFilePath;
    metadata["fileSize"] = QFile(videoFilePath).size();

    QEventLoop loop;
    QObject::connect(&mediaPlayer, &QMediaPlayer::durationChanged, [&]() {
        metadata["duration"] = mediaPlayer.duration() / 1000;
        loop.quit();
    });

    mediaPlayer.play();
    loop.exec();

    return metadata;
}
