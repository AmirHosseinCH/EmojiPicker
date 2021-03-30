#include "emojimodel.h"

EmojiModel::EmojiModel() {
    QFile file(":/emoji.json");
    file.open(QIODevice::ReadOnly);
    QByteArray data = file.readAll();
    file.close();
    QJsonDocument doc = QJsonDocument::fromJson(data);
    QJsonObject rootObj = doc.object();
    for (auto category{rootObj.begin()}; category != rootObj.end(); ++category) {
        emojies[category.key()] = category.value().toArray();
        QJsonArray& emojiesData = emojies[category.key()];
        for (auto it{emojiesData.begin()}; it != emojiesData.end(); ++it) {
            QJsonObject emoji = it->toObject();
            QJsonArray allKeywords = emoji.value("keywords").toArray();
            for (auto k{allKeywords.begin()}; k != allKeywords.end(); ++k) {
                keywords[k->toString()].append(emoji);
            }
        }
    }
}

int EmojiModel::count(QString category) {
    return emojies[category].size();
}

QString EmojiModel::path(QString category, int index, int skinColor) {
    QJsonObject emoji = emojies[category][index].toObject();
    if (emoji.contains("types") && skinColor != -1) {
        QJsonArray types = emoji.value("types").toArray();
        return iconsPath + types[skinColor].toString() + iconsType;
    }
    else
        return iconsPath + emoji.value("code").toString() + iconsType;
}

QVector<QString> EmojiModel::search(QString searchKey, int skinColor) {
    bool foundFirstItem{false};
    QVector<QString> searchResult;
    for (auto it{keywords.begin()}; it != keywords.end(); ++it) {
        if (it.key().startsWith(searchKey)) {
            QVector<QJsonObject>& emojiesData{it.value()};
            for (auto emoji{emojiesData.begin()}; emoji != emojiesData.end(); ++emoji) {
                if (emoji->contains("types") && skinColor != -1) {
                    QJsonArray types = emoji->value("types").toArray();
                    QString path = iconsPath + types[skinColor].toString() + iconsType;
                    if (!searchResult.contains(path))
                        searchResult.append(path);
                }
                else {
                    QString path = iconsPath + emoji->value("code").toString() + iconsType;
                    if (!searchResult.contains(path))
                        searchResult.append(path);
                }
            }
            foundFirstItem = true;
        }
        else if (foundFirstItem) {
            break;
        }
    }
    return searchResult;
}

void EmojiModel::setIconsPath(QString path) {
    iconsPath = path;
}

void EmojiModel::setIconsType(QString type) {
    iconsType = type;
}
