#include "pythonexecutor.h"
#include <QDebug>
#include <QUrl>
#include <QFile>
#include <QDir>
#include <QCoreApplication>


PythonExecutor::PythonExecutor(QObject *parent) : QObject(parent) {
    process = new QProcess(this);
    connect(process, &QProcess::readyReadStandardOutput, this, [this]() {
        emit scriptOutput(process->readAllStandardOutput());
    });

    connect(process, &QProcess::finished, this, &PythonExecutor::scriptFinished);

    connect(process, &QProcess::readyReadStandardError, this, [this]() {
        emit scriptError(process->readAllStandardError());
    });
}

void PythonExecutor::executeTranscription(const QStringList &args ) {

    QString scriptName="app_transcription.py";
    QString scriptPath = QUrl(scriptName).toLocalFile();
    QString videoFile = args[0];
    QString spokenLang= args[1];
    QUrl videoUrl(videoFile);
    QString videoPath= videoUrl.toLocalFile();

    scriptPath=QCoreApplication::applicationDirPath() + "/clap_v1/API/" + scriptName;

    QString pythonExecutable = QDir::cleanPath(QCoreApplication::applicationDirPath()) + "/../../venv/Scripts/python.exe";

    if (!QFile::exists(pythonExecutable)) {
        qDebug() <<"Error: Python executable not found in virtual environment.";
    }

    QProcessEnvironment env = QProcessEnvironment::systemEnvironment();

    env.insert("PATH", QDir::cleanPath(QCoreApplication::applicationDirPath()) + "/../../venv/Scripts/");

    process->setProcessEnvironment(env);

    process->start(pythonExecutable, QStringList() << scriptPath << videoPath << spokenLang);

    if (!QFile::exists(scriptPath)) {
        emit scriptError("Error: Script file not found!");
    }

    if(!process->waitForStarted()) {
        emit scriptError("Error: Could not start process.");
    }

    emit scriptStarted();
}


void PythonExecutor::executeThumbnailsGeneration(const QStringList &args ) {

    QString scriptName="generate_thumbnails.py";
    QString scriptPath = QUrl(scriptName).toLocalFile();
    QString videoFile = args[0];
    QUrl videoUrl(videoFile);
    QString videoPath= videoUrl.toLocalFile();

    scriptPath=QCoreApplication::applicationDirPath() + "/clap_v1/API/" + scriptName;

    qDebug() << "Chemin final utilisé pour le script Python :" << scriptPath;

    QString pythonExecutable = QDir::cleanPath(QCoreApplication::applicationDirPath()) + "/../../venv/Scripts/python.exe";

    qDebug() << "python executable :" << pythonExecutable;


    if (!QFile::exists(pythonExecutable)) {
        qDebug() <<"Error: Python executable not found in virtual environment.";
    }

    QProcessEnvironment env = QProcessEnvironment::systemEnvironment();

    env.insert("PATH", QDir::cleanPath(QCoreApplication::applicationDirPath()) + "/../../venv/Scripts/");

    process->setProcessEnvironment(env);

    process->start(pythonExecutable, QStringList() << scriptPath << videoPath );

    if (!QFile::exists(scriptPath)) {
        emit scriptError("Error: Script file not found!");
    }

    if(!process->waitForStarted()) {
        emit scriptError("Error: Could not start process.");
    }

    emit scriptStarted();

}

void PythonExecutor::executeTranslation(const QStringList &args ) {

    QString scriptName="app_translation.py";
    QString scriptPath = QUrl(scriptName).toLocalFile();
    QString lang = args[0];


    scriptPath=QCoreApplication::applicationDirPath() + "/clap_v1/API/" + scriptName;


    QString pythonExecutable = QDir::cleanPath(QCoreApplication::applicationDirPath()) + "/../../venv/Scripts/python.exe";


    if (!QFile::exists(pythonExecutable)) {
        qDebug() <<"Error: Python executable not found in virtual environment.";
    }

    QProcessEnvironment env = QProcessEnvironment::systemEnvironment();

    env.insert("PATH", QDir::cleanPath(QCoreApplication::applicationDirPath()) + "/../../venv/Scripts/");

    process->setProcessEnvironment(env);

    process->start(pythonExecutable, QStringList() << scriptPath << lang );

    if (!QFile::exists(scriptPath)) {
        emit scriptError("Error: Script file not found!");
    }

    if(!process->waitForStarted()) {
        emit scriptError("Error: Could not start process.");
    }

    emit scriptStarted();
}
