#ifndef FFMPEGHANDLER_H
#define FFMPEGHANDLER_H

#include <QObject>
#include <QProcess>

class FFmpegHandler : public QObject {
    Q_OBJECT
public:
    explicit FFmpegHandler(QObject *parent = nullptr);

    Q_INVOKABLE void processVideo(const QString &inputPath, const QString &outputDir);

signals:
    void processingFinished(const QString &outputPath);

private slots:
    void handleProcessFinished(int exitCode, QProcess::ExitStatus exitStatus);

private:
    QProcess *ffmpegProcess;
};

#endif // FFMPEGHANDLER_H
