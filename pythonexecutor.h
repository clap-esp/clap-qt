#ifndef PYTHONEXECUTOR_H
#define PYTHONEXECUTOR_H

#include <QObject>
#include <QString>
#include <QProcess>

class PythonExecutor : public QObject
{
    Q_OBJECT
public:
    explicit PythonExecutor(QObject *parent = nullptr);

    Q_INVOKABLE QString executeScript(const QString &scriptPath, const QStringList &args = {});

signals:
    void scriptOutput(const QString &output);
    void scriptError(const QString &error);

private:
    QProcess *process;
};

#endif // PYTHONEXECUTOR_H
