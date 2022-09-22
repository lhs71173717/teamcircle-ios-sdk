//
//  TCTeamCircleManager.swift
//  TeamCircleSDK
//
//  Created by JasonTang on 2021/1/21.
//  Copyright © 2021 Thirtydays. All rights reserved.
//

import UIKit
import Alamofire
import HyphenateChat
import GiphyUISDK
import GiphyCoreSDK
import PKHUD

@objc public protocol TCManagerDelegate : AnyObject {
    /// SDK发生错误
    func teamCirleFail(error:NSError)
    /// SDK初始化成功
    func teamCirleSDKInit()
    /// 用户登录成功
    func teamCirleAccountLogin()
    /// 用户退出成功
    func teamCirleAccountLogout()
    /// 用户点击注销
    func teamCirleDeleteAccount()
    /// 用户信息修改
    func teamCirleAccountProfileChange(accountName: String, avatarUrl: String, bio: String)
    /// share json内容
    func shareJsonDownloaded(json: String)
    /// 未读通知数修改
    func notificationStateChanged(count: Int)
    /// 未读IM数修改
    func messageChanged(count: Int)
}

//分享页需实现方法
@objc public protocol TCShareControllerDelegate : AnyObject {
    /// 清除页面数据
    func teamCirleShareClear()
}

@objc public enum TCThemeType : NSInteger {
    case light = 0
    case dark = 1
}

@objc public class TCManager: NSObject, TCRequestable {
    
    @objc public static let sharedInstance = TCManager()
    
    /// 是否打印Log
    @objc public var printLog = true
    @objc public var isLogin : Bool = false
    
    weak var delegate : TCManagerDelegate?
    private(set) var initSuccess = false
    private var appId = ""
    private var appKey = ""
    private var toInitSDK = false
    private let reachabilityManager = NetworkReachabilityManager()
    
    private var timer : Timer?
    //是否为高版本
    private(set) var tallVersion = true
    
    /// SDK版本号：1.0.0
    @objc public let version = "1.0.0"
    
    private(set) var shareVCtrl : UIViewController?
    private(set) weak var shareDelegate : TCShareControllerDelegate?
    
    private var taskId: UIBackgroundTaskIdentifier?
    private var backTimer: Timer?
    
    var imStatus = false
    
    public override init() {
        super.init()
        listenForReachability()
    }
    
    deinit {
        removeForReachability()
        removeNotification()
        removeTimer()
    }
    
    func listenForReachability() {
        self.reachabilityManager?.listener = { [weak self] status in
            switch status {
            case .reachable(_):
                if self!.toInitSDK {
                    self!.toInitSDK = false
                    self!.initSDK(appId: self!.appId, appKey: self!.appKey, delegate: self?.delegate as Any)
                }
            case .unknown:
                break
            case .notReachable:
                break
            }
        }
        self.reachabilityManager?.startListening()
    }
    
    func removeForReachability() {
        self.reachabilityManager?.stopListening()
    }
    
