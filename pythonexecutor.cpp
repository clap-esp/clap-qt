#include "pythonexecutor.h"
#include <QDebug>

PythonExecutor::PythonExecutor(QObject *parent) : QObject(parent) {
    process = new QProcess(this);
    connect(process, &QProcess::readyReadStandardOutput, this, [this]() {
        emit scriptOutput(process->readAllStandardOutput());
    });
    connect(process, &QProcess::readyReadStandardError, this, [this]() {
        emit scriptError(process->readAllStandardError());
    });
}

QString PythonExecutor::executeScript(const QString &scriptPath, const QStringList &args) {
    process->start("python3", QStringList() << scriptPath << args);
    if(!process->waitForStarted()) {
        return "Error: Could not start process.";
    }

    if (!process->waitForFinished()) {
        return "Error: Process did not finish in time.";
    }

    return process->readAllStandardOutput();
}
