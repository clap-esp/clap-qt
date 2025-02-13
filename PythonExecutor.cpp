#include "PythonExecutor.h"

PythonExecutor::PythonExecutor(QObject *parent)
    : QObject(parent) {}

void PythonExecutor::executeScript(const QString &scriptPath) {
    QProcess process;
    process.start("python3", QStringList() << scriptPath);

    if (!process.waitForStarted()) {
        qWarning() << "Impossible de démarrer le script Python :" << scriptPath;
        return;
    }

    if (!process.waitForFinished()) {
        qWarning() << "Le script Python n'a pas pu se terminer :" << scriptPath;
        return;
    }

    // Lire la sortie JSON du script
    QString output = process.readAllStandardOutput();
    QJsonDocument jsonDoc = QJsonDocument::fromJson(output.toUtf8());

    if (!jsonDoc.isArray()) {
        qWarning() << "La sortie du script Python n'est pas un tableau JSON valide.";
        return;
    }

    // Convertir le JSON en QVariantList
    m_resultList = jsonDoc.array().toVariantList();
    emit resultListChanged();
}

QVariantList PythonExecutor::resultList() const {
    return m_resultList;
}
