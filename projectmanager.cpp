#include "projectmanager.h"
#include <QCoreApplication>
#include <QDir>
#include <QDirIterator>


projectManager::projectManager(QObject *parent) : QObject(parent) {}

QString projectManager::generateProjectName() const {
    return "Projet_" + QDateTime::currentDateTime().toString("yyyyMMdd_HHmmss");
}


QString projectManager::findFolderByName( const QString &folderName){
    QString path=QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation) + "/Clap/Projets/";
    QDir dir(path);
    if (!dir.exists()) return "";
    QStringList folders = dir.entryList(QDir::Dirs | QDir::NoDotAndDotDot);
    if (folders.contains(folderName)) {
        return dir.absoluteFilePath(folderName);
    }

    return "";
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

    int countSubDirectories= baseDir.entryList(QDir::Dirs | QDir::NoDotAndDotDot).size();

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
        projectData["id"]=countSubDirectories+1;
        projectData["name"] = finalProjectName;
        projectData["creation_date"] = QDateTime::currentDateTime().toString(Qt::ISODate);
        projectData["thumbnail_project"]= QDir::cleanPath(QCoreApplication::applicationDirPath() + "/../../API/tmp/thumbnails/project_thumbnail.jpg");
        QJsonArray videos;
        videos.append(videoMetadata);

        projectData["videos"] = videos;

        QJsonDocument doc(projectData);
        jsonFile.write(doc.toJson());
        jsonFile.close();
    }

    return projectPath;
}


QJsonObject projectManager::getProjectsList(){
    QJsonArray projectsArray;
    QString rootPath= QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation) + "/Clap/Projets/";
    QDirIterator it(rootPath, QDir::Dirs | QDir::NoDotAndDotDot, QDirIterator::Subdirectories);

    while (it.hasNext()) {
        it.next();
        QString metadataPath = it.filePath() + "/metadata";

        QDir metadataDir(metadataPath);
        if (metadataDir.exists()) {
            QString jsonFilePath = metadataPath + "/project.json";

            QFile jsonFile(jsonFilePath);
            if (jsonFile.exists() && jsonFile.open(QIODevice::ReadOnly | QIODevice::Text)) {
                QByteArray jsonData = jsonFile.readAll();
                jsonFile.close();

                QJsonDocument doc = QJsonDocument::fromJson(jsonData);
                if (!doc.isNull() && doc.isObject()) {
                    QJsonObject projectData = doc.object();
                    projectData["path"] = jsonFilePath;
                    projectsArray.append(projectData);
                }
            }
        }
    }
    QJsonObject result;
    result["projects"] = projectsArray;
    return result;
};

QJsonObject projectManager::deleteProject(const QString &folderName){

    QString folderPath= findFolderByName(folderName);

    if(!(folderPath== "")){
        QDir dir(folderPath);
        dir.removeRecursively();

    }

    return getProjectsList();
};

void projectManager::updateProject(const QString &folderName, const QJsonObject &metaData){

};


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
