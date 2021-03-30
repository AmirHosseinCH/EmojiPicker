#ifndef EMOJIMODEL_H
#define EMOJIMODEL_H

#include <QObject>
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>

class EmojiModel : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString iconsPath WRITE setIconsPath)
    Q_PROPERTY(QString iconsType WRITE setIconsType)
public:
    EmojiModel();
    void setIconsPath(QString);
    void setIconsType(QString);
public slots:
    int count(QString);
    QString path(QString, int, int = -1);
    QVector<QString> search(QString, int = -1);
private:
    QString iconsPath;
    QString iconsType;
    QMap<QString, QJsonArray> emojies;
    QMap<QString, QVector<QJsonObject>> keywords;
};

#endif