    func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(appResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    func removeNotification() {
        NotificationCenter.default.removeObserver(self)
        EMClient.shared().removeDelegate(TCManager.sharedInstance)
        EMClient.shared().chatManager?.remove(TCManager.sharedInstance)
    }
    
    func addTimer() {
        removeTimer()
        timer = Timer.scheduledTimer(timeInterval: 90, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        let loop = RunLoop.current
        loop.add(timer!, forMode: .common)
    }
    
    func removeTimer() {
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
    }
    
    @objc func timerAction() {
        if initSuccess {
            TCDataPointsModel.uploadPoints()
        }
    }
    
    @objc func appResignActive() {
        addDelayBackgroundTime()
        TCDataPointsModel.addPiontForApplicationNotification(notification: .WillResignActive)
        EMClient.shared().applicationDidEnterBackground(UIApplication.shared)
    }
    
    @objc func appBecomeActive() {
        removeDelayTime()
        TCDataPointsModel.addPiontForApplicationNotification(notification: .DidBecomeActive)
        self.requestUnreadIMMessageCount()
        EMClient.shared().applicationWillEnterForeground(UIApplication.shared)
    }
    
    private func addDelayBackgroundTime() {
        if self.taskId != nil {
            return
        }
        let application = UIApplication.shared
        taskId = application.beginBackgroundTask(expirationHandler: {
            [weak self] in
            self?.removeDelayTime()
        })
        
        backTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(longTimeTask(timer:)), userInfo: nil, repeats: true)
    }
    
    private func removeDelayTime() {
        if let time = backTimer {
            time.invalidate()
            backTimer = nil
        }
        if let taskId = self.taskId {
            UIApplication.shared.endBackgroundTask(taskId)
            self.taskId = nil
        }
    }
    
    @objc private func longTimeTask(timer: Timer) {
//        let times = UIApplication.shared.backgroundTimeRemaining
//        tcDebugPrint("background Time:\(times)")
    }
    
    /// 初始化SDK
    /// - Parameters:
    ///   - appId: appId
    ///   - appKey: appKey
    ///   - delegate: delegate
    ///   - theme: theme
    @objc public func initSDK(appId : String, appKey : String, delegate : Any, theme : TCThemeType = .dark) {
        self.delegate = delegate as? TCManagerDelegate
        guard let token = UIDevice.current.identifierForVendor?.uuidString else {
            self.delegate?.teamCirleFail(error: TCError.failedGetUUID.error)
            tcDebugPrint(TCError.failedGetUUID.error)
            return
        }
        
        TCCacheManager.sharedInstance.removeObjectForKey(TCCacheManager.sharedInstance.categoryKey)
        let data = Date()
        TCUIConfig.defaultConfig.theme = theme
        UITextField.appearance().keyboardAppearance = theme == .dark ? .dark : .light
        UITextField.appearance().tintColor = TCUIConfig.defaultConfig.systemActionColor
        UITextView.appearance().tintColor = TCUIConfig.defaultConfig.systemActionColor
        if reachabilityManager!.isReachable {
            request(.customerLogin(appId: appId, appKey: appKey, deviceToken: token, lastSdkVersion: version)).responseJSON { [weak self] (response) in
                let nowData = Date()
                let time = Int(fabs(nowData.timeIntervalSince(data)))
                if time >= 2 {
                    self?.addNotification()
                } else {
                    delay(time: TimeInterval(2-time)) {
                        self?.addNotification()
                    }
                }
                self?.addTimer()
                if let error = response.error {
                    tcDebugPrint("failed: \(error.localizedDescription)")
                    return
                }
                guard let result = response.value as? [String : Any], let resultData = result["resultData"] as? [String : Any], let partId = resultData["accessToken"] as? String, let resultStatus = result["resultStatus"] as? Bool, resultStatus == true else {
                    tcDebugPrint("failed: Interface data error")
                    return
                }
                
                // Giphy apiKey
                Giphy.configure(apiKey: TCAppEnvironment.current.apiService.serverConfig.giphyApiKey)
                tcDebugPrint("SDK init success")
                if let fileURL = FileManager.userFileURL, let user = TCUser.get(fromCache: fileURL) {
                    TCAppEnvironment.updateCurrentUser(user)
                }
                if let sharePostUrl = resultData["sharePostUrl"] as? String {
                    TCUIConfig.defaultConfig.sharePostUrl = sharePostUrl
                }
                if let planType = resultData["planType"] as? String {
                    if planType == "START" {
                        self?.tallVersion = false
                    }
                }
                if let imStatus = resultData["imStatus"] as? Bool {
                    self?.imStatus = imStatus
                    if imStatus {
                        self?.initHyphenateChat()
                    }
                }
                TCAppEnvironment.accessToken = partId
                self?.initSuccess = true
                UserInfoStore.sharedInstance().loadInfosFromLocal()
                TCDataPointModel.uploadPoints()
                TCDataPointsModel.uploadPoints()
                self?.delegate?.teamCirleSDKInit()
            }
        } else {
            self.appId = appId
            self.appKey = appKey
            toInitSDK = true
            tcDebugPrint("No network")
        }
        
    }
    
    /// 用户登录
    @objc public func userLogin(userId : String, userName : String, avatarUrl : String = "", userEmail : String = "", userBio : String = "") {
        guard initSuccess else {
            tcDebugPrint(TCError.uninitialized.error)
            TCManager.sharedInstance.delegate?.teamCirleFail(error: TCError.uninitialized.error)
            return
        }
        request(.accountLogin(thirdPartyId: userId, accountName: userName, avatarUrl: avatarUrl, accountEmail: userEmail, bio: userBio)).responseDecodableObject(completionHandler: { [weak self] (response: DataResponse<TCUserLogin>) in
            if let error = response.error {
                tcDebugPrint("failed: \(error.localizedDescription)")
                return
            }
            if let info = response.result.value, let accountId = info.accountId {
                let user = TCUser(thirdPartyId: userId,accountId: accountId, username: userName, avatar: avatarUrl, email: userEmail, bio: userBio, followerNum: 0, followingNum: 0, favoriteNumber: 0, emUserName: info.emUserName, emUserToken: info.emUserToken, mergeStatus: info.mergeStatus)
                
                TCAppEnvironment.updateCurrentUser(user)
                if let imState = self?.imStatus, imState {
                    self?.loginEasemob(complete: { (_) in
                        
                    })
                }
                self?.isLogin = true
                
                tcDebugPrint("Account Login")
                NotificationCenter.default.post(name: NSNotification.Name.TCUser.Login, object: user)
//                self?.getAccountStatistics()
                self?.requestUnreadMessageCount()
                self?.delegate?.teamCirleAccountLogin()
            } else {
                tcDebugPrint("failed: Interface data error")
            }
        })
    }
    
    /// 用户退出
    @objc public func userLogout() {
        guard initSuccess else {
            tcDebugPrint(TCError.uninitialized.error)
            TCManager.sharedInstance.delegate?.teamCirleFail(error: TCError.uninitialized.error)
            return
        }
        if TCAppEnvironment.current.currentUser == nil {
            tcDebugPrint(TCError.userNotLogged.error)
            TCManager.sharedInstance.delegate?.teamCirleFail(error: TCError.userNotLogged.error)
            return
        }
        request(.accountLogout).responseJSON { [weak self] (response) in
            if let error = response.error {
                tcDebugPrint("failed: \(error.localizedDescription)")
                return
            }
            guard let result = response.value as? [String : Any], let resultStatus = result["resultStatus"] as? Bool, resultStatus == true else {
                tcDebugPrint("failed: Interface data error")
                return
            }
            TCAppEnvironment.logout()
            tcDebugPrint("Account Logout")
            NotificationCenter.default.post(name: NSNotification.Name.TCUser.Login, object: nil)
            self?.delegate?.teamCirleAccountLogout()
        }
    }
    ///注销用户
    @objc public func deleleAccount(complete : @escaping ((Error?) -> Void)) {
        guard initSuccess else {
            tcDebugPrint(TCError.uninitialized.error)
            complete(TCError.uninitialized.error)
            return
        }
        if TCAppEnvironment.current.currentUser == nil {
            tcDebugPrint(TCError.userNotLogged.error)
            complete(TCError.userNotLogged.error)
            return
        }
        request(.accountDelete).responseStatus { (ok, message, data) in
            if ok {
                TCAppEnvironment.logout()
                tcDebugPrint("Account Delele")
                NotificationCenter.default.post(name: NSNotification.Name.TCUser.Login, object: nil)
                complete(nil)
            } else {
                if let msg = message {
                    let error = NSError(domain: msg, code: 21000, userInfo: nil)
                    complete(error)
                } else {
                    let error = NSError(domain: "error", code: 21000, userInfo: nil)
                    complete(error)
                }
            }
        }
    }
    
    /// 创建一个圈子导航栏控制器
    /// - Parameters:
    ///   - complete: 回调
    @objc public func initCircle(complete : ((TCCircleNavController?, Error?) -> Void)) {
        if initSuccess {
            complete(TCCircleNavController.initCircleVCtrlNav(), nil)
        } else {
            tcDebugPrint(TCError.uninitialized.error)
            complete(nil, TCError.uninitialized.error)
        }
    }
    
    /// 创建一个商店按钮
    /// - Parameters:
    ///   - frame: frame
    ///   - complete: 回调
    @objc public func initStoreBtn(frame:CGRect, complete : ((TCStoreBtn?, Error?) -> Void)) {
        if initSuccess {
            if tallVersion {
                let btn = TCStoreBtn(frame: frame, image: UIImage(), title: "")
                complete(btn, nil)
                btn.setBtnImage()
            } else {
                tcDebugPrint(TCError.packageNotSupported.error)
                complete(nil, TCError.packageNotSupported.error)
            }
        } else {
            tcDebugPrint(TCError.uninitialized.error)
            complete(nil, TCError.uninitialized.error)
        }
    }
    
    /// 跳转商店列表
    @objc public func toStoreVCtrl(nav:UINavigationController, complete : ((TCStoreVCtrl?, Error?) -> Void)) {
        if initSuccess {
            if tallVersion {
                let store = TCStoreVCtrl.initWithCircleStoryboard()
                complete(store, nil)
                nav.pushViewController(store, animated: true)
            } else {
                tcDebugPrint(TCError.packageNotSupported.error)
                complete(nil, TCError.packageNotSupported.error)
            }
        } else {
            tcDebugPrint(TCError.uninitialized.error)
            complete(nil, TCError.uninitialized.error)
        }
    }
    
    /// 创建一个我的按钮
    @objc public func initUserCenterBtn(frame:CGRect, image : Any, title : String, complete : ((TCMeBtn?, Error?) -> Void)) {
        if initSuccess {
            complete(TCMeBtn(frame: frame, image: image, title: title), nil)
        } else {
            tcDebugPrint(TCError.uninitialized.error)
            complete(nil, TCError.uninitialized.error)
        }
    }
    
    /// 跳转我的页面
    @objc public func toUserCenterVCtrl(nav:UINavigationController, complete : ((TCProfileVCtrl?, Error?) -> Void)) {
        toProfileVCtrlAction(nav: nav, type: .normal, animated: true, complete: complete)
    }
    
    /// 注册更新头像跳我的页面,关闭为dissmiss页面
    @objc public func registeredToProfileVCtrl(nav:UINavigationController, complete : ((TCProfileVCtrl?, Error?) -> Void)) {
        toProfileVCtrlAction(nav: nav, type: .registered, animated: true, complete: complete)
    }
    
    private func toProfileVCtrlAction(nav:UINavigationController, type: TCProfileVCtrlType, animated: Bool, complete : ((TCProfileVCtrl?, Error?) -> Void)) {
        if initSuccess {
            if let user = TCAppEnvironment.current.currentUser {
                let vc = TCProfileVCtrl.initWithCircleStoryboard()
                vc.type = type
                vc.profile = TCProfileViewModel(user: user)
                complete(vc, nil)
                nav.pushViewController(vc, animated: animated)
            } else {
                let error = TCError.userNotLogged.error
                tcDebugPrint(error)
                complete(nil, error)
            }
        } else {
            tcDebugPrint(TCError.uninitialized.error)
            complete(nil, TCError.uninitialized.error)
        }
    }
    
    @objc public func requestUnreadMessageCount() {
        if initSuccess {
            TCMessage.shared.requestUnreadMessageCount()
        } else {
            tcDebugPrint(TCError.uninitialized.error)
            delegate?.teamCirleFail(error: TCError.uninitialized.error)
        }
    }
    
    @objc public func requestUnreadIMMessageCount() {
        if initSuccess {
            TCMessage.shared.requestUnreadIMMessageCount()
        } else {
            tcDebugPrint(TCError.uninitialized.error)
            delegate?.teamCirleFail(error: TCError.uninitialized.error)
        }
    }
    
    ///判断上传view
    @objc public func judgeLoadView() {
        if initSuccess {
            TCTransferUtility.shared.judgeLoadView()
        } else {
            tcDebugPrint(TCError.uninitialized.error)
            delegate?.teamCirleFail(error: TCError.uninitialized.error)
        }
    }
    
    /// 创建一个通知的按钮
    @objc public func initNotificBtn(frame:CGRect, image : Any, title : String, complete : ((TCNotificBtn?, Error?) -> Void)) {
        if initSuccess {
            complete(TCNotificBtn(frame: frame, image: image, title: title), nil)
        } else {
            complete(nil, TCError.uninitialized.error)
        }
    }
    
    /// 跳转通知列表
    @objc public func jumpToNotificationCenter(nav:UINavigationController, complete : ((TCNotificationVCtrl?, Error?) -> Void)) {
        if initSuccess {
            if TCAppEnvironment.current.currentUser != nil {
                if nav.viewControllers.last is TCNotificationVCtrl {
                    return
                }
                let vc = TCNotificationVCtrl.initWithCircleStoryboard()
                complete(vc, nil)
                nav.pushViewController(vc, animated: true)
            } else {
                let error = TCError.userNotLogged.error
                tcDebugPrint(error)
                complete(nil, error)
            }
        } else {
            tcDebugPrint(TCError.uninitialized.error)
            complete(nil, TCError.uninitialized.error)
        }
    }
    
    /// 创建一个帖子列表
    @objc public func initFeedController(nav:UINavigationController, complete : ((TCFeedsVCtrl?, Error?) -> Void)) {
        if initSuccess {
            let feed = TCFeedsVCtrl.initWithCircleStoryboard()
            feed.nav = nav
            complete(feed, nil)
        } else {
            tcDebugPrint(TCError.uninitialized.error)
            complete(nil, TCError.uninitialized.error)
        }
    }
    
    /// 创建一个分享帖子按钮
    @objc public func initNewPostBtn(frame:CGRect, image : Any, title : String, complete : ((TCPostShareBtn?, Error?) -> Void)) {
        if initSuccess {
            complete(TCPostShareBtn(frame: frame, image: image, title: title), nil)
        } else {
            tcDebugPrint(TCError.uninitialized.error)
            complete(nil, TCError.uninitialized.error)
        }
    }
    
    /// 跳转分享帖子页面
    @objc public func toNewPostVCtrl(complete : ((Error?) -> Void)) {
        if initSuccess {
            if TCAppEnvironment.current.currentUser != nil {
                if accountBanAllActivities() {
                    tc_getCurrentViewController()?.showHUD(.label(.tc_localized_BANALLACTIVITIESPrompt))
                    return
                }
                let imageNav = ZLImagePickerNavController.initWithZLImagePickerStoryboard()
                
                if let viewcontroller = tc_getCurrentViewController() {
                    viewcontroller.present(imageNav, animated: true, completion: nil)
                } else {
                    tcDebugPrint("No Controller")
                }
            } else {
                let error = TCError.userNotLogged.error
                tcDebugPrint(error)
                complete(error)
            }
        } else {
            tcDebugPrint(TCError.uninitialized.error)
            complete(TCError.uninitialized.error)
        }
    }
    
    /// 创建一个搜索按钮
    @objc public func initSearchBtn(frame:CGRect, image : Any, title : String, complete : ((TCSearchBtn?, Error?) -> Void)) {
        if initSuccess {
            complete(TCSearchBtn(frame: frame, image: image, title: title), nil)
        } else {
            tcDebugPrint(TCError.uninitialized.error)
            complete(nil, TCError.uninitialized.error)
        }
    }
    
    /// 跳转搜索页面
    @objc public func toSearchVCtrl(complete : ((Error?) -> Void)) {
        if initSuccess {
            if TCAppEnvironment.current.currentUser != nil {
                let search = TCSearchNavCtrl.initWithCircleStoryboard()
                
                if let ctrl = tc_getCurrentViewController() {
                    ctrl.present(search, animated: false, completion: nil)
                } else {
                    tcDebugPrint("No Controller")
                }
            } else {
                tcDebugPrint(TCError.userNotLogged.error)
                TCManager.sharedInstance.delegate?.teamCirleFail(error: TCError.userNotLogged.error)
            }
        } else {
            tcDebugPrint(TCError.uninitialized.error)
            complete(TCError.uninitialized.error)
        }
    }
    
    @objc public func initCustomerPostBar(frame: CGRect, nav:UINavigationController, productId: Int, complete : ((TCStorePostBarView?, Error?) -> Void)) {
        if initSuccess {
            if tallVersion {
                let storeBar = TCStorePostBarView.init(frame: frame, productId: productId, navigationController: nav)
                complete(storeBar, nil)
            } else {
                tcDebugPrint(TCError.packageNotSupported.error)
                complete(nil, TCError.packageNotSupported.error)
            }
        } else {
            tcDebugPrint(TCError.uninitialized.error)
            complete(nil, TCError.uninitialized.error)
        }
    }
    
    @objc public func accountBanAllActivities() -> Bool {
        if let mergeStatus = TCAppEnvironment.current.currentUser?.mergeStatus, mergeStatus == "BAN_ALL_ACTIVITIES" {
            return true
        }
        return false
    }
    
    ///设置分享 controller
    @objc public func setShareJsonController(_ controller: UIViewController, complete : ((Error?) -> Void)) {
        if initSuccess {
            shareDelegate = controller as? TCShareControllerDelegate
            shareVCtrl = controller
        } else {
            tcDebugPrint(TCError.uninitialized.error)
            complete(TCError.uninitialized.error)
        }
    }
    
    @objc public func setTextFontRegular(font:UIFont? = nil, color: UIColor? = nil) -> Bool {
        if initSuccess {
            if let font = font {
                TCUIConfig.defaultConfig.systemTextFront = font
            }
            if let color = color {
                TCUIConfig.defaultConfig.systemTextColor = color
            }
        } else {
            tcDebugPrint(TCError.uninitialized.error)
            delegate?.teamCirleFail(error: TCError.uninitialized.error)
            return false
        }
        return true
    }
    
    @objc public func setTextFontBold(font:UIFont? = nil, color:UIColor? = nil) -> Bool {
        if initSuccess {
            if let font = font {
                TCUIConfig.defaultConfig.systemUserFront = font
            }
            if let color = color {
                TCUIConfig.defaultConfig.systemUserColor = color
            }
        } else {
            tcDebugPrint(TCError.uninitialized.error)
            delegate?.teamCirleFail(error: TCError.uninitialized.error)
            return false
        }
        return true
    }
    
    @objc public func setTextFontAction(font:UIFont? = nil, color:UIColor? = nil) -> Bool {
        if initSuccess {
            if let font = font {
                TCUIConfig.defaultConfig.systemActionFront = font
            }
            if let color = color {
                TCUIConfig.defaultConfig.systemActionColor = color
            }
        } else {
            tcDebugPrint(TCError.uninitialized.error)
            delegate?.teamCirleFail(error: TCError.uninitialized.error)
            return false
        }
        return true
    }
    
    //商品详情页产品名称
    @objc public func setTextFontProductName(font:UIFont? = nil, color:UIColor? = nil) -> Bool {
        if initSuccess {
            if !tallVersion {
                tcDebugPrint(TCError.packageNotSupported.error)
                delegate?.teamCirleFail(error: TCError.packageNotSupported.error)
                return false
            }
            if let font = font {
                TCUIConfig.defaultConfig.productFront = font
            }
            if let color = color {
                TCUIConfig.defaultConfig.productColor = color
            }
        } else {
            tcDebugPrint(TCError.uninitialized.error)
            delegate?.teamCirleFail(error: TCError.uninitialized.error)
            return false
        }
        return true
    }
    //商品列表页产品价格
    @objc public func setTextFontProductPrice(font:UIFont? = nil, color:UIColor? = nil) -> Bool {
        if initSuccess {
            if !tallVersion {
                tcDebugPrint(TCError.packageNotSupported.error)
                delegate?.teamCirleFail(error: TCError.packageNotSupported.error)
                return false
            }
            if let font = font {
                TCUIConfig.defaultConfig.priceFront = font
            }
            if let color = color {
                TCUIConfig.defaultConfig.priceColor = color
            }
        } else {
            tcDebugPrint(TCError.uninitialized.error)
            delegate?.teamCirleFail(error: TCError.uninitialized.error)
            return false
        }
        return true
    }
    //商品列表页产品价格小数
    @objc public func setTextFontPricedecimalFront(font:UIFont? = nil, color:UIColor? = nil) -> Bool {
        if initSuccess {
            if !tallVersion {
                tcDebugPrint(TCError.packageNotSupported.error)
                delegate?.teamCirleFail(error: TCError.packageNotSupported.error)
                return false
            }
            if let font = font {
                TCUIConfig.defaultConfig.pricedecimalFront = font
            }
            if let color = color {
                TCUIConfig.defaultConfig.pricedecimalColor = color
            }
        } else {
            tcDebugPrint(TCError.uninitialized.error)
            delegate?.teamCirleFail(error: TCError.uninitialized.error)
            return false
        }
        return true
    }
    
    @objc public func setIconFavorite(icon:UIImage) -> Bool {
        if initSuccess {
            TCUIConfig.defaultConfig.feedFavoriteImage = icon
        } else {
            tcDebugPrint(TCError.uninitialized.error)
            delegate?.teamCirleFail(error: TCError.uninitialized.error)
            return false
        }
        return true
    }
    
    @objc public func setIconFavoriteSelected(icon:UIImage) -> Bool {
        if initSuccess {
            TCUIConfig.defaultConfig.feedFavoriteSelectedImage = icon
        } else {
            tcDebugPrint(TCError.uninitialized.error)
            delegate?.teamCirleFail(error: TCError.uninitialized.error)
            return false
        }
        return true
    }
    
    @objc public func setIconTag(icon:UIImage) -> Bool {
        if initSuccess {
            if !tallVersion {
                tcDebugPrint(TCError.packageNotSupported.error)
                delegate?.teamCirleFail(error: TCError.packageNotSupported.error)
                return false
            }
            TCUIConfig.defaultConfig.newPostTagImage = icon
        } else {
            tcDebugPrint(TCError.uninitialized.error)
            delegate?.teamCirleFail(error: TCError.uninitialized.error)
            return false
        }
        return true
    }
    
    @objc public func setIconTagSelected(icon:UIImage) -> Bool {
        if initSuccess {
            if !tallVersion {
                tcDebugPrint(TCError.packageNotSupported.error)
                delegate?.teamCirleFail(error: TCError.packageNotSupported.error)
                return false
            }
            TCUIConfig.defaultConfig.tagSelectedImage = icon
        } else {
            tcDebugPrint(TCError.uninitialized.error)
            delegate?.teamCirleFail(error: TCError.uninitialized.error)
            return false
        }
        return true
    }
    
    @objc public func setIconLike(icon:UIImage) -> Bool {
        if initSuccess {
            TCUIConfig.defaultConfig.feedLikeImage = icon
        } else {
            tcDebugPrint(TCError.uninitialized.error)
            delegate?.teamCirleFail(error: TCError.uninitialized.error)
            return false
        }
        return true
    }
    
    @objc public func setIconLikeSelected(icon:UIImage) -> Bool {
        if initSuccess {
            TCUIConfig.defaultConfig.feedLikeSelectedImage = icon
        } else {
            tcDebugPrint(TCError.uninitialized.error)
            delegate?.teamCirleFail(error: TCError.uninitialized.error)
            return false
        }
        return true
    }
    
    @objc public func setIconComment(icon:UIImage) -> Bool {
        if initSuccess {
            TCUIConfig.defaultConfig.feedCommentImage = icon
        } else {
            tcDebugPrint(TCError.uninitialized.error)
            delegate?.teamCirleFail(error: TCError.uninitialized.error)
            return false
        }
        return true
    }
    
    @objc public func setIconShare(icon:UIImage) -> Bool {
        if initSuccess {
            TCUIConfig.defaultConfig.feedShareImage = icon
        } else {
            tcDebugPrint(TCError.uninitialized.error)
            delegate?.teamCirleFail(error: TCError.uninitialized.error)
            return false
        }
        return true
    }
    
    @objc public func setIconBack(icon:UIImage) -> Bool {
        if initSuccess {
            TCUIConfig.defaultConfig.backImage = icon
        } else {
            tcDebugPrint(TCError.uninitialized.error)
            delegate?.teamCirleFail(error: TCError.uninitialized.error)
            return false
        }
        return true
    }
    
    @objc public func setShareJsonIcons(downloadIcon:UIImage, disableDownloadIcon:UIImage, uploadIcon:UIImage) -> Bool {
        if initSuccess {
            TCUIConfig.defaultConfig.feedDownloadImage = downloadIcon
            TCUIConfig.defaultConfig.feedDownloadMeImage = disableDownloadIcon
            TCUIConfig.defaultConfig.newPostThemeImage = uploadIcon
        } else {
            tcDebugPrint(TCError.uninitialized.error)
            delegate?.teamCirleFail(error: TCError.uninitialized.error)
            return false
        }
        return true
    }
    
    @objc public func setIconNewPost(icon:UIImage) -> Bool {
        if initSuccess {
            TCUIConfig.defaultConfig.userNewPostImage = icon
        } else {
            tcDebugPrint(TCError.uninitialized.error)
            delegate?.teamCirleFail(error: TCError.uninitialized.error)
            return false
        }
        return true
    }
    //背景动效颜色(评论选中，闪烁)
    @objc public func setBackgroundEffectColor(color:UIColor) -> Bool {
        if initSuccess {
            TCUIConfig.defaultConfig.systemBackgroundEffectColor = color
        } else {
            tcDebugPrint(TCError.uninitialized.error)
            delegate?.teamCirleFail(error: TCError.uninitialized.error)
            return false
        }
        return true
    }
    
    @objc public func setSystemBackgroundColor(color:UIColor) -> Bool {
        if initSuccess {
            TCUIConfig.defaultConfig.systemBackgroundColor = color
        } else {
            tcDebugPrint(TCError.uninitialized.error)
            delegate?.teamCirleFail(error: TCError.uninitialized.error)
            return false
        }
        return true
    }
    
    //present导航栏文字颜色
    @objc public func systemNavigationBarTextColor(color:UIColor) -> Bool {
        if initSuccess {
            TCUIConfig.defaultConfig.systemNavigationBarTextColor = color
        } else {
            tcDebugPrint(TCError.uninitialized.error)
            delegate?.teamCirleFail(error: TCError.uninitialized.error)
            return false
        }
        return true
    }
    
    //超链接文字颜色（无透明度的颜色设置透明度会出错）
    @objc public func setLinkColor(color:UIColor) -> Bool {
        if initSuccess {
            if !tallVersion {
                tcDebugPrint(TCError.packageNotSupported.error)
                delegate?.teamCirleFail(error: TCError.packageNotSupported.error)
                return false
            }
            TCUIConfig.defaultConfig.linkColor = color
        } else {
            tcDebugPrint(TCError.uninitialized.error)
            delegate?.teamCirleFail(error: TCError.uninitialized.error)
            return false
        }
        return true
    }
    //产品描述文字颜色（无透明度的颜色设置透明度会出错）
    @objc public func setProductDescColor(color:UIColor) -> Bool {
        if initSuccess {
            if !tallVersion {
                tcDebugPrint(TCError.packageNotSupported.error)
                delegate?.teamCirleFail(error: TCError.packageNotSupported.error)
                return false
            }
            TCUIConfig.defaultConfig.productDescColor = color
        } else {
            tcDebugPrint(TCError.uninitialized.error)
            delegate?.teamCirleFail(error: TCError.uninitialized.error)
            return false
        }
        return true
    }
    @objc public func setPrivacyPolicy(url: String) -> Bool {
        if initSuccess {
            TCUIConfig.defaultConfig.privacyPolicy = url
        } else {
            tcDebugPrint(TCError.uninitialized.error)
            delegate?.teamCirleFail(error: TCError.uninitialized.error)
            return false
        }
        return true
    }
    @objc public func setTermsAndConditions(url: String) -> Bool {
        if initSuccess {
            TCUIConfig.defaultConfig.termsAndConditions = url
        } else {
            tcDebugPrint(TCError.uninitialized.error)
            delegate?.teamCirleFail(error: TCError.uninitialized.error)
            return false
        }
        return true
    }
    @objc public func setShareJsonTitle(title: String) -> Bool {
        if initSuccess {
            TCUIConfig.defaultConfig.shareJsonTitle = title
        } else {
            tcDebugPrint(TCError.uninitialized.error)
            delegate?.teamCirleFail(error: TCError.uninitialized.error)
            return false
        }
        return true
    }
    @objc public func setShareJsonDownloadedTips(tips: String) -> Bool {
        if initSuccess {
            TCUIConfig.defaultConfig.shareJsonTips = tips
        } else {
            tcDebugPrint(TCError.uninitialized.error)
            delegate?.teamCirleFail(error: TCError.uninitialized.error)
            return false
        }
        return true
    }
    
    @objc public func setShareJson(shareJson: TCShareJson) {
        NotificationCenter.default.post(name: NSNotification.Name.TCShare.ShareData, object: shareJson)
    }
    
    @objc public func clearShareJson() {
        NotificationCenter.default.post(name: NSNotification.Name.TCShare.ShareData, object: nil)
    }
    //MARK: IM相关
    /// 创建一个IM按钮
    @objc public func initIMBtn(frame:CGRect, image : Any, title : String, complete : ((TCIMBtn?, Error?) -> Void)) {
        if initSuccess {
            if imStatus {
                complete(TCIMBtn(frame: frame, image: image, title: title), nil)
            } else {
                tcDebugPrint(TCError.imFunctionOff.error)
                complete(nil, TCError.imFunctionOff.error)
            }
        } else {
            tcDebugPrint(TCError.uninitialized.error)
            complete(nil, TCError.uninitialized.error)
        }
    }
    
    @objc func getIMToken(complete: @escaping ((Bool)->())) {
        if initSuccess {
            if imStatus {
                if var user = TCAppEnvironment.current.currentUser {
                    request(.easemobLogin(accountId: user.accountId)).responseDecodableObject { (response: DataResponse<TCUserLogin>) in
                        if let error = response.result.error {
                            tcDebugPrint("failed: \(error.localizedDescription)")
                            tc_getCurrentViewController()?.showHUD(.label(error.localizedDescription))
                            complete(false)
                            return
                        }
                        if let login = response.result.value {
                            user.update(accountId: user.accountId, emUserName: login.emUserName, emUserToken: login.emUserToken, mergeStatus: user.mergeStatus)
                            TCAppEnvironment.updateCurrentUser(user)
                            complete(true)
                        }
                    }
                } else {
                    tcDebugPrint(TCError.userNotLogged.error)
                    TCManager.sharedInstance.delegate?.teamCirleFail(error: TCError.userNotLogged.error)
                    complete(false)
                }
            } else {
                tcDebugPrint(TCError.imFunctionOff.error)
                TCManager.sharedInstance.delegate?.teamCirleFail(error: TCError.imFunctionOff.error)
                complete(false)
            }
        } else {
            tcDebugPrint(TCError.uninitialized.error)
            delegate?.teamCirleFail(error: TCError.uninitialized.error)
            complete(false)
        }
    }
    
    @objc func loginEasemob(complete: @escaping ((Bool)->())) {
        if initSuccess {
            if imStatus {
                if let user = TCAppEnvironment.current.currentUser {
                    if let userName = user.emUserName, let userToken = user.emUserToken {
                        if isLoggedinIM() {
                            self.loadAndUpdateUsers()
                            self.requestUnreadIMMessageCount()
                            complete(true)
                            return
                        }
                        EMClient.shared().login(withUsername: userName, token: userToken) { userName, error in
                            if let error = error {
                                tcDebugPrint("Login IM fail : \(String(describing: error.errorDescription))")
                                complete(false)
                            } else {
                                self.loadAndUpdateUsers()
                                self.requestUnreadIMMessageCount()
                                complete(true)
                            }
                        }
                    } else {
                        complete(false)
                        tcDebugPrint("No IM Information")
                    }
                } else {
                    complete(false)
                    tcDebugPrint(TCError.userNotLogged.error)
                    TCManager.sharedInstance.delegate?.teamCirleFail(error: TCError.userNotLogged.error)
                }
            } else {
                tcDebugPrint(TCError.imFunctionOff.error)
                TCManager.sharedInstance.delegate?.teamCirleFail(error: TCError.imFunctionOff.error)
                complete(false)
            }
        } else {
            complete(false)
            tcDebugPrint(TCError.uninitialized.error)
            delegate?.teamCirleFail(error: TCError.uninitialized.error)
        }
    }
    
    @objc public func isLoggedinIM() -> Bool {
        if let userIM = TCAppEnvironment.current.currentUser?.emUserName, EMClient.shared().isLoggedIn, userIM == EMClient.shared().currentUsername {
            return true
        }
        return false
    }
    
    @objc public func toChatListAction(nav: UINavigationController) {
        if initSuccess {
            if imStatus {
                if let user = TCAppEnvironment.current.currentUser {
                    if user.emUserName != nil, user.emUserToken != nil {
                        if isLoggedinIM() {
                            self.toChatListVC(nav: nav)
                        } else {
                            loginEasemob { [weak self] success in
                                if success {
                                    self?.toChatListVC(nav: nav)
                                }
                            }
                        }
                    } else {
                        getIMToken { [weak self] success in
                            if success {
                                self?.loginEasemob(complete: { login in
                                    if login {
                                        self?.toChatListVC(nav: nav)
                                    }
                                })
                            }
                        }
                    }
                } else {
                    tcDebugPrint(TCError.userNotLogged.error)
                    TCManager.sharedInstance.delegate?.teamCirleFail(error: TCError.userNotLogged.error)
                }
            } else {
                tcDebugPrint(TCError.imFunctionOff.error)
                TCManager.sharedInstance.delegate?.teamCirleFail(error: TCError.imFunctionOff.error)
            }
        } else {
            tcDebugPrint(TCError.uninitialized.error)
            delegate?.teamCirleFail(error: TCError.uninitialized.error)
        }
    }
    
    @objc public func toChatAction(nav: UINavigationController, conversationId: String) {
        if initSuccess {
            if imStatus {
                if let user = TCAppEnvironment.current.currentUser {
                    if user.emUserName != nil, user.emUserToken != nil {
                        if isLoggedinIM() {
                            self.toChatVC(nav: nav, conversationId: conversationId)
                        } else {
                            loginEasemob { [weak self] success in
                                if success {
                                    self?.toChatVC(nav: nav, conversationId: conversationId)
                                }
                            }
                        }
                    } else {
                        getIMToken { [weak self] success in
                            if success {
                                self?.loginEasemob(complete: { login in
                                    if login {
                                        self?.toChatVC(nav: nav, conversationId: conversationId)
                                    }
                                })
                            }
                        }
                    }
                } else {
                    tcDebugPrint(TCError.userNotLogged.error)
                    TCManager.sharedInstance.delegate?.teamCirleFail(error: TCError.userNotLogged.error)
                }
            } else {
                tcDebugPrint(TCError.imFunctionOff.error)
                TCManager.sharedInstance.delegate?.teamCirleFail(error: TCError.imFunctionOff.error)
            }
        } else {
            tcDebugPrint(TCError.uninitialized.error)
            delegate?.teamCirleFail(error: TCError.uninitialized.error)
        }
    }
    @objc public func getGifVC() -> GiphyViewController {
        let giphy = GiphyViewController()
        let theme = GPHTheme(type: GPHThemeType.darkBlur)
        GiphyViewController.trayHeightMultiplier = 0.5
        giphy.theme = theme
        giphy.mediaTypeConfig = [.gifs, .stickers, .text, .emoji, .recents]
        giphy.layout = GPHGridLayout.waterfall
        giphy.rating = .ratedPG13
        giphy.showConfirmationScreen = true
        giphy.shouldLocalizeSearch = true
        giphy.dimBackground = true
        giphy.showCheckeredBackground = true
        giphy.hidesBottomBarWhenPushed = true
        giphy.modalPresentationStyle = .overFullScreen
        return giphy
    }
    @objc public func toClearGifCache() {
        GPHCache.shared.clear(.memoryOnly)
    }
    @objc public func uploadIMVideo(url: URL, complete: @escaping (_ url: String?) -> Void) {
        TCTransferUtility.shared.uploadVideo(with: url, type: .imVideo) { result in
            switch result {
            case let .success(url):
                complete(url)
            default:
                complete(nil)
            }
        }
    }
    @objc public func convertVideoUrl(url: String, complete: @escaping (_ url: String?) -> Void) {
        TCTransferUtility.shared.convertVideoURL(url: url) { convertUrl in
            complete(convertUrl)
        }
    }
    @objc public func msgShowHUD(content: String, delay: TimeInterval) {
        DispatchQueue.main.async {
            HUD.flash(.label(content), delay: delay)
        }
    }
    @objc public func msgShowHUDSuccess() {
        DispatchQueue.main.async {
            HUD.flash(.success, delay: 2)
        }
    }
    
    @objc public func canLoadIMDataFromServer() -> Bool {
        if isLoggedinIM(), let user = EMClient.shared().currentUsername {
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathUrl = URL(fileURLWithPath: path).appendingPathComponent( "TCIMNotDataServer.plist")
            if let users = NSMutableArray(contentsOf: pathUrl) {
                return !users.contains(user)
            } else {
                return true
            }
        }
        return false
    }
    
    @objc public func setIMDataNotFromServer() {
        if isLoggedinIM(), let user = EMClient.shared().currentUsername {
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathUrl = URL(fileURLWithPath: path).appendingPathComponent("TCIMNotDataServer.plist")
            var users = NSMutableArray()
            if let arrs = NSMutableArray(contentsOf: pathUrl) {
                users = arrs
            }
            if !users.contains(user) {
                users.add(user)
                users.write(to: pathUrl, atomically: true)
            }
        }
    }
    
    private func toChatListVC(nav: UINavigationController) {
        let converts = EMConversationsViewController()
        converts.hidesBottomBarWhenPushed = true
        nav.pushViewController(converts, animated: true)
    }
    private func loadAndUpdateUsers() {
        UserInfoStore.sharedInstance().loadInfosFromLocal()
        let convers = EMClient.shared().chatManager?.getAllConversations()
        
        if let conversations = convers, conversations.count > 0 {
            var conversationIds = [String]()
            conversationIds.append(contentsOf: conversations.map{$0.conversationId})
            UserInfoStore.sharedInstance().fetchUserInfos(fromServer: conversationIds)
        } else {
            if canLoadIMDataFromServer() {
                EMClient.shared().chatManager?.getConversationsFromServer({ convers, error in
                    if let conversations = convers {
                        var conversationIds = [String]()
                        conversationIds.append(contentsOf: conversations.map{$0.conversationId})
                        UserInfoStore.sharedInstance().fetchUserInfos(fromServer: conversationIds)
                    }
                })
            }
        }
//        if !EMDemoOptions.shared().isFirstLaunch {
//            EMClient.shared().chatManager?.getConversationsFromServer { convers, error in
//                if let conversations = convers {
//                    for conversation in conversations {
//                        UserInfoStore.sharedInstance().fetchUserInfos(fromServer: [conversation.conversationId])
//                    }
//                }
//            }
//        } else {
//            let convers = EMClient.shared().chatManager?.getAllConversations()
//            if let conversations = convers {
//                for conversation in conversations {
//                    UserInfoStore.sharedInstance().fetchUserInfos(fromServer: [conversation.conversationId])
//                }
//            }
//        }
    }
    @objc public func getPhotoPickerVC() -> UINavigationController {
        let vc = TCPhotoPickerNavController.initPickerVCtrlNav()
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
    
    @objc public func getBundlePath() -> Bundle {
        return getBundle()
    }
    @objc public func getTheme() -> TCThemeType {
        return TCUIConfig.defaultConfig.theme
    }
    @objc public func setNavigationAttribute(navigation: UINavigationController?) {
        TCUIConfig.defaultConfig.setNavigationAttribute(navigation: navigation)
    }
    
    private func toChatVC(nav: UINavigationController, conversationId: String) {
        let converts = EMChatViewController.init(conversationId: conversationId, conversationType: .chat)
        converts.hidesBottomBarWhenPushed = true
        nav.pushViewController(converts, animated: true)
    }
    
    //可获取属性
    @objc public var systemTextFront: UIFont {
        return TCUIConfig.defaultConfig.systemTextFront
    }
    @objc public var systemUserFront: UIFont {
        return TCUIConfig.defaultConfig.systemUserFront
    }
    @objc public var systemText2Front: UIFont {
        return TCUIConfig.defaultConfig.systemText2Front
    }
    @objc public var systemText3Front: UIFont {
        return TCUIConfig.defaultConfig.systemText3Front
    }
    @objc public var systemText4Front: UIFont {
        return TCUIConfig.defaultConfig.systemText4Front
    }
    @objc public var feedOfficialFont: UIFont {
        return TCUIConfig.defaultConfig.feedOfficialFont
    }
    @objc public var chatViewTitleFront: UIFont {
        return TCUIConfig.defaultConfig.chatViewTitleFront
    }
    @objc public var systemTextColor: UIColor {
        return TCUIConfig.defaultConfig.systemTextColor
    }
    @objc public var systemText2Color: UIColor {
        return TCUIConfig.defaultConfig.systemText2Color
    }
    @objc public var systemUserColor: UIColor {
        return TCUIConfig.defaultConfig.systemUserColor
    }
    @objc public var systemBackgroundColor: UIColor {
        return TCUIConfig.defaultConfig.systemBackgroundColor
    }
    @objc public var searchBoxBgColor: UIColor {
        return TCUIConfig.defaultConfig.searchBoxBgColor
    }
    @objc public var systemSeparatorColor: UIColor {
        return TCUIConfig.defaultConfig.systemSeparatorColor
    }
    @objc public var feedOfficialBgColor: UIColor {
        return TCUIConfig.defaultConfig.feedOfficialBgColor
    }
    @objc public var feedOfficialColor: UIColor {
        return TCUIConfig.defaultConfig.feedOfficialColor
    }
    @objc public var systemBackgroundEffectColor: UIColor {
        return TCUIConfig.defaultConfig.systemBackgroundEffectColor
    }
    @objc public var msgSendBGColor: UIColor {
        return TCUIConfig.defaultConfig.msgSendBGColor
    }
    @objc public var msgRecvBGColor: UIColor {
        return TCUIConfig.defaultConfig.msgRecvBGColor
    }
    @objc public var msgTextBoxColor: UIColor {
        return TCUIConfig.defaultConfig.msgTextBoxColor
    }
    @objc public var msgLinkColor: UIColor {
        return TCUIConfig.defaultConfig.msgLinkColor
    }
    @objc public var userUnfollowbgColor: UIColor {
        return TCUIConfig.defaultConfig.userUnfollowbgColor
    }
    @objc public var productListBgColor: UIColor {
        return TCUIConfig.defaultConfig.productListBgColor
    }
    @objc public var productListCellBgColor: UIColor {
        return TCUIConfig.defaultConfig.productListCellBgColor
    }
    @objc public var msgDetailCellbgColor: UIColor {
        return TCUIConfig.defaultConfig.msgDetailCellbgColor
    }
    @objc public var msgDetailSeparatorColor: UIColor {
        return TCUIConfig.defaultConfig.msgDetailSeparatorColor
    }
    @objc public var msgDetailSwitchOffColor: UIColor {
        return TCUIConfig.defaultConfig.msgDetailSwitchOffColor
    }
    @objc public var msgSendTextColor: UIColor {
        return TCUIConfig.defaultConfig.msgSendTextColor
    }
    @objc public var msgRecvTextColor: UIColor {
        return TCUIConfig.defaultConfig.msgRecvTextColor
    }
    @objc public var msgChatBGColor: UIColor {
        return TCUIConfig.defaultConfig.msgChatBGColor
    }
    @objc public var msgDetailBGColor: UIColor {
        return TCUIConfig.defaultConfig.msgDetailBGColor
    }
    @objc public var backImage: UIImage {
        return TCUIConfig.defaultConfig.backImage ?? UIImage()
    }
    @objc public var newPostSearchImage: UIImage {
        return TCUIConfig.defaultConfig.newPostSearchImage ?? UIImage()
    }
    @objc public var systemDefaultUserImage: UIImage {
        return TCUIConfig.defaultConfig.systemDefaultUserImage ?? UIImage()
    }
    @objc public var systemPlaceholderUserImage: UIImage {
        return TCUIConfig.defaultConfig.systemPlaceholderUserImage ?? UIImage()
    }
    @objc public var feedMoreImage: UIImage {
        return TCUIConfig.defaultConfig.feedMoreImage ?? UIImage()
    }
    @objc public var msgSendBGImage: UIImage {
        return TCUIConfig.defaultConfig.msgSendBGImage ?? UIImage()
    }
    @objc public var msgRecvBGImage: UIImage {
        return TCUIConfig.defaultConfig.msgRecvBGImage ?? UIImage()
    }
    @objc public var msgChatBarMoreImage: UIImage {
        return TCUIConfig.defaultConfig.msgChatBarMoreImage ?? UIImage()
    }
    @objc public var msgChatBarCancelMoreImage: UIImage {
        return TCUIConfig.defaultConfig.msgChatBarCancelMoreImage ?? UIImage()
    }
    @objc public var msgChatBarVoiceImage: UIImage {
        return TCUIConfig.defaultConfig.msgChatBarVoiceImage ?? UIImage()
    }
    @objc public var msgChatBarKeyboardImage: UIImage {
        return TCUIConfig.defaultConfig.msgChatBarKeyboardImage ?? UIImage()
    }
    @objc public var msgChatBarGifImage: UIImage {
        return TCUIConfig.defaultConfig.msgChatBarGifImage ?? UIImage()
    }
    @objc public var msgChatBarAlbumImage: UIImage {
        return TCUIConfig.defaultConfig.msgChatBarAlbumImage ?? UIImage()
    }
    @objc public var msgChatBarCameraImage: UIImage {
        return TCUIConfig.defaultConfig.msgChatBarCameraImage ?? UIImage()
    }
    @objc public var msgSendFailImage: UIImage {
        return TCUIConfig.defaultConfig.msgSendFailImage ?? UIImage()
    }
    @objc public var msgCopyImage: UIImage {
        return TCUIConfig.defaultConfig.msgCopyImage ?? UIImage()
    }
    @objc public var msgDeleteImage: UIImage {
        return TCUIConfig.defaultConfig.msgDeleteImage ?? UIImage()
    }
    @objc public var msgRecallImage: UIImage {
        return TCUIConfig.defaultConfig.msgRecallImage ?? UIImage()
    }
    @objc public var msgForwardImage: UIImage {
        return TCUIConfig.defaultConfig.msgForwardImage ?? UIImage()
    }
    @objc public var msgSaveImage: UIImage {
        return TCUIConfig.defaultConfig.msgSaveImage ?? UIImage()
    }
    @objc public var msgSendAudioImage: UIImage {
        return TCUIConfig.defaultConfig.msgSendAudioImage ?? UIImage()
    }
    @objc public var msgSendAudio1Image: UIImage {
        return TCUIConfig.defaultConfig.msgSendAudio1Image ?? UIImage()
    }
    @objc public var msgSendAudio2Image: UIImage {
        return TCUIConfig.defaultConfig.msgSendAudio2Image ?? UIImage()
    }
    @objc public var msgRecvAudioImage: UIImage {
        return TCUIConfig.defaultConfig.msgRecvAudioImage ?? UIImage()
    }
    @objc public var msgRecvAudio1Image: UIImage {
        return TCUIConfig.defaultConfig.msgRecvAudio1Image ?? UIImage()
    }
    @objc public var msgRecvAudio2Image: UIImage {
        return TCUIConfig.defaultConfig.msgRecvAudio2Image ?? UIImage()
    }
    @objc public var feedMusicPauseImage: UIImage {
        return TCUIConfig.defaultConfig.feedMusicPauseImage ?? UIImage()
    }
    @objc public var msgImgBrokenImage: UIImage {
        return TCUIConfig.defaultConfig.msgImgBrokenImage ?? UIImage()
    }
    @objc public var msgVideoDefaultImage: UIImage {
        return TCUIConfig.defaultConfig.msgVideoDefaultImage ?? UIImage()
    }
    @objc public var msgAudioBtnImage: UIImage {
        return TCUIConfig.defaultConfig.msgAudioBtnImage ?? UIImage()
    }
    @objc public var msgAudioSlide01WhiteImage: UIImage {
        return TCUIConfig.defaultConfig.msgAudioSlide01WhiteImage ?? UIImage()
    }
    @objc public var msgAudioSlide02WhiteImage: UIImage {
        return TCUIConfig.defaultConfig.msgAudioSlide02WhiteImage ?? UIImage()
    }
    @objc public var msgAudioSlide03WhiteImage: UIImage {
        return TCUIConfig.defaultConfig.msgAudioSlide03WhiteImage ?? UIImage()
    }
    @objc public var msgAudioSlide01BlueImage: UIImage {
        return TCUIConfig.defaultConfig.msgAudioSlide01BlueImage ?? UIImage()
    }
    @objc public var msgAudioSlide02BlueImage: UIImage {
        return TCUIConfig.defaultConfig.msgAudioSlide02BlueImage ?? UIImage()
    }
    @objc public var msgAudioSlide03BlueImage: UIImage {
        return TCUIConfig.defaultConfig.msgAudioSlide03BlueImage ?? UIImage()
    }
    @objc public var msgRedAudioBtnImage: UIImage {
        return TCUIConfig.defaultConfig.msgRedAudioBtnImage ?? UIImage()
    }
    @objc public var msgBlueAudioBtnImage: UIImage {
        return TCUIConfig.defaultConfig.msgBlueAudioBtnImage ?? UIImage()
    }
    @objc public var userRightImage: UIImage {
        return TCUIConfig.defaultConfig.userRightImage ?? UIImage()
    }
    @objc public var msgListMuteImage: UIImage {
        return TCUIConfig.defaultConfig.msgListMuteImage ?? UIImage()
    }
    @objc public var msgAbumImage: UIImage {
        return TCUIConfig.defaultConfig.msgAbumImage ?? UIImage()
    }
    @objc public var userMoreImage: UIImage {
        return TCUIConfig.defaultConfig.userMoreImage ?? UIImage()
    }
    @objc public var msgShareImage: UIImage {
        return TCUIConfig.defaultConfig.msgShareImage ?? UIImage()
    }
    @objc public var searchText: String {
        return .tc_localized_Search
    }
    @objc public var messageText: String {
        return .tc_localized_Message
    }
    @objc public var noChatInformationText: String {
        return .tc_localized_NoChatInformation
    }
    @objc public var officialStaffText: String {
        return .tc_localized_OfficialStaff
    }
    @objc public var deleteText: String {
        return .tc_localized_Delete
    }
    @objc public var areYouSureToDeleteText: String {
        return .tc_localized_AreYouSureToDelete
    }
    @objc public var cancelText: String {
        return .tc_localized_Cancel
    }
    @objc public var stickOnTopText: String {
        return .tc_localized_StickOnTop
    }
    @objc public var cancelOnTopText: String {
        return .tc_localized_CancelOnTop
    }
    @objc public var markAsReadText: String {
        return .tc_localized_MarkAsRead
    }
    @objc public var markAsUnreadText: String {
        return .tc_localized_MarkAsUnread
    }
    @objc public var typingText: String {
        return .tc_localized_Typing
    }
    @objc public var albumText: String {
        return .tc_localized_Album
    }
    @objc public var cameraText: String {
        return .tc_localized_Camera
    }
    @objc public var sendAMessageText: String {
        return .tc_localized_SendAMessage
    }
    @objc public var readText: String {
        return .tc_localized_Read
    }
    @objc public var pictureText: String {
        return .tc_localized_Picture
    }
    @objc public var videoText: String {
        return .tc_localized_Video
    }
    @objc public var someoneMeText: String {
        return .tc_localized_SomeoneMe
    }
    @objc public var youRetractMessageText: String {
        return .tc_localized_YouRetractMessage
    }
    @objc public var theOtherPartyWithdrawsMessageText: String {
        return .tc_localized_TheOtherPartyWithdrawsMessage
    }
    @objc public var copyText: String {
        return .tc_localized_Copy
    }
    @objc public var withdrawText: String {
        return .tc_localized_Withdraw
    }
    @objc public var forwardText: String {
        return .tc_localized_Forward
    }
    @objc public var saveText: String {
        return .tc_localized_Save
    }
    @objc public var selectLinkOpenText: String {
        return .tc_localized_SelectLinkOpen
    }
    @objc public var getThumbnailsText: String {
        return .tc_localized_GetThumbnails
    }
    @objc public var downloadOriginalText: String {
        return .tc_localized_DownloadOriginal
    }
    @objc public var failedDownloadOriginalText: String {
        return .tc_localized_FailedDownloadOriginal
    }
    @objc public var failedGetOriginalText: String {
        return .tc_localized_FailedGetOriginal
    }
    @objc public var downloadingVoiceLaterText: String {
        return .tc_localized_DownloadingVoiceLater
    }
    @objc public var downloadVoiceText: String {
        return .tc_localized_DownloadVoice
    }
    @objc public var failedDownloadVoiceText: String {
        return .tc_localized_FailedDownloadVoice
    }
    @objc public var downloadVideoText: String {
        return .tc_localized_DownloadVideo
    }
    @objc public var failedDownloadVideoText: String {
        return .tc_localized_FailedDownloadVideo
    }
    @objc public var downloadingVideoLaterText: String {
        return .tc_localized_DownloadingVideoLater
    }
    @objc public var downloadThumbnailsText: String {
        return .tc_localized_DownloadThumbnails
    }
    @objc public var holdToTalkText: String {
        return .tc_localized_HoldToTalk
    }
    @objc public var releaseSendText: String {
        return .tc_localized_ReleaseSend
    }
    @objc public var releaseCancelText: String {
        return .tc_localized_ReleaseCancel
    }
    @objc public var pictureTooBigText: String {
        return .tc_localized_PictureTooBig
    }
    @objc public var videoTooLargeText: String {
        return .tc_localized_VideoTooLarge
    }
    @objc public var speakingTimeTooShortText: String {
        return .tc_localized_SpeakingTimeTooShort
    }
    @objc public var relayMessageText: String {
        return .tc_localized_RelayMessage
    }
    @objc public var detailText: String {
        return .tc_localized_Detail
    }
    @objc public var clearChatPromptText: String {
        return .tc_localized_ClearChatPrompt
    }
    @objc public var clearText: String {
        return .tc_localized_Clear
    }
    @objc public var chatHistoryClearedText: String {
        return .tc_localized_ChatHistoryCleared
    }
    @objc public var failedClearChatRecordText: String {
        return .tc_localized_FailedClearChatRecord
    }
    @objc public var failedSetNoDisturbText: String {
        return .tc_localized_FailedSetNoDisturb
    }
    @objc public var searchChatHistoryText: String {
        return .tc_localized_SearchChatHistory
    }
    @objc public var browseChatMediaText: String {
        return .tc_localized_BrowseChatMedia
    }
    @objc public var muteNotificationText: String {
        return .tc_localized_MuteNotification
    }
    @objc public var stickyOnTopText: String {
        return .tc_localized_StickyOnTop
    }
    @objc public var clearChatHistoryText: String {
        return .tc_localized_ClearChatHistory
    }
    @objc public var mediaText: String {
        return .tc_localized_Media
    }
    @objc public var noText: String {
        return .tc_localized_No
    }
    @objc public var chathistoryfoundText: String {
        return .tc_localized_Chathistoryfound
    }
    @objc public var voiceText: String {
        return .tc_localized_Voice
    }
    @objc public var noResultText: String {
        return .tc_localized_NoResult
    }
    @objc public var yesterdayText: String {
        return .tc_localized_Yesterday
    }
    @objc public var msgHasBlockdPromptText: String {
        return .tc_localized_MsgHasBlockdPrompt
    }
    @objc public var bANALLACTIVITIESPromptText: String {
        return .tc_localized_BANALLACTIVITIESPrompt
    }
    @objc public var closeText: String {
        return .tc_localized_Close
    }
    @objc public var doneText: String {
        return .tc_localized_Done
    }
    @objc public var msgIMPhotoFinishName: NSNotification.Name {
        return NSNotification.Name.TCIMMessage.PhotoFinish
    }
    @objc public var msgIMVidoFinishName: NSNotification.Name {
        return NSNotification.Name.TCIMMessage.VidoFinish
    }
    @objc public var commentPhotoName: NSNotification.Name {
        return NSNotification.Name.TCComment.Photo
    }
    @objc public var messageIMPostOjbect: String {
        return "messageIMMeidia"
    }
    @objc public var messageIMCustomVideoEvent: String {
        return "REMOTE_VIDEO"
    }
    @objc public var messageIMCustomVideoKey: String {
        return "VIDEO_URL"
    }
    @objc public var messageIMChatPageKey: String {
        return "messageIMChatPageKey"
    }
}

extension TCManager {
    func getAccountStatistics() {
        request(.accountStatistics(accountId: TCAppEnvironment.current.currentUser!.accountId)).responseDecodableObject { (response : DataResponse<TCUserStatistics>) in
            if let error = response.error {
                tcDebugPrint("failed: \(error.localizedDescription)")
                return
            }
            if let statistics = response.value {
                TCAppEnvironment.current.currentUser?.updateStatistics(user: statistics)
            }
        }
    }
    
    private func initHyphenateChat() {
        let options = EMOptions(appkey: TCAppEnvironment.current.apiService.serverConfig.hcAppKey)
        options.isAutoLogin = true
//        options.enableConsoleLog = true
//        options?.logLevel = .debug
        // FIXME:证书名
//        options?.apnsCertName = ""
        if let error = EMClient.shared().initializeSDK(with: options) {
            tcDebugPrint("---IM init Fail:\(error)")
        }
        EMClient.shared().chatManager?.add(TCManager.sharedInstance, delegateQueue: nil)
        EMClient.shared().add(TCManager.sharedInstance, delegateQueue: nil)
    }
    
    private func sendIMLocalNotification(userId: String, type: String) {
        let user = UserInfoStore.sharedInstance().getUserInfo(byId: userId)
        if user == nil {
            EMClient.shared().userInfoManager?.fetchUserInfo(byId: [userId]) { infos, error in
                if let userInfos = infos {
                    for uid in userInfos.keys {
                        if let info = userInfos[uid] as? EMUserInfo, let nickname = info.nickname {
                            self.sendIMLocalNotification(name: nickname, type: type)
                        }
                    }
                }
            }
        } else {
            if let nickname = user.nickname {
                self.sendIMLocalNotification(name: nickname, type: type)
            }
        }
    }
    
    private func sendIMLocalNotification(name: String, type: String) {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.body = "\(name) send you a \(type)"
        content.userInfo = ["notificationType":"MESSAGE"]
        let request = UNNotificationRequest(identifier: Date().milliStamp, content: content, trigger: nil)
        center.add(request)
    }
}

extension TCManager: EMChatManagerDelegate {
    public func messagesDidReceive(_ aMessages: [EMChatMessage]) {
        self.requestUnreadIMMessageCount()
        for amessage in aMessages {
            if let message = amessage as? EMChatMessage {
                let user = UserInfoStore.sharedInstance().getUserInfo(byId: message.conversationId)
                if user == nil {
                    UserInfoStore.sharedInstance().fetchUserInfos(fromServer: [message.conversationId])
                }
                if
                    let noPushs = EMClient.shared().pushManager?.noPushUIds as? [String], noPushs.contains(message.conversationId) {
                    return
                }
                if UIApplication.shared.applicationState != .active {
                    let body = message.body
                    var type = "message"
                    switch body.type {
                    case .image:
                        type = "photo"
                    case .text:
                        type = "message"
                    case .voice:
                        type = "voice"
                    default:
                        type = "video"
                    }
                    sendIMLocalNotification(userId: message.conversationId, type: type)
                }
            }
        }
    }
    
    public func messagesDidRead(_ aMessages: [EMChatMessage]) {
        self.requestUnreadIMMessageCount()
    }
    
    public func conversationListDidUpdate(_ aConversationList: [EMConversation]) {
        self.requestUnreadIMMessageCount()
    }
    
    public func onConversationRead(_ from: String, to: String) {
        self.requestUnreadIMMessageCount()
    }
}

extension TCManager: EMClientDelegate {
    public func userAccountDidForced(toLogout aError: EMError?) {
        EMClient.shared().logout(true) { error in
            if var user = TCAppEnvironment.current.currentUser {
                user.update(accountId: user.accountId, emUserName: user.emUserName, emUserToken: nil, mergeStatus: user.mergeStatus);
                TCAppEnvironment.updateCurrentUser(user)
            }
        }
    }
    
    public func autoLoginDidCompleteWithError(_ aError: EMError?) {
        if aError == nil {
            self.loadAndUpdateUsers()
            self.requestUnreadIMMessageCount()
        } else if let aError = aError {
            tcDebugPrint("autoLogin fail:code:\(aError.code),error:\(String(describing: aError.errorDescription))")
        }
    }
}
