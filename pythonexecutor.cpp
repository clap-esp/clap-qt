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
    connect(process, &QProcess::readyReadStandardError, this, [this]() {
        emit scriptError(process->readAllStandardError());
    });
}

QString PythonExecutor::executeScript(const QString &scriptName) {

    QString scriptPath = QUrl(scriptName).toLocalFile();

    scriptPath=QCoreApplication::applicationDirPath() + "/sweet_cacao/Scripts/" + scriptName;

    qDebug() << "Chemin final utilisé pour le script Python :" << scriptPath;

    QString pythonExecutable = QCoreApplication::applicationDirPath() + "/sweet_cacao/venv/Scripts/python.exe";

    qDebug() << "python executable :" << pythonExecutable;

    if (!QFile::exists(pythonExecutable)) {
        return "Error: Python executable not found in virtual environment.";
    }

    QProcessEnvironment env = QProcessEnvironment::systemEnvironment();

    env.insert("PATH", QCoreApplication::applicationDirPath() + "/sweet_cacao/venv/Scripts");

    process->setProcessEnvironment(env);


    if (!QFile::exists(scriptPath)) {
        return "Error: Script file not found at " + scriptPath;
    }

    if(!process->waitForStarted()) {
        return "Error: Could not start process.";
    }

    // if (!process->waitForFinished()) {
    //     return "Error: Process did not finish in time.";
    // }

    return process->readAllStandardOutput();
}




QString PythonExecutor::executeTranscription(const QString &scriptName, const QStringList &args ) {

    QString scriptPath = QUrl(scriptName).toLocalFile();


    QString videoFile = args[0];
    QUrl videoUrl(videoFile);
    QString videoPath= videoUrl.toLocalFile();

    scriptPath=QCoreApplication::applicationDirPath() + "/clap_v1/Scripts/" + scriptName;

    qDebug() << "Chemin final utilisé pour le script Python :" << scriptPath;

    QString pythonExecutable = QCoreApplication::applicationDirPath() + "/clap_v1/venv/Scripts/python.exe";

    qDebug() << "python executable :" << pythonExecutable;

    if (!QFile::exists(pythonExecutable)) {
        qDebug() <<"Error: Python executable not found in virtual environment.";
    }

    QProcessEnvironment env = QProcessEnvironment::systemEnvironment();

    env.insert("PATH", QCoreApplication::applicationDirPath() + "/clap_v1/venv/Scripts");

    process->setProcessEnvironment(env);

    QString audioPath="C:/Users/hadja/clap-ai-core/API/audio_before_derush/audio_extrait.wav";

    process->start(pythonExecutable, QStringList() << scriptPath << videoPath << audioPath);


    if (!QFile::exists(scriptPath)) {
        return "Error: Script file not found at " + scriptPath;
    }

    if(!process->waitForStarted()) {
        return "Error: Could not start process.";
    }

    if (!process->waitForFinished()) {
        return "Error: Process did not finish in time.";
    }

    return process->readAllStandardOutput();
}
