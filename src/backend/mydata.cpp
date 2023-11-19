#include "backend/mydata.h"

#include <QDir>
#include <QFile>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QVariantList>
#include <QDebug>

MyData::MyData()
{
  //toDo...
}

bool MyData::fileExists(QString path) {
  QFileInfo check_file(path);
  // check if file exists and if yes, Is it really a file!
  if (check_file.exists() && check_file.isFile()) {
      return true;
  }
  else {
      return false;
  }
}

QVariantList MyData::data() const
{
  return m_data;
}

void MyData::setData(const QVariantList& data)
{
  if (m_data == data)
    return;
  m_data = data;
  emit dataChanged(m_data);
}

int MyData::length() const
{
  return m_length;
}

void MyData::setLength(int length)
{
  if (m_length == length)
    return;
  m_length = length;
  emit lengthChanged(m_length);
}

bool MyData::result() const
{
  return m_result;
}

void MyData::setResult(bool result)
{
  if (m_result == result)
    return;
  m_result = result;
  emit resultChanged(m_result);
}

QString MyData::nextPageToken() const
{
  return m_nextPageToken;
}

void MyData::setNextPageToken(QString nextPageToken)
{
  if (m_nextPageToken == nextPageToken)
    return;
  m_nextPageToken = nextPageToken;
  emit nextPageTokenChanged(m_nextPageToken);
}

