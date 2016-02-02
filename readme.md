#Colorgy 課表 App
## 這是一個 Colorgy 的課表
一個課表，待補東西

## 使用說明 
### Setup 
專案使用`CocoaPods`版本`0.36`

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
vc.friendId = self.friendId
vc.accessToken = self.accesstoken
```

開啟聊天必須要附上這四個值。

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