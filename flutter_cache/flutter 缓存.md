# flutter 缓存

## 基本数据类型存储

使用第三方 plugin [shared_preferences](https://pub.dartlang.org/packages/shared_preferences)

* 封装了 iOS 的 UserDefault 和 Android 的 SharedPreferences 来进行基本的数据类型存储，支持的数据类型为一下几种

| bool  |
| --- |
| int |
| double  |
| String  |
| List  |
| Map  |

## 文件存储

使用的第三方 plugin [path_provider](https://pub.dartlang.org/packages/path_provider)

* 封装了 iOS 和 Android 的目录访问, 然后返回了 Dart 对路径的 Directory 对象, 来进行文件操作。 

## 数据库存储

使用第三方 plugin  [sqflite](https://pub.dartlang.org/packages/sqflite) 

* 外层使用 Dart 封装了 Sqlite 的接口, 然后调用 iOS 平台的 FMDB 进行实现 iOS 下的数据库存储, 调用 android.database 的 sqlite 进行 Android 下的数据库实现