void MyData::parse(QString path) {

  path = path.remove("file://");

  if (path == "/tmp/search.json") {

    QString rawData;
    QVariantMap modelData;
    QVariantList finalJson;

    QFile file;
    QDir dir(".");

    if(fileExists(path)) {
        {
          file.setFileName(path);
          file.open(QIODevice::ReadOnly | QIODevice::Text);

          //Load data from json file!
          rawData = file.readAll();

          file.close();

          // Create json document.
          // Parses json as a UTF-8 encoded JSON document, and creates a QJsonDocument from it.

          QJsonDocument document   =   { QJsonDocument::fromJson(rawData.toUtf8()) };

          //Create data as Json object
          QJsonObject jsonObject = document.object();

          // Set next page token
          setNextPageToken(jsonObject["nextPageToken"].toString());

          // Sets number of items in the list as integer.
          setLength(jsonObject["items"].toArray().count());

          foreach (const QJsonValue &value, jsonObject["items"].toArray()) {

              // Sets value from model as Json object
              QJsonObject modelObject = value.toObject();

              // ID
              QJsonValue idValue = modelObject.value(QString("id"));
              QJsonObject idObject = idValue.toObject();

              // Snippet
              QJsonValue snippetValue = modelObject.value(QString("snippet"));
              QJsonObject snippetObject = snippetValue.toObject();

              // Thumbnails
              QJsonValue thumbnailsValue = snippetObject.value(QString("thumbnails"));
              QJsonObject thumbnailsObject = thumbnailsValue.toObject();

              // Default thumbnail
              QJsonValue defaulThumbnailValue = thumbnailsObject.value(QString("default"));
              QJsonObject defaulThumbnailObject = defaulThumbnailValue.toObject();

              // Channel title
              QJsonValue channelTitleValue = modelObject.value(QString("channelTitle"));
              QJsonObject channelTitleObject = channelTitleValue.toObject();

              modelData.insert("videoId", idObject["videoId"].toString());
              modelData.insert("title", snippetObject["title"].toString());
              modelData.insert("description", snippetObject["description"].toString());
              modelData.insert("thumbnailUrl", defaulThumbnailObject["url"].toString());
              modelData.insert("channelTitle", snippetObject["channelTitle"].toString());
              modelData.insert("channelId", snippetObject["channelId"].toString());

              // Set model data
              finalJson.append(modelData);
            }

          // Sets data
          setData(finalJson);

          // Sets result by status object of model.
          setResult("true");
        }

      } else {
        qWarning() << "There is no any file in this path!";
      }
  }
  else if (path == "/tmp/playlist.json")
  {
    QString rawData;
    QVariantMap modelData;
    QVariantList finalJson;

    QFile file;
    QDir dir(".");

    if(fileExists(path)) {
        {
          file.setFileName(path);
          file.open(QIODevice::ReadOnly | QIODevice::Text);

          //Load data from json file!
          rawData = file.readAll();

          file.close();

          // Create json document.
          // Parses json as a UTF-8 encoded JSON document, and creates a QJsonDocument from it.

          QJsonDocument document   =   { QJsonDocument::fromJson(rawData.toUtf8()) };

          //Create data as Json object
          QJsonObject jsonObject = document.object();

          // Set next page token
          setNextPageToken(jsonObject["nextPageToken"].toString());

          // Sets number of items in the list as integer.
          setLength(jsonObject["items"].toArray().count());

          foreach (const QJsonValue &value, jsonObject["items"].toArray()) {

              // Sets value from model as Json object
              QJsonObject modelObject = value.toObject();

              // Snippet
              QJsonValue snippetValue = modelObject.value(QString("snippet"));
              QJsonObject snippetObject = snippetValue.toObject();

              // Resource ID
              QJsonValue resourceIdValue = snippetObject.value(QString("resourceId"));
              QJsonObject resourceIdObject = resourceIdValue.toObject();

              // Thumbnails
              QJsonValue thumbnailsValue = snippetObject.value(QString("thumbnails"));
              QJsonObject thumbnailsObject = thumbnailsValue.toObject();

              // Default thumbnail
              QJsonValue defaulThumbnailValue = thumbnailsObject.value(QString("default"));
              QJsonObject defaulThumbnailObject = defaulThumbnailValue.toObject();

              // Channel title
              QJsonValue channelTitleValue = modelObject.value(QString("channelTitle"));
              QJsonObject channelTitleObject = channelTitleValue.toObject();

              modelData.insert("videoId", resourceIdObject["videoId"].toString());
              modelData.insert("title", snippetObject["title"].toString());
              modelData.insert("description", snippetObject["description"].toString());
              modelData.insert("thumbnailUrl", defaulThumbnailObject["url"].toString());
              modelData.insert("channelTitle", snippetObject["channelTitle"].toString());
              modelData.insert("channelId", snippetObject["channelId"].toString());
              modelData.insert("videoOwnerChannelTitle", snippetObject["videoOwnerChannelTitle"].toString());
              modelData.insert("videoOwnerChannelId", snippetObject["videoOwnerChannelId"].toString());
              modelData.insert("publishedAt", snippetObject["publishedAt"].toString());

              // Set model data
              finalJson.append(modelData);
            }

          // Sets data
          setData(finalJson);

          // Sets result by status object of model.
          setResult("true");
        }

      } else {
        qWarning() << "There is no any file in this path!";
      }
  }
  else if (path == "/tmp/channelinfo.json")
  {
    QString rawData;
    QVariantMap modelData;
    QVariantList finalJson;

    QFile file;
    QDir dir(".");

    if(fileExists(path)) {
        {
          file.setFileName(path);
          file.open(QIODevice::ReadOnly | QIODevice::Text);

          //Load data from json file!
          rawData = file.readAll();

          file.close();

          // Create json document.
          // Parses json as a UTF-8 encoded JSON document, and creates a QJsonDocument from it.

          QJsonDocument document   =   { QJsonDocument::fromJson(rawData.toUtf8()) };

          //Create data as Json object
          QJsonObject jsonObject = document.object();

          // Set next page token
          setNextPageToken(jsonObject["nextPageToken"].toString());

          // Sets number of items in the list as integer.
          setLength(jsonObject["items"].toArray().count());

          foreach (const QJsonValue &value, jsonObject["items"].toArray()) {

              // Sets value from model as Json object
              QJsonObject modelObject = value.toObject();

              // Content details
              QJsonValue contentDetailsValue = modelObject.value(QString("contentDetails"));
              QJsonObject contentDetailsObject = contentDetailsValue.toObject();

              // Related playlists
              QJsonValue relatedPlaylistsValue = contentDetailsObject.value(QString("relatedPlaylists"));
              QJsonObject relatedPlaylistsObject = relatedPlaylistsValue.toObject();

              modelData.insert("uploads", relatedPlaylistsObject["uploads"].toString());

              // Set model data
              finalJson.append(modelData);
            }

          // Sets data
          setData(finalJson);

          // Sets result by status object of model.
          //setResult(jsonObject["result"].toBool());
          setResult("true");
        }

      } else {
        qWarning() << "There is no any file in this path!";
      }
  }
  else if (path == "/tmp/channeluploads.json")
  {
    QString rawData;
    QVariantMap modelData;
    QVariantList finalJson;

    QFile file;
    QDir dir(".");

    if(fileExists(path)) {
        {
          file.setFileName(path);
          file.open(QIODevice::ReadOnly | QIODevice::Text);

          //Load data from json file!
          rawData = file.readAll();

          file.close();

          // Create json document.
          // Parses json as a UTF-8 encoded JSON document, and creates a QJsonDocument from it.

          QJsonDocument document   =   { QJsonDocument::fromJson(rawData.toUtf8()) };

          //Create data as Json object
          QJsonObject jsonObject = document.object();

          // Set next page token
          setNextPageToken(jsonObject["nextPageToken"].toString());

          // Sets number of items in the list as integer.
          setLength(jsonObject["items"].toArray().count());

          foreach (const QJsonValue &value, jsonObject["items"].toArray()) {

              // Sets value from model as Json object
              QJsonObject modelObject = value.toObject();

              // Snippet
              QJsonValue snippetValue = modelObject.value(QString("snippet"));
              QJsonObject snippetObject = snippetValue.toObject();

              // Resource ID
              QJsonValue resourceIdValue = snippetObject.value(QString("resourceId"));
              QJsonObject resourceIdObject = resourceIdValue.toObject();

              // Thumbnails
              QJsonValue thumbnailsValue = snippetObject.value(QString("thumbnails"));
              QJsonObject thumbnailsObject = thumbnailsValue.toObject();

              // Default thumbnail
              QJsonValue defaulThumbnailValue = thumbnailsObject.value(QString("default"));
              QJsonObject defaulThumbnailObject = defaulThumbnailValue.toObject();

              // Channel title
              QJsonValue channelTitleValue = modelObject.value(QString("channelTitle"));
              QJsonObject channelTitleObject = channelTitleValue.toObject();

              modelData.insert("videoId", resourceIdObject["videoId"].toString());
              modelData.insert("title", snippetObject["title"].toString());
              modelData.insert("description", snippetObject["description"].toString());
              modelData.insert("thumbnailUrl", defaulThumbnailObject["url"].toString());
              modelData.insert("channelTitle", snippetObject["channelTitle"].toString());
              modelData.insert("channelId", snippetObject["channelId"].toString());

              // Set model data
              finalJson.append(modelData);
            }

          // Sets data
          setData(finalJson);

          // Sets result by status object of model.
          setResult("true");
        }

      } else {
        qWarning() << "There is no any file in this path!";
      }
  }
}

void MyData::deleteData(QString file)
{
  QDir().remove(file);
}
