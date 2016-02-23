#Colorgy 課表 App
## 這是一個 Colorgy 的課表
![image](./ColorgyCourse/Images.xcassets/AppIcon.appiconset/icon60_3x.png)

一個課表，待補東西

## 使用說明 
### Setup 
專案使用`CocoaPods`版本`0.39`

安裝方式

```
sudo gem install cocoapods
```

打開專案後請移除`SecertKeys.swift`

並且註解掉`AppDelegate.swift`中之

```swift
Flurry.startSession(SecretKey.FlurryProductionKey)
Flurry.startSession(SecretKey.FlurryDevelopmentKey)
```

然後按下`cmd+R`就可以執行了。

## 使用套件
1. [AFNetworking](https://github.com/AFNetworking/AFNetworking)
2. FBSDKCoreKit
3. FBSDKLoginKit 
3. [SDWebImage](https://github.com/rs/SDWebImage)
4. [Answers](http://try.crashlytics.com/answers/)
5. [Fabric](https://get.fabric.io/)
6. [Crashlytics](https://try.crashlytics.com/)
7. [Flurry](http://www.flurry.com/)
8. [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)
9. [ImagePickerSheetController](https://github.com/larcus94/ImagePickerSheetController)
10. [DLMessageViewController](https://github.com/yoxisem544/DLChatView)(自己講)
11. [SKPhotoBrowser](https://github.com/suzuki-0000/SKPhotoBrowser)

## Chatroom usage
### 怎麼串
為了保留上面的`navigationcontroller`，這邊還是要用push segue的方式進來。

```swift
self.performSegueWithIdentifier("to chat room", sender: nil)
```

然後在`prepareForSegue`這邊設定他所須要的值

```swift
let vc = segue.destinationViewController as! TestChatRoomViewController
vc.userId = self.userId
vc.uuid = self.uuid
vc.chatroomId = self.chatroomId
vc.accessToken = self.accesstoken
vc.historyChatroom = HistoryChatroom()
```

開啟聊天必須要附上這五個值。

這邊有改動的是原本`vc.friendId`改成`vc.chatroomId`，

然後另外需要傳入一個`HistoryChatroom`，聊天時會需要用到期中的一些值。

### Delegate 解說
聊天室的delegate是`DLMessagesViewControllerDelegate`

他具有以下幾的委派

1. DLMessagesViewControllerDidClickedMessageButton(withReturnMessage message:)
2. DLMessagesViewControllerDidClickedCameraButton()

`DLMessagesViewControllerDidClickedMessageButton(withReturnMessage message:)`會回傳一個已經切過前後空白以及換行的字串回來，這字串是要傳送給server的。

傳送方式以`colorgySocket.sendTextMessage(_, withUserId:)`傳送，就會emit一個傳送的事件給socket。

接下來`DLMessagesViewControllerDidClickedCameraButton()`
是打開照片的委派，接到這個委派，要在controller中執行`openImagePicker()`打開照片的動作

點擊照片的委派是`DLIncomingMessageDelegate`，他目前只有一個動作就是`DLIncomingMessageDidTapOnUserImageView(image: UIImage?)`

他會回傳被點擊到的頭貼的`UIImage?`，不保證有值，請注意



## how to use it


## Utilities
功能性

## Controller

## Model

## View