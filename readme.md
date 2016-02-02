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
###### 怎麼串
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

## how to use it


## Utilities
功能性

## Controller

## Model

## View