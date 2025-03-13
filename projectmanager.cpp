#include "projectmanager.h"
#include <QCoreApplication>
#include <QDir>
#include <QDirIterator>
#include "globalVariableManager.h"


projectManager::projectManager(QObject *parent) : QObject(parent) {}

QString projectManager::generateProjectName() const {
    return "Projet_" + QDateTime::currentDateTime().toString("yyyyMMdd_HHmmss");
}


QString projectManager::findFolderByName( const QString &folderName){
    QString path= QStandardPaths::writableLocation(QStandardPaths::MoviesLocation) + "/Clap/Projets/";
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

    qDebug() <<  QStandardPaths::writableLocation(QStandardPaths::MoviesLocation) + "/.clap";


    QString basePath =  QStandardPaths::writableLocation(QStandardPaths::MoviesLocation) + "/Clap/Projets/";

    QDir baseDir(basePath);
    if (!baseDir.exists()) {
        baseDir.mkpath(basePath);
    }

    int countSubDirectories= baseDir.entryList(QDir::Dirs | QDir::NoDotAndDotDot).size();

    QString finalProjectName = projectName.trimmed().isEmpty() ? generateProjectName() : projectName.trimmed();

    globalVariable.setcurrentProjectName(finalProjectName);

    QString projectPath = basePath + finalProjectName + "/";
    QDir projectDir(projectPath);
    if (!projectDir.exists()) {
        projectDir.mkpath("metadata");
        projectDir.mkpath("thumbs");
    } else {
        return "Error: Project name already exists.";
    }

    QJsonObject videoMetadata = getVideoMetadata(videoFilePath);

    QString metadataFilePath = projectPath + "metadata/config.json";
    QFile jsonFile(metadataFilePath);
    if (jsonFile.open(QIODevice::WriteOnly)) {
        QJsonObject projectData;
        projectData["id"]=countSubDirectories+1;
        projectData["name"] = finalProjectName;
        projectData["created_at"] = QDateTime::currentDateTime().toString(Qt::ISODate);
        projectData["updated_at"] = QDateTime::currentDateTime().toString(Qt::ISODate);
        projectData["thumbnail_project"]= basePath + finalProjectName + "/thumbs/project_thumbnail.jpg";
        projectData["translated_in"]=QJsonArray();
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
    QString rootPath=  QStandardPaths::writableLocation(QStandardPaths::MoviesLocation) + "/Clap/Projets/";
    QDirIterator it(rootPath, QDir::Dirs | QDir::NoDotAndDotDot, QDirIterator::Subdirectories);

    while (it.hasNext()) {
        it.next();
        QString metadataPath = it.filePath() + "/metadata";

        QDir metadataDir(metadataPath);
        if (metadataDir.exists()) {
            QString jsonFilePath = metadataPath + "/config.json";

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

void projectManager::updateProjectMetadata( const QJsonObject &metaData){
    QJsonObject baseConfigData;
    QString folderName=globalVariable.currentProjectName();
    QString metadataFilePath=QStandardPaths::writableLocation(QStandardPaths::MoviesLocation) + "/Clap/Projets/"+folderName+"/metadata/config.json";
    QFile jsonFile(metadataFilePath);


    if(jsonFile.open(QIODeviceBase::ReadWrite)){
        QByteArray jsonData = jsonFile.readAll();
        jsonFile.close();

        QJsonDocument doc = QJsonDocument::fromJson(jsonData);
        if (!doc.isNull() && doc.isObject()) {
            baseConfigData = doc.object();
            if(metaData.contains("translation")){
                QString newLang= metaData.value("translation").toString();
                QJsonArray translatedArray = baseConfigData.value("translated_in").toArray();
                if (!translatedArray.contains(newLang)) {
                    translatedArray.append(newLang);
                    baseConfigData["translated_in"] = translatedArray;
                    QStringList stringList;
                    for (const QJsonValue &value : translatedArray) {
                        if (value.isString()) {
                            stringList.append(value.toString());
                        }
                    }
                    globalVariable.setTranslationHistory(stringList);
                }
            }
        }

        qDebug() << globalVariable.translationHistory();
        baseConfigData["updated_at"]= QDateTime::currentDateTime().toString(Qt::ISODate);
        jsonFile.open(QIODevice::WriteOnly | QIODevice::Truncate);
        jsonFile.write(QJsonDocument(baseConfigData).toJson(QJsonDocument::Indented));
        jsonFile.close();

    }
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

bool projectManager::copyFileInProject(const QString &fileType){

    QString sourceJsonPath;
    QString sourceSrtPath;
    QString destinationJsonPath;
    QString destinationSrtPath;
    QString projectName=globalVariable.currentProjectName();

    qDebug() << "[LOG] copy file - type "+ fileType +" -- project "+ projectName;

    if(fileType=="transcription"){
        sourceJsonPath= QDir::cleanPath(QCoreApplication::applicationDirPath() + "/../../API/tmp/app_output_stt.json");
        sourceSrtPath= QDir::cleanPath(QCoreApplication::applicationDirPath() + "/../../API/tmp/app_output_stt.srt");
        destinationJsonPath= QStandardPaths::writableLocation(QStandardPaths::MoviesLocation) + "/Clap/Projets/"+ projectName+"/metadata/app_output_stt.json";
        destinationSrtPath= QStandardPaths::writableLocation(QStandardPaths::MoviesLocation) + "/Clap/Projets/"+ projectName+"/metadata/app_output_stt.srt";

    }else{
        QString spokenLang= globalVariable.currentDestinationLang();
        sourceJsonPath=  QDir::cleanPath(QCoreApplication::applicationDirPath() + "/../../API/tmp/app_subtitles_" +spokenLang+".json");
        sourceSrtPath=  QDir::cleanPath(QCoreApplication::applicationDirPath() + "/../../API/tmp/app_subtitles_" +spokenLang+".srt");
        destinationJsonPath= QStandardPaths::writableLocation(QStandardPaths::MoviesLocation) + "/Clap/Projets/"+ projectName+"/metadata/app_subtitles_" +spokenLang+".json";
        destinationSrtPath= QStandardPaths::writableLocation(QStandardPaths::MoviesLocation) + "/Clap/Projets/"+ projectName+"/metadata/app_subtitles_" +spokenLang+".srt";

        QJsonObject jsonObject;
        jsonObject["translation"] = spokenLang;
        updateProjectMetadata(jsonObject);

    }

    qDebug() << "[LOG] chemin source json " + sourceJsonPath;
    qDebug() << "[LOG] chemin source srt " + sourceSrtPath;
    qDebug() << "[LOG] chemin destination json " + destinationJsonPath;
    qDebug() << "[LOG] chemin destination srt " + destinationSrtPath;

    QFile sourceJsonFile(sourceJsonPath);
    QFile sourceSrtFile(sourceSrtPath);
    QFile destinationJsonFile(destinationJsonPath);
    QFile destinationSrtFile(destinationSrtPath);

    if(destinationJsonFile.exists()){
        destinationSrtFile.remove();
    }

    if(destinationSrtFile.exists()){
        destinationSrtFile.remove();
    }
    QFile::copy(sourceJsonPath, destinationJsonPath);
    QFile::copy(sourceSrtPath, destinationSrtPath);

    return true;

};


bool projectManager::copySubtitleJsonInTmp(){
    QString projectName=globalVariable.currentProjectName();
    QString sourceJsonPath=QStandardPaths::writableLocation(QStandardPaths::MoviesLocation) + "/Clap/Projets/"+ projectName+"/metadata/app_output_stt.json";;
    QString destinationJsonPath=QDir::cleanPath(QCoreApplication::applicationDirPath() + "/../../API/tmp/app_output_stt.json");;

    QFile sourceJsonFile(sourceJsonPath);
    QFile destinationJsonFile(destinationJsonPath);

    if(destinationJsonFile.exists()){
        destinationJsonFile.remove();
    }

    QFile::copy(sourceJsonPath, destinationJsonPath);

    return true;
};
