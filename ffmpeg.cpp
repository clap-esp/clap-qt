#include <QCoreApplication>
#include <QProcess>
#include <QDebug>

class FFmpegHandler : public QObject {
    Q_OBJECT

public:
    explicit FFmpegHandler(QObject *parent = nullptr) : QObject(parent) {}

    Q_INVOKABLE void processVideo(const QString &inputFile) {
        QString outputFile = "output.mp4";
        QStringList arguments;
        arguments << "-i" << inputFile << "-b:v" << "1M" << "-s" << "640x360" << outputFile;

        QProcess *process = new QProcess(this);
        process->start("ffmpeg", arguments);

        connect(process, &QProcess::finished, this, [=](int exitCode, QProcess::ExitStatus exitStatus) {
            if (exitStatus == QProcess::CrashExit) {
                qDebug() << "FFmpeg crashed !";
            }
            process->deleteLater();
        });
    }
};
