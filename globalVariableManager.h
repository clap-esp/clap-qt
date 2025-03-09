#ifndef GLOBALVARIABLEMANAGER_H
#define GLOBALVARIABLEMANAGER_H
#include <QObject>
#include <QCoreApplication>

class GlobalVariableManager : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString currentProjectName READ currentProjectName WRITE setcurrentProjectName NOTIFY currentProjectNameChanged)
    Q_PROPERTY(QString currentSourceLang READ currentSourceLang WRITE setcurrentSourceLang NOTIFY currentSourceLangChanged)
    Q_PROPERTY(QString currentDestinationLang READ currentDestinationLang WRITE setcurrentDestinationLang NOTIFY currentDestinationLangChanged)
    Q_PROPERTY(QStringList translationHistory READ translationHistory WRITE setTranslationHistory NOTIFY translationHistoryChanged)



public:
    explicit GlobalVariableManager(QObject *parent = nullptr) :
        QObject(parent),
        current_project_name(""),
        current_source_lang("fr"),
        current_destination_lang(""),
        translation_history() {}

    Q_INVOKABLE QString currentProjectName() const { return current_project_name; }

    Q_INVOKABLE void setcurrentProjectName(const QString &text) {
        if (current_project_name != text) {
            current_project_name = text;
            emit currentProjectNameChanged();
        }
    }

    Q_INVOKABLE QString currentSourceLang() const { return current_source_lang; };
    Q_INVOKABLE void setcurrentSourceLang(const QString &text) {
        if (current_source_lang != text) {
            current_source_lang = text;
            emit currentSourceLangChanged();
        }
    }

    Q_INVOKABLE QString currentDestinationLang() const { return current_destination_lang; };
    Q_INVOKABLE void setcurrentDestinationLang(const QString &text) {
        if (current_destination_lang != text) {
            current_destination_lang = text;
            emit currentDestinationLangChanged();
        }
    }

    Q_INVOKABLE QStringList translationHistory() const {return translation_history;};
    Q_INVOKABLE void setTranslationHistory(const QStringList &history) {
        translation_history=history;
        emit translationHistoryChanged();
    }

signals:
    void currentProjectNameChanged();
    void currentSourceLangChanged();
    void currentDestinationLangChanged();
    void translationHistoryChanged();


private:
    QString current_project_name;
    QString current_source_lang;
    QString current_destination_lang;
    QStringList translation_history;

};

extern GlobalVariableManager globalVariable;


#endif // GLOBALVARIABLEMANAGER_H
