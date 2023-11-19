#ifndef MYDATA_H
#define MYDATA_H

#include <QObject>
#include <QVariantList>
#include <QDir>

class MyData : public QObject
{
  Q_OBJECT
  Q_PROPERTY(QVariantList  data    READ data     WRITE setData     NOTIFY dataChanged)
  Q_PROPERTY(bool          result  READ result   WRITE setResult   NOTIFY resultChanged)
  Q_PROPERTY(int           length  READ length   WRITE setLength   NOTIFY lengthChanged)
  Q_PROPERTY(QString       nextPageToken  READ nextPageToken   WRITE setNextPageToken  NOTIFY nextPageTokenChanged)

public:
  Q_INVOKABLE void deleteData(QString file);

public:
  MyData();

  /*!
    * \brief data function returns a list of items.
    * \return type as QVarianList.
    */
  QVariantList data () const;

  /*!
    * \brief result function returns final result by status value!
    * \return type as boolian.
    */
  bool result       () const;

  /*!
    * \brief : length function returns total item count!
    * \return type as int
    */
  int  length       () const;

  /*!
    * \brief : nextPageToken function returns next page to search for
    * \return type as QString
    */
  QString  nextPageToken       () const;

  /*!
    * \brief : fileExists function checks file path!
    * \param : path is string of current file path.
    * \return type as boolian.
    */
  bool fileExists(QString path);

  /*!
    * \brief : parse function gets json file from user to convert.
    * \param : path is string of current file path.
    */
  Q_INVOKABLE void parse(QString path);

  //SLOTS
public slots:
  void setData(const QVariantList& data);
  void setResult(bool result);
  void setLength(int length);
  void setNextPageToken(QString nextPageToken);

  //SIGNALS
signals:
  void dataChanged(const QVariantList& data);
  void resultChanged(bool result);
  void lengthChanged(int length);
  void nextPageTokenChanged(QString nextPageToken);

private:
  QVariantList  m_data;
  bool          m_result = {false};
  int           m_length = {0};
  QString       m_nextPageToken;
};

#endif // MYDATA_HPP
