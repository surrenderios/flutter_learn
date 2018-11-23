#package & plugin

##（一）使用package

###pubspec介绍
pubspec 是一个 Dart 的包管理工具,类似于 iOS 下的 Cocoapods 或者安卓下的 Grade. 用户发布的公告包都可以被其他人使用.


###查找package

Flutter提供了官方的 package 搜索,[链接](https://pub.dartlang.org), 页面列出了使用频率较高的一些package和介绍, 可以在此处获取。

###集成package
以添加 css_colors 为例：
1. 打开 pubspec.yaml, 添加依赖 css_colors, 添加过后, 文件如下所示:

		dependencies:
	  	flutter:
	    sdk: flutter
	  	css_colors: ^1.0.0
2. 执行安装命令:

	方式一: 终端执行命令 flutter package get
	
	方式二: Android Studio/InteliJ 点击package Get
	
	方式三: VC Code 点击Get package
	
3. 使用时候导入：
	
		import 'package:css_colors/css_colors.dart';
	
###管理package

####使用版本控制
使用版本控制可以控制代码是基于某一个版本的 package 运行的, 不会在更新的时候造成代码的改动

####更新版本代码
当需要使用新版本的package代码时候,更改 package 对应的版本号为当前最新的版本号,然后执行上述的 **集成package**的步骤2

####依赖私有package
1. 依赖本地路径中的包

	`
	dependencies:
	  plugin1:
	    path: ../plugin1/
	`

2. 依赖 Git

	`
	dependencies:
  plugin1:
    git:
      url: git://github.com/flutter/plugin1.git
	`
3. 依赖 Git 中的某个子模块

	`
	dependencies:
	  package1:
	    git:
	      url: git://github.com/flutter/package.git
	      path: package/package1
	`

##（二）开发package

###package简介
一个package包至少包含一个pubspec.yaml,该文件包含了包名,版本号,作者等,还包含一个lib文件夹,lib文件夹中至少包含一个 <包名>.dart 的文件。

###package类型
**Dart package**: 全部使用Dart语言编写的包

**Plugin package**: 使用Dart封装的跨平台的各自实现代码

###开发package
1. 使用命令行创建 package 模版,例如创建一个名为 hello 的package

		flutter create --template=package hello
		
该命令会创建一个为 hello 的文件夹, 并且包含 lib/hello.dart 和 test/hello_test.dart

2. 实现 package 的功能, 并使用 hello_test.dart 来进行代码测试
	
	
###开发plugin
1. 使用命令行创建 plugin 模版,例如创建一个名为 hello 的plugin

		flutter create --org com.example --template=plugin hello
		
该命令会创建一个为 hello 的文件夹, 并且包含 lib/hello.dart 和 一个 android 和一个 iOS 文件夹, 其中分别对应了各自平台不同的实现,即 HelloPlugin.java 和 HelloPlugin.m 

当然也可以指定使用想要的语言来实现, 例如:

		flutter create --template=plugin -i swift -a kotlin hello


2. 打开 hello.dart, 定义 Dart 调用的接口
3. 分别使用 VS 打开 HelloPlugin.java 和 Xcode 打开 HelloPlugin.m, 实现 Dart 接口定义的功能 


###添加文档
1. README.md
2. CHANGELOG.md
3. LICENSE
4. API 接口文档
	如何在发布时使用自动文档生成功能到本地 ？详细参见[链接](https://www.dartlang.org/guides/language/effective-dart/documentation)
	1. 进入 package 开发文件夹
	
			cd ~/dev/mypackage
			
	2. 告诉文档命令工具 flutter SDK的路径
	
			export FLUTTER_ROOT=~/dev/flutter (on macOS or Linux)

			set FLUTTER_ROOT=~/dev/flutter (on Windows)
			
	3. 运行 dartdoc 
		
			$FLUTTER_ROOT/bin/cache/dart-sdk/bin/dartdoc (on macOS or Linux)

			%FLUTTER_ROOT%\bin\cache\dart-sdk\bin\dartdoc (on Windows)
			
###发布package
1. 确保所有的配置正确, pubspec.yaml, README.md, and CHANGELOG.md,然后使用检查命令 dry-run
		
		flutter package pub publish --dry-run
		
2. 确保步骤1没有问题后,即可发布

		flutter package pub publish
		
		
###package依赖处理
1. 如果创建的是package, package依赖了其它的package,那么解决的方法同上面的 **集成package**
2. 如果创建的是Plugin, 就分别处理iOS和安卓的依赖

	**iOS处理**: 在hello/ios/hello.podspec中添加依赖
	
		Pod::Spec.new do |s|
		# lines skipped
		s.dependency 'url_launcher'
	**Android处理**: 在hello/android/buid/gradle中添加依赖
	
		android {
	    // lines skipped
	    dependencies {
	        provided rootProject.findProject(":url_launcher")
	    		}
		}
		
###依赖冲突问题解决
如果有不同的package依赖了相同的package,但是版本有不相同,怎么办勒 ？ flutter采用大于某个版本来进行兼容,例如:
	
	dependencies:
  		url_launcher: ^0.4.2   # Good, any 0.4.x with x >= 2 will do.
  		image_picker: '0.1.1'   # Not so good, only 0.1.1 will do. 

##（三）package开发实战
一下开发以 Android Studio 为例:

###创建package
1. 选择File->New->New Flutter Project->Flutter package

![](https://github.com/surrenderios/flutter_learn/blob/master/flutter_package/15429383262955.jpg)

窗口中有 3 种选择, 参考 **package类型** 中所讲述的, 我们这里采用纯 Dart 代码来编写, 所以选择创建 package

2. 在步骤 1 中 创建的工程中添加我们的 package 代码, 实现了一个封装的 SimpleToast. 代码实现以后, 参照**发布package**步骤进行检查,但是暂不发布

3. 新建一个测试 Demo (关于逻辑测试 可以直接在步骤 2 中的 test 中进行). 在 pubspec.yaml 中添加依赖 flutter_toast , 添加的方式使用为使用绝对路径(因为我们没有发布, 添加方式参见**依赖私有package**的步骤 1 )

4. 在测试 Demo 中使用 SimpleToast, 查看具体效果参见 flutter_toast_demo




