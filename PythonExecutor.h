#ifndef PYTHONEXECUTOR_H
#define PYTHONEXECUTOR_H

#include <QObject>
#include <QProcess>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QVariant>

class PythonExecutor : public QObject {
    Q_OBJECT
    Q_PROPERTY(QVariantList resultList READ resultList NOTIFY resultListChanged)

public:
    explicit PythonExecutor(QObject *parent = nullptr);

    Q_INVOKABLE void executeScript(const QString &scriptPath);

    QVariantList resultList() const;

signals:
    void resultListChanged();

private:
    QVariantList m_resultList;
};

#endif // PYTHONEXECUTOR_H
