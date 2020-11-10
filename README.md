# IAmDemo
This project is a simple Group Chat iOS application. 

It is created with UIKit, Socket.IO, SnapKit, Alamofire, RxSwift,... And, SwiftLint to keep nice formatting of source code.

IAmDemo requires iOS 14.0 or later. If you are developer, you can set its `deployment target` to lower iOS version if needed. 

## Table of contents
* [General info](#general-info)
* [Technologies](#technologies)
* [How to run](#how-to-run)

## General info
This project is simple Group Chat app iOS app. User can access website: https://strange-chat.herokuapp.com/ to chat with others on this app. As a developer, you can test IAmDemo integration with another platform, such as: `web`. This web https://strange-chat.herokuapp.com/ is also created by me with using Nodejs and is deployed on Heroku.
	
## Technologies
Project is created with:
  - Alamofire (5.2.2)
  - RealmSwift (10.1.2) (this is for message-caching demo)
  - RxSwift (5.1.1)
  - SDWebImage (5.9.2)
  - SnapKit (5.0.1)
  - Socket.IO-Client-Swift (15.2.0)
  - SwiftLint (0.40.3)
	
## How to run
It requires `XCode 12.0 or later` to run directly from source code. XCode 12 requires `MacOS 10.15.4+`
If your XCode 12.0 is not available, you can change `deployment target` to lower iOS version.
You also need to install `cocoapod` to install library for this project. More detail information about `cocoapod` is here: https://cocoapods.org/

Steps:
  - Open `Terminal` on your MacOS machine, to use below these commands:
```
$ cd [path of directory that contains IamDemo.xcodeproj and podfile]
$ pod install (wait a bit to let cocoapod download/install library and generate pod project for IAmDemo)
```
  - Open `IamDemo.xcworkspace` by XCode, click Run/CMD+R to build and run this project by XCode.
  - Open browser then access this link: https://strange-chat.herokuapp.com/
  - Go back to your app (which are running on iOS Simulator), enter your year of birth (require 1940-2004), click `Tap to join`.
  - If your year of birth is valid, you will be navigated to Chat screen. You can freely chat with user on web or another iOS client from now.
