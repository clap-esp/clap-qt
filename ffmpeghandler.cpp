#include "ffmpeghandler.h"
#include <QDebug>
#include <QDir>
#include <QUrl>
#include <QFileInfo>

FFmpegHandler::FFmpegHandler(QObject *parent) : QObject(parent), ffmpegProcess(new QProcess(this)) {
    connect(ffmpegProcess, SIGNAL(finished(int, QProcess::ExitStatus)), this, SLOT(handleProcessFinished(int, QProcess::ExitStatus)));
}

void FFmpegHandler::processVideo(const QString &inputPath, const QString &outputDir) {
    QString localInputPath = QUrl(inputPath).toLocalFile();
    QString localOutputDir = QUrl(outputDir).toLocalFile();

    QString outputFilePath = QDir(localOutputDir).filePath(QFileInfo(localInputPath).baseName() + "_processed.mp4");

    // Exemple de commande FFmpeg pour réduire la résolution et le bitrate
    QStringList arguments;
    arguments << "-i" << localInputPath
              << "-vf" << "scale=480:-1" // Redimensionner à 480 pixels de largeur
              << "-c:v" << "libx264"     // Utiliser le codec vidéo H.264
              << "-preset" << "slow"     // Vitesse de compression (peut être medium ou fast selon vos besoins)
              << "-crf" << "23"          // Valeur de compression (0-51; plus bas = meilleure qualité)
              << "-b:a" << "128k"        // Bitrate audio
              << outputFilePath;

    qDebug() << "Starting FFmpeg with arguments: " << arguments.join(" ");

    ffmpegProcess->start("ffmpeg", arguments);
}

void FFmpegHandler::handleProcessFinished(int exitCode, QProcess::ExitStatus exitStatus) {
    if (exitCode == 0 && exitStatus == QProcess::NormalExit) {
        QString outputPath = ffmpegProcess->arguments().last();
        qDebug() << "FFmpeg process finished. Output file:" << outputPath;
        emit processingFinished(outputPath);  // Émettre le signal avec le chemin du fichier de sortie
    } else {
        qDebug() << "FFmpeg process failed. Exit code:" << exitCode;
    }
}
