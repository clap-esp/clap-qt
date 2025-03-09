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

    Q_INVOKABLE void executeTranscription(const QStringList &args = {});

    Q_INVOKABLE void executeThumbnailsGeneration(const QString &projectName,const QStringList &args = {});

    Q_INVOKABLE void executeTranslation(const QStringList &args = {});

    // Q_INVOKABLE QString executeDerush(const QString &scriptName, const QStringList &args = {});

    // Q_INVOKABLE QString executeTranslation(const QString &scriptName, const QStringList &args = {});


signals:
    void scriptOutput(const QString &output);
    void scriptError(const QString &error);
    void scriptFinished();
    void scriptStarted();

private:
    QProcess *process;
};

#endif
