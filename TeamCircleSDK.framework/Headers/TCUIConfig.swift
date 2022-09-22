//
//  TCUIConfig.swift
//  TeamCircleSDK
//
//  Created by JasonTang on 2021/1/21.
//  Copyright © 2021 Thirtydays. All rights reserved.
//

import UIKit

@objc class TCUIConfig: NSObject {
    @objc public static let defaultConfig = TCUIConfig()
    
    @objc public var videoMuted = true
    
    @objc public var systemTextFront = TCTextStyle.HelveticaNeue.font(.light, size: 14)
    //全局的字体样式
    @objc public var theme : TCThemeType = .light {
        didSet {
            changeTheme()
        }
    }
    //一级文本
    @objc public var systemTextColor = UIColor.white
    //二级文本
    @objc public var systemText2Front = TCTextStyle.HelveticaNeue.font(.light, size: 12)
    @objc public var systemText2Color = UIColor.white.withAlphaComponent(0.6)
    //辅助信息
    @objc public var systemText3Front = TCTextStyle.HelveticaNeue.font(.light, size: 10)
    @objc public var systemText3Color = UIColor.white.withAlphaComponent(0.3)
    @objc public var systemText4Front = TCTextStyle.HelveticaNeue.font(.medium, size: 12)
    @objc public var chatViewTitleFront = TCTextStyle.HelveticaNeue.font(.medium, size: 16)
    //全局的用户名样式
    @objc public var systemUserFront = TCTextStyle.HelveticaNeue.font(.medium, size: 14)
    @objc public var systemUserColor = UIColor.white
    @objc public var systemNavigationBarTextColor = UIColor.white
    //全局的按钮样式
    @objc public var systemActionFront = TCTextStyle.Helvetica.font(.regular, size: 14)
    @objc public var systemActionColor = UIColor.init(hex6: 0x0081D6)
    
    //全局的缺省图片
    @objc public var systemDefaultImage = UIImage.imageInBundle(name: "loading")
    //全局的缺省头像
    @objc public var systemDefaultUserImage = UIImage.imageInBundle(name: "default_User_dark")
    //全局的加载头像
    @objc public var systemPlaceholderUserImage = UIImage.imageInBundle(name: "placeholderimg_dark")
    //返回
    @objc public var backImage = UIImage.imageInBundle(name: "Back_dark")
    
    //分割线
    @objc public var systemSeparatorColor = UIColor.white.withAlphaComponent(0.08)
    //全局的页面背景颜色
    @objc public var systemBackgroundColor = UIColor.init(hex6: 0x1A1F25)
    //全局的页面背景动效颜色
    @objc public var systemBackgroundEffectColor = UIColor.white.withAlphaComponent(0.05)
    
    //超链接颜色（无透明度的颜色设置透明度会出错）
    @objc public var linkColor = UIColor.init(hex6: 0x1B99F5)
    //店铺
    @objc public var productFront = TCTextStyle.Helvetica.font(size: 16)
    @objc public var productColor = UIColor.white
    //产品描述颜色（无透明度的颜色）
    @objc public var productDescColor = UIColor.init(hex6: 0x76797C)
    //列表
    @objc public var productListBgColor = UIColor.init(hex6: 0x1A1F25)
    @objc public var productListCellBgColor = UIColor.white.withAlphaComponent(0.1)
    @objc public var priceFront = TCTextStyle.Helvetica.font(.bold, size: 20)
    @objc public var priceColor = UIColor.white
    @objc public var pricedecimalFront = TCTextStyle.Helvetica.font(.bold, size: 12)
    @objc public var pricedecimalColor = UIColor.white
    @objc public var storeButtonBarItemFont = TCTextStyle.HelveticaNeue.font(.medium, size: 24)
    @objc public var storeSecondButtonBarItemFont = TCTextStyle.HelveticaNeue.font(.regular, size: 14)
    @objc public var storeButtonBarItemTitleColor = UIColor.white.withAlphaComponent(0.45)
    @objc public var storeButtonBarItemSelectTitleColor = UIColor.white
    
    // MARK: CircleVCtrl
    @objc public var circleStore = UIImage.imageInBundle(name: "circle_store_dark")
    @objc public var circleSearch = UIImage.imageInBundle(name: "circle_search_dark")
    @objc public var circleUserCenter = UIImage.imageInBundle(name: "circle_account_dark")
    @objc public var circleMessage = UIImage.imageInBundle(name: "circle_message_dark")
    
    // MARK: feed页
    //产品tag标注字
    @objc public var feedTagPointTextColor = UIColor.black
    //产品tag背景色
    @objc public var feedTagbgColor = UIColor.white.withAlphaComponent(0.05)
    //产品tag背景色选中
    @objc public var feedTagbgSelectedColor = UIColor(hex6: 0x393F49)
    //产品tag右图标
    @objc public var feedTagRightImage = UIImage.imageInBundle(name: "right_arrow_dark")
    //收藏
    @objc public var feedFavoriteSelectedImage = UIImage.imageInBundle(name: "post_favor-sel")
    //取消收藏
    @objc public var feedFavoriteImage = UIImage.imageInBundle(name: "post_favor_dark")
    //喜欢
    @objc public var feedLikeSelectedImage = UIImage.imageInBundle(name: "post_like-sel")
    //取消喜欢选中
    @objc public var feedLikeImage = UIImage.imageInBundle(name: "post_like_dark")
    //评论
    @objc public var feedCommentImage = UIImage.imageInBundle(name: "post_comment_dark")
    //分享
    @objc public var feedShareImage = UIImage.imageInBundle(name: "share_dark")
    //多图分页器
    @objc public var feedPageContrlColor = UIColor.white
    //多图分页器选中
    @objc public var feedPageContrlSelectedColor = UIColor.init(hex6: 0x1B99F5)
    //下载
    @objc public var feedDownloadImage = UIImage.imageInBundle(name: "download_dark")
    //下载本人不可下载
    @objc public var feedDownloadMeImage = UIImage.imageInBundle(name: "download-me_dark")
    //shareJsoncell 选中
    @objc public var feedShareJsonCellSelectedColor = UIColor.init(hex6: 0x12151A)
    //暂停
    @objc public var feedMusicPauseImage = UIImage.imageInBundle(name: "Music_Pause")
    
    //更多
    @objc public var feedMoreImage = UIImage.imageInBundle(name: "feed_more_dark")
    //new post位置
    public var feedNewPostRect : CGRect?
    
    //回复条背景色
    @objc public var feedReplyViewBgColor = UIColor.init(hex6: 0x393F49)
    //评论框提示字
//    @objc public var feedCommentPromptColor = UIColor.init(hex6: 0x76797C)
    //点赞文字
//    @objc public var feedLikeColor = UIColor.init(hex6: 0x000102)
    //评论数
//    @objc public var feedCommentNumColor = UIColor.init(hex6: 0x868788)
    //提示回复文字
//    @objc public var feedPromptCommentColor = UIColor.init(hex6: 0x868788)
    //发帖时间
//    @objc public var feedPostTimeColor = UIColor.init(hex6: 0x868788)
    ///详情
    //评论时间
//    @objc public var feedCommentTimeColor = UIColor.init(hex6: 0x868788)
    //回复文字
//    @objc public var feedCommentColor = UIColor.init(hex6: 0x868788)
    //展开文字
//    @objc public var feedOpenColor = UIColor.init(hex6: 0x868788)
    
    
    //官方标识
    @objc public var feedOfficialColor = UIColor.init(hex6: 0xF08C00)
    @objc public var feedOfficialFont = TCTextStyle.HelveticaNeue.font(.medium, size: 10)
    @objc public var feedOfficialBgColor = UIColor.init(hex6: 0xFDEED9)
    
    // MARK: user center页
    //notification
    @objc public var userNotificationImage = UIImage.imageInBundle(name: "notification_dark")
    //edit
    @objc public var userEditImage = UIImage.imageInBundle(name: "edit_profile_dark")
    //已关注按钮背景色
    @objc public var userFollowbgColor = UIColor.clear
    //已关注按钮文字色
    @objc public var userFollowTextColor = UIColor.white
    //已关注按钮图标
    @objc public var userFollowImage : UIImage?//UIImage.imageInBundle(name: "arrow_triangle")
    //已关注按钮border color
    @objc public var userFollowBorderColor = UIColor.white.withAlphaComponent(0.2)
    //未关注按钮背景色
    @objc public var userUnfollowbgColor = UIColor.init(hex6: 0x0081D6)
    //未关注按钮文字色
    @objc public var userUnfollowTextColor = UIColor.white
    //未关注按钮图标
    @objc public var userUnfollowImage = UIImage.imageInBundle(name: "")
    //未关注按钮border color
    @objc public var userUnfollowBorderColor = UIColor.clear
    //换头像图片
    @objc public var userAddPhotoImage = UIImage.imageInBundle(name: "profile_add_dark")
    //我的更多按钮图标
    @objc public var userMoreImage = UIImage.imageInBundle(name: "user_more_dark")
    //我的右箭头
    @objc public var userRightImage = UIImage.imageInBundle(name: "user_right_arrow_dark")
    //我的post选中图标
    @objc public var userMyPostSelectedImage = UIImage.imageInBundle(name: "My Posts_dark")
    //我的post未选中图标
    @objc public var userMyPostImage = UIImage.imageInBundle(name: "My_Post nor_dark")
    //我的收藏选中图标
    @objc public var userMyFavoriteSelectedImage = UIImage.imageInBundle(name: "post_favor_dark")
    //我的收藏未选中图标
    @objc public var userMyFavoriteImage = UIImage.imageInBundle(name: "My_Favor nor_dark")
    //new post图标
    @objc public var userNewPostImage = UIImage.imageInBundle(name: "newPost_dark")
    //new post位置
    public var userNewPostRect: CGRect?
    //通知未读
    @objc public var userNotifUnreadImage = UIImage.imageInBundle(name: "NotifUnread_dark")
    //通知未读选中
    @objc public var userNotifUnreadSelImage = UIImage.imageInBundle(name: "NotifUnreadSel_dark")
    //通知历史
    @objc public var userNotifHistoryImage = UIImage.imageInBundle(name: "NotifHisto_dark")
    //通知历史选中
    @objc public var userNotifHistorySelImage = UIImage.imageInBundle(name: "NotifHistoSel_dark")
    //设置屏蔽
    @objc public var userSetBlockImage = UIImage.imageInBundle(name: "blocked_dark")
    //设置隐私
    @objc public var userSetPrivacyImage = UIImage.imageInBundle(name: "privacy_dark")
    //设置条款
    @objc public var userSetTermsImage = UIImage.imageInBundle(name: "terms_dark")
    //浏览次数
    @objc public var userPostViewImage = UIImage.imageInBundle(name: "common_post_view")
    
    // MARK: Add a comment
    //背景色
//    @objc public var addCommentbgColor = UIColor(red: 25/255.0, green: 31/255.0, blue: 38/255.0, alpha: 1)
    //文字框背景色
    @objc public var addCommentTextBoxbgColor = UIColor.white.withAlphaComponent(0.15)
    //选照片图标
    @objc public var addCommentPhotoImage = UIImage.imageInBundle(name: "Select_photo_video")
    //选gif图标
    @objc public var addCommentGifImage = UIImage.imageInBundle(name: "Select_GIF")
    //发送评论图标
    @objc public var addCommentSendImage = UIImage.imageInBundle(name: "send_dark")
    //发送评论图标不可用
    @objc public var addCommentSendDisImage = UIImage.imageInBundle(name: "send default_dark")
    
    // MARK: New post页
    //改变图片/视频尺寸图标
    @objc public var newPostScaleImage = UIImage.imageInBundle(name: "Resize_dark")
    //选择图片
    @objc public var newPostPhotoImage = UIImage.imageInBundle(name: "Normal_Photo_dark")
    //选择图片选中
    @objc public var newPostPhotoSelectedImage = UIImage.imageInBundle(name: "Select_Photo_dark")
    //选择视频
    @objc public var newPostVideoImage = UIImage.imageInBundle(name: "Normal_Video_dark")
    //选择视频选中
    @objc public var newPostVideoSelectedImage = UIImage.imageInBundle(name: "Select_Video_dark")
    //上下拖动条的颜色
//    @objc public var newPostSeekBarColor = UIColor.init(hex6: 0x0081D6)
    //拍照图标
    @objc public var newPostTakePhotoImage = UIImage.imageInBundle(name: "Camera_dark")
    //拍视频图标
    @objc public var newPostTakeVideoImage = UIImage.imageInBundle(name: "Video_dark")
    //产品tag图标
    @objc public var newPostTagImage = UIImage.imageInBundle(name: "Product_Tag_dark")
    //tag未选
    @objc public var tagImage = UIImage.imageInBundle(name: "")
    //tag选中
    @objc public var tagSelectedImage = UIImage.imageInBundle(name: "dark_product_selected")
    //音频有声
    @objc public var newPostSoundImage = UIImage.imageInBundle(name: "Sound_dark")
    //音频静音
    @objc public var newPostNoSoundImage = UIImage.imageInBundle(name: "Mute_dark")
    //添加tag页add
    @objc public var newPostAddImage = UIImage.imageInBundle(name: "Add_Product_dark")
    //添加tag页delet
    @objc public var newPostDelImage = UIImage.imageInBundle(name: "Del_Product_dark")
    //添加tag页move
    @objc public var newPostMoveImage = UIImage.imageInBundle(name: "Move_Product_dark")
    //选中产品页search
    @objc public var newPostSearchImage = UIImage.imageInBundle(name: "search1")
    //视频选产品页add
    @objc public var newPostVideoAddImage = UIImage.imageInBundle(name: "ic_add_dark")
    //视频选产品页cancel
    @objc public var newPostVideoCancelImage = UIImage.imageInBundle(name: "Cancel_dark")
    //拍照页拍照按钮
    @objc public var newPostTakePhotoPageTakeImage = UIImage.imageInBundle(name: "Take_Photo_press")
    //选择主题
    @objc public var newPostThemeImage = UIImage.imageInBundle(name: "theme_dark")
    //主题已下载
    @objc public var newPostThemeDownloadImage = UIImage.imageInBundle(name: "downloaded_dark")
    
    
    // MARK: Search页
    //hashtag图标
    @objc public var searchHashtagImage = UIImage.imageInBundle(name: "hashtag")
    //搜索框背景色
    @objc public var searchBoxBgColor = UIColor.white.withAlphaComponent(0.1)
    
    // MARK: IM页
    //发送气泡
    @objc public var msgSendBGImage = UIImage.imageInBundle(name: "msg_send_dark")
    //接收
    @objc public var msgRecvBGImage = UIImage.imageInBundle(name: "msg_recv_dark")
    //发送气泡背景色
    @objc public var msgSendBGColor = UIColor.init(hex6: 0x0081D6)
    @objc public var msgRecvBGColor = UIColor.init(hex6: 0x393F49)
    @objc public var msgSendTextColor = UIColor.init(hex6: 0xFFFFFF)
    @objc public var msgRecvTextColor = UIColor.init(hex6: 0xFFFFFF)
    //聊天页背景色
    @objc public var msgChatBGColor = UIColor.init(hex6: 0x1A1F25)
    //消息菜单语音
    @objc public var msgChatBarVoiceImage = UIImage.imageInBundle(name: "msg_chatBar_voice_dark")
    //消息菜单键盘
    @objc public var msgChatBarKeyboardImage = UIImage.imageInBundle(name: "msg_chatBar_keyboard_dark")
    //消息菜单更多
    @objc public var msgChatBarMoreImage = UIImage.imageInBundle(name: "msg_chatBar_more_dark")
    //消息菜单关闭更多
    @objc public var msgChatBarCancelMoreImage = UIImage.imageInBundle(name: "msg_chatBar_cancelmore_dark")
    //消息菜单gif
    @objc public var msgChatBarGifImage = UIImage.imageInBundle(name: "msg_chatBar_gif_dark")
    //消息菜单相册
    @objc public var msgChatBarAlbumImage = UIImage.imageInBundle(name: "msg_chatBar_album_dark")
    //消息菜单相机
    @objc public var msgChatBarCameraImage = UIImage.imageInBundle(name: "msg_chatBar_camera_dark")
    //消息发送失败
    @objc public var msgSendFailImage = UIImage.imageInBundle(name: "msg_sendFail_dark")
    //消息长按复制
    @objc public var msgCopyImage = UIImage.imageInBundle(name: "msg_copy")
    //消息长按删除
    @objc public var msgDeleteImage = UIImage.imageInBundle(name: "msg_delete")
    //消息长按撤回
    @objc public var msgRecallImage = UIImage.imageInBundle(name: "msg_recall")
    //消息长按转发
    @objc public var msgForwardImage = UIImage.imageInBundle(name: "msg_forward")
    //消息长按保存
    @objc public var msgSaveImage = UIImage.imageInBundle(name: "msg_save")
    //消息分享
    @objc public var msgShareImage = UIImage.imageInBundle(name: "msg_share")
    //消息发送音频
    @objc public var msgSendAudioImage = UIImage.imageInBundle(name: "msg_send_audio_dark")
    //消息发送音频
    @objc public var msgSendAudio1Image = UIImage.imageInBundle(name: "msg_send_audio1_dark")
    //消息发送音频
    @objc public var msgSendAudio2Image = UIImage.imageInBundle(name: "msg_send_audio2_dark")
    //消息接收音频
    @objc public var msgRecvAudioImage = UIImage.imageInBundle(name: "msg_recv_audio_dark")
    //消息接收音频
    @objc public var msgRecvAudio1Image = UIImage.imageInBundle(name: "msg_recv_audio1_dark")
    //消息接收音频
    @objc public var msgRecvAudio2Image = UIImage.imageInBundle(name: "msg_recv_audio2_dark")
    //消息图片破损
    @objc public var msgImgBrokenImage = UIImage.imageInBundle(name: "msg_img_broken")
    //消息视频缩略图
    @objc public var msgVideoDefaultImage = UIImage.imageInBundle(name: "video_default_thumbnail")
    //消息链接颜色
    @objc public var msgLinkColor = UIColor.init(hex6: 0x96D3FA)
    //消息语音按钮
    @objc public var msgAudioBtnImage = UIImage.imageInBundle(name: "msgAudioBtn")
    //消息输入框颜色
    @objc public var msgTextBoxColor = UIColor.white.withAlphaComponent(0.1)
    //消息语音录音
    @objc public var msgAudioSlide01WhiteImage = UIImage.imageInBundle(name: "audioSlide01-white")
    @objc public var msgAudioSlide02WhiteImage = UIImage.imageInBundle(name: "audioSlide02-white")
    @objc public var msgAudioSlide03WhiteImage = UIImage.imageInBundle(name: "audioSlide03-white")
    @objc public var msgAudioSlide01BlueImage = UIImage.imageInBundle(name: "audioSlide01-blue")
    @objc public var msgAudioSlide02BlueImage = UIImage.imageInBundle(name: "audioSlide02-blue")
    @objc public var msgAudioSlide03BlueImage = UIImage.imageInBundle(name: "audioSlide03-blue")
    //消息语音取消
    @objc public var msgRedAudioBtnImage = UIImage.imageInBundle(name: "msgRedAudioBtn")
    //消息语音录制
    @objc public var msgBlueAudioBtnImage = UIImage.imageInBundle(name: "msgBlueAudioBtn")
    //消息详情页cell
    @objc public var msgDetailCellbgColor = UIColor.init(hex6: 0x252A30)
    //消息详情页Separator
    @objc public var msgDetailSeparatorColor = UIColor.white.withAlphaComponent(0.1)
    //消息详情页SwitchOff
    @objc public var msgDetailSwitchOffColor = UIColor(red: 70/255.0, green: 73/255.0, blue: 78/255.0, alpha: 1)
    //消息详情页背景色
    @objc public var msgDetailBGColor = UIColor.init(hex6: 0x1A1F25)
    //列表免打扰
    @objc public var msgListMuteImage = UIImage.imageInBundle(name: "msg_MuteNotification_dark")
    //输入框右侧按钮
    @objc public var msgAbumImage = UIImage.imageInBundle(name: "msg_album_dark")
    
    
    
    //隐私政策网址
    @objc public var privacyPolicy = ""
    //条款网址
    @objc public var termsAndConditions = ""
    //new post share jason title
    @objc public var shareJsonTitle : String = .tc_localized_ShareTheme
    //share jason tips
    @objc public var shareJsonTips : String?
    //share jason buttontitle
//    @objc public var shareJsonBtnTitle : String = .tc_localized_GoToTheme
    //share jason callback
//    @objc public var shareJsonCallback : (()->()) = {}
    @objc public var sharePostUrl : String?
    
    override init() {
        super.init()
        changeTheme()
    }
    
    func setNavigationAttribute(navigation: UINavigationController?) {
        navigation?.navigationBar.setBackgroundImage(UIImage.image(withColor: TCUIConfig.defaultConfig.systemBackgroundColor), for: .default)
        navigation?.navigationBar.shadowImage = UIImage()
        navigation?.view.backgroundColor = TCUIConfig.defaultConfig.systemBackgroundColor
        navigation?.navigationBar.barTintColor = TCUIConfig.defaultConfig.systemBackgroundColor
        navigation?.navigationBar.titleTextAttributes =  [NSAttributedString.Key.foregroundColor:TCUIConfig.defaultConfig.systemNavigationBarTextColor]
        
        if #available(iOS 13.0, *) { //UINavigationBarAppearance属性从iOS13开始
            let navBarAppearance = UINavigationBarAppearance()
            // 背景色
            navBarAppearance.backgroundImage = UIImage.image(withColor: TCUIConfig.defaultConfig.systemBackgroundColor)
            // 去掉半透明效果
            navBarAppearance.backgroundEffect = nil
            // 去除导航栏阴影（如果不设置clear，导航栏底下会有一条阴影线）
            navBarAppearance.shadowColor = UIColor.clear
            // 字体颜色
            navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: TCUIConfig.defaultConfig.systemNavigationBarTextColor]
            navigation?.navigationBar.standardAppearance = navBarAppearance
            navigation?.navigationBar.scrollEdgeAppearance = navBarAppearance
        }
    }
    
    private func changeTheme() {
        
        switch theme {
        case .dark:
            systemTextFront = TCTextStyle.HelveticaNeue.font(.light, size: 14)
            systemTextColor = UIColor.white
            systemText2Front = TCTextStyle.HelveticaNeue.font(.light, size: 12)
            systemText3Front = TCTextStyle.HelveticaNeue.font(.light, size: 10)
            systemText2Color = UIColor.white.withAlphaComponent(0.6)
            systemText3Color = UIColor.white.withAlphaComponent(0.3)
            systemUserFront = TCTextStyle.HelveticaNeue.font(.medium, size: 14)
            systemUserColor = UIColor.white
            systemActionColor = UIColor.init(hex6: 0x0081D6)
            systemNavigationBarTextColor = UIColor.white
            systemDefaultImage = UIImage.imageInBundle(name: "loading")
            systemDefaultUserImage = UIImage.imageInBundle(name: "default_User_dark")
            systemPlaceholderUserImage = UIImage.imageInBundle(name: "placeholderimg_dark")
            backImage = UIImage.imageInBundle(name: "Back_dark")
            systemSeparatorColor = UIColor.white.withAlphaComponent(0.08)
            systemBackgroundColor = UIColor.init(hex6: 0x1A1F25)
            systemBackgroundEffectColor = UIColor.white.withAlphaComponent(0.05)
            
            productListBgColor = UIColor.init(hex6: 0x1A1F25)
            productListCellBgColor = UIColor.white.withAlphaComponent(0.1)
            productColor = UIColor.white
            productDescColor = UIColor.init(hex6: 0x76797C)
            storeButtonBarItemTitleColor = UIColor.white.withAlphaComponent(0.45)
            storeButtonBarItemSelectTitleColor = UIColor.white
            
            circleStore = UIImage.imageInBundle(name: "circle_store_dark")
            circleSearch = UIImage.imageInBundle(name: "circle_search_dark")
            circleUserCenter = UIImage.imageInBundle(name: "circle_account_dark")
            circleMessage = UIImage.imageInBundle(name: "circle_message_dark")
            
//            feedTagPointTextColor = UIColor(hex6: 0x0072BC)
            feedTagbgColor = UIColor.white.withAlphaComponent(0.05)
            feedTagbgSelectedColor = UIColor(hex6: 0x393F49)
            feedTagRightImage = UIImage.imageInBundle(name: "right_arrow_dark")
            feedFavoriteImage = UIImage.imageInBundle(name: "post_favor_dark")
            feedLikeImage = UIImage.imageInBundle(name: "post_like_dark")
            feedCommentImage = UIImage.imageInBundle(name: "post_comment_dark")
            feedShareImage = UIImage.imageInBundle(name: "share_dark")
            feedPageContrlSelectedColor = UIColor.init(hex6: 0x0081D6)
            feedPageContrlColor = UIColor.white
            feedDownloadImage = UIImage.imageInBundle(name: "download_dark")
            feedDownloadMeImage = UIImage.imageInBundle(name: "download-me_dark")
            feedShareJsonCellSelectedColor = UIColor.init(hex6: 0x12151A)
            
            feedMoreImage = UIImage.imageInBundle(name: "feed_more_dark")
            feedReplyViewBgColor = UIColor.init(hex6: 0x393F49)
//            feedLikeColor = UIColor.white
//            feedCommentNumColor = UIColor.white.withAlphaComponent(0.6)
//            feedPromptCommentColor = UIColor.white.withAlphaComponent(0.6)
//            feedPostTimeColor = UIColor.white.withAlphaComponent(0.6)
//            feedCommentTimeColor = UIColor.white.withAlphaComponent(0.6)
//            feedCommentColor = UIColor.white.withAlphaComponent(0.6)
//            feedOpenColor = UIColor.white.withAlphaComponent(0.6)
            
            userNotificationImage = UIImage.imageInBundle(name: "notification_dark")
            userEditImage = UIImage.imageInBundle(name: "edit_profile_dark")
            userFollowTextColor = UIColor.white
            userFollowImage = nil//UIImage.imageInBundle(name: "arrow_triangle")
            userFollowBorderColor = UIColor.white.withAlphaComponent(0.2)
            userUnfollowTextColor = UIColor.white
            userUnfollowbgColor = UIColor.init(hex6: 0x0081D6)
            userMoreImage = UIImage.imageInBundle(name: "user_more_dark")
            userAddPhotoImage = UIImage.imageInBundle(name: "profile_add_dark")
            userRightImage = UIImage.imageInBundle(name: "user_right_arrow_dark")
            userMyPostSelectedImage = UIImage.imageInBundle(name: "My Posts_dark")
            userMyPostImage = UIImage.imageInBundle(name: "My_Post nor_dark")
            userMyFavoriteSelectedImage = UIImage.imageInBundle(name: "post_favor_dark")
            userMyFavoriteImage = UIImage.imageInBundle(name: "My_Favor nor_dark")
            userNotifUnreadImage = UIImage.imageInBundle(name: "NotifUnread_dark")
            userNotifUnreadSelImage = UIImage.imageInBundle(name: "NotifUnreadSel_dark")
            userNotifHistoryImage = UIImage.imageInBundle(name: "NotifHisto_dark")
            userNotifHistorySelImage = UIImage.imageInBundle(name: "NotifHistoSel_dark")
            userSetBlockImage = UIImage.imageInBundle(name: "blocked_dark")
            userSetPrivacyImage = UIImage.imageInBundle(name: "privacy_dark")
            userSetTermsImage = UIImage.imageInBundle(name: "terms_dark")
            userNewPostImage = UIImage.imageInBundle(name: "newPost_dark")
            
//            addCommentbgColor = UIColor(red: 25/255.0, green: 31/255.0, blue: 38/255.0, alpha: 1)
            addCommentTextBoxbgColor = UIColor.white.withAlphaComponent(0.15)
            addCommentSendImage = UIImage.imageInBundle(name: "send_dark")
            addCommentSendDisImage = UIImage.imageInBundle(name: "send default_dark")
            
            newPostScaleImage = UIImage.imageInBundle(name: "Resize_dark")
            newPostPhotoImage = UIImage.imageInBundle(name: "Normal_Photo_dark")
            newPostPhotoSelectedImage = UIImage.imageInBundle(name: "Select_Photo_dark")
            newPostVideoImage = UIImage.imageInBundle(name: "Normal_Video_dark")
            newPostVideoSelectedImage = UIImage.imageInBundle(name: "Select_Video_dark")
            newPostTakePhotoImage = UIImage.imageInBundle(name: "Camera_dark")
            newPostTakeVideoImage = UIImage.imageInBundle(name: "Video_dark")
            newPostTagImage = UIImage.imageInBundle(name: "Product_Tag_dark")
            tagSelectedImage = UIImage.imageInBundle(name: "product_selected_dark")
            newPostSoundImage = UIImage.imageInBundle(name: "Sound_dark")
            newPostNoSoundImage = UIImage.imageInBundle(name: "Mute_dark")
            newPostAddImage = UIImage.imageInBundle(name: "Add_Product_dark")
            newPostDelImage = UIImage.imageInBundle(name: "Del_Product_dark")
            newPostMoveImage = UIImage.imageInBundle(name: "Move_Product_dark")
            newPostSearchImage = UIImage.imageInBundle(name: "search1")
            newPostVideoAddImage = UIImage.imageInBundle(name: "ic_add_dark")
            newPostVideoCancelImage = UIImage.imageInBundle(name: "Cancel_dark")
            newPostTakePhotoPageTakeImage = UIImage.imageInBundle(name: "Take_Photo_press")
            newPostThemeImage = UIImage.imageInBundle(name: "theme_dark")
            newPostThemeDownloadImage = UIImage.imageInBundle(name: "downloaded_dark")
            
            searchBoxBgColor = UIColor.white.withAlphaComponent(0.1)
            
            msgSendBGColor = UIColor.init(hex6: 0x0081D6)
            msgRecvBGColor = UIColor.init(hex6: 0x393F49)
            msgSendTextColor = UIColor.init(hex6: 0xFFFFFF)
            msgRecvTextColor = UIColor.init(hex6: 0xFFFFFF)
            msgChatBGColor = UIColor.init(hex6: 0x1A1F25)
            msgTextBoxColor = UIColor.white.withAlphaComponent(0.1)
            msgChatBarVoiceImage = UIImage.imageInBundle(name: "msg_chatBar_voice_dark")
            msgChatBarKeyboardImage = UIImage.imageInBundle(name: "msg_chatBar_keyboard_dark")
            msgRecvAudioImage = UIImage.imageInBundle(name: "msg_recv_audio_dark")
            msgRecvAudio1Image = UIImage.imageInBundle(name: "msg_recv_audio1_dark")
            msgRecvAudio2Image = UIImage.imageInBundle(name: "msg_recv_audio2_dark")
            msgDetailCellbgColor = UIColor.init(hex6: 0x252A30)
            msgDetailSeparatorColor = UIColor.white.withAlphaComponent(0.1)
            msgDetailSwitchOffColor = UIColor(red: 70/255.0, green: 73/255.0, blue: 78/255.0, alpha: 1)
            msgDetailBGColor = UIColor.init(hex6: 0x1A1F25)
            msgListMuteImage = UIImage.imageInBundle(name: "msg_MuteNotification_dark")
            msgAbumImage = UIImage.imageInBundle(name: "msg_album_dark")
            
        default:
            systemTextFront = TCTextStyle.HelveticaNeue.font(.regular, size: 14)
            systemTextColor = UIColor.init(hex6: 0x000102)
            systemText2Front = TCTextStyle.HelveticaNeue.font(.regular, size: 12)
            systemText3Front = TCTextStyle.HelveticaNeue.font(.regular, size: 10)
            systemText2Color = UIColor.init(hex6: 0x868788)
            systemText3Color = UIColor.init(hex6: 0x000102).withAlphaComponent(0.3)
            systemUserFront = TCTextStyle.HelveticaNeue.font(.medium, size: 14)
            systemUserColor = .black
            systemActionColor = UIColor.init(hex6: 0x1B99F5)
            systemNavigationBarTextColor = .black
            systemDefaultImage = UIImage.imageInBundle(name: "loading")?.image(withTintColor: .init(hex6: 0x666666))
            systemDefaultUserImage = UIImage.imageInBundle(name: "default_User_light")
            systemPlaceholderUserImage = UIImage.imageInBundle(name: "placeholderimg_light")
            backImage = UIImage.imageInBundle(name: "Back_light")
            systemSeparatorColor = UIColor.init(hex6: 0xF2F2F2)
            systemBackgroundColor = UIColor.white
            systemBackgroundEffectColor = UIColor.init(hex6: 0xF6F8FA)
            productListBgColor = UIColor.init(hex6: 0xF0F0F0)
            productListCellBgColor = UIColor.white
            productColor = UIColor.init(hex6: 0x000102)
            productDescColor = UIColor.init(hex6: 0x868788)
            storeButtonBarItemTitleColor = UIColor.init(hex6: 0x000102).withAlphaComponent(0.45)
            storeButtonBarItemSelectTitleColor = UIColor.init(hex6: 0x000102)
            
            circleStore = UIImage.imageInBundle(name: "circle_store_light")
            circleSearch = UIImage.imageInBundle(name: "circle_search_light")
            circleUserCenter = UIImage.imageInBundle(name: "circle_account_light")
            circleMessage = UIImage.imageInBundle(name: "circle_message_light")
            
//            feedTagPointTextColor = UIColor.init(hex6: 0x000102)
            feedTagbgColor = UIColor.init(hex6: 0xF4F6F8)
            feedTagbgSelectedColor = UIColor.init(hex6: 0xdddddd)
            feedTagRightImage = UIImage.imageInBundle(name: "right_arrow_light")
            feedFavoriteImage = UIImage.imageInBundle(name: "post_favor_light")
            feedLikeImage = UIImage.imageInBundle(name: "post_like_light")
            feedCommentImage = UIImage.imageInBundle(name: "post_comment_light")
            feedShareImage = UIImage.imageInBundle(name: "share_light")
            feedPageContrlSelectedColor = UIColor.init(hex6: 0x1B99F5)
            feedPageContrlColor = .init(hex6: 0xdddddd)
            feedDownloadImage = UIImage.imageInBundle(name: "download_light")
            feedDownloadMeImage = UIImage.imageInBundle(name: "download-me_light")
            feedShareJsonCellSelectedColor = UIColor.init(hex6: 0xEEEFF0)
            
            feedMoreImage = UIImage.imageInBundle(name: "feed_more_light")
            feedReplyViewBgColor = UIColor.init(hex6: 0xE6E6E6)
//            feedLikeColor = UIColor.init(hex6: 0x000102)
//            feedCommentNumColor = UIColor.init(hex6: 0x868788)
//            feedPromptCommentColor = UIColor.init(hex6: 0x868788)
//            feedPostTimeColor = UIColor.init(hex6: 0x868788)
//            feedCommentTimeColor = UIColor.init(hex6: 0x868788)
//            feedCommentColor = UIColor.init(hex6: 0x868788)
//            feedOpenColor = UIColor.init(hex6: 0x868788)
            
            userNotificationImage = UIImage.imageInBundle(name: "notification_light")
            userEditImage = UIImage.imageInBundle(name: "edit_profile_light")
            userFollowImage = nil//UIImage.imageInBundle(name: "arrow_triangle")?.image(withTintColor: UIColor.init(hex6: 0x000102))
            userFollowBorderColor = UIColor.init(hex6: 0xDDDDDD)
            userFollowTextColor = UIColor.init(hex6: 0x000102)
            userUnfollowTextColor = UIColor.white
            userUnfollowbgColor = UIColor.init(hex6: 0x1B99F5)
            userMoreImage = UIImage.imageInBundle(name: "user_more_light")
            userAddPhotoImage = UIImage.imageInBundle(name: "profile_add_light")
            userRightImage = UIImage.imageInBundle(name: "user_right_arrow_light")
            userMyPostSelectedImage = UIImage.imageInBundle(name: "My Posts_light")
            userMyPostImage = UIImage.imageInBundle(name: "My_Post nor_light")
            userMyFavoriteSelectedImage = UIImage.imageInBundle(name: "post_favor_light")
            userMyFavoriteImage = UIImage.imageInBundle(name: "My_Favor nor_light")
            userNotifUnreadImage = UIImage.imageInBundle(name: "NotifUnread_light")
            userNotifUnreadSelImage = UIImage.imageInBundle(name: "NotifUnreadSel_light")
            userNotifHistoryImage = UIImage.imageInBundle(name: "NotifHisto_light")
            userNotifHistorySelImage = UIImage.imageInBundle(name: "NotifHistoSel_light")
            userSetBlockImage = UIImage.imageInBundle(name: "blocked_light")
            userSetPrivacyImage = UIImage.imageInBundle(name: "privacy_light")
            userSetTermsImage = UIImage.imageInBundle(name: "terms_light")
            userNewPostImage = UIImage.imageInBundle(name: "newPost_light")
            
//            addCommentbgColor = UIColor.white
            addCommentTextBoxbgColor = UIColor.init(hex6: 0xeff1f4)
            addCommentSendImage = UIImage.imageInBundle(name: "send_light")
            addCommentSendDisImage = UIImage.imageInBundle(name: "send default_light")
            
            newPostScaleImage = UIImage.imageInBundle(name: "Resize_light")
            newPostPhotoImage = UIImage.imageInBundle(name: "Normal_Photo_light")
            newPostPhotoSelectedImage = UIImage.imageInBundle(name: "Select_Photo_light")
            newPostVideoImage = UIImage.imageInBundle(name: "Normal_Video_light")
            newPostVideoSelectedImage = UIImage.imageInBundle(name: "Select_Video_light")
            newPostTakePhotoImage = UIImage.imageInBundle(name: "Camera_light")
            newPostTakeVideoImage = UIImage.imageInBundle(name: "Video_light")
            newPostTagImage = UIImage.imageInBundle(name: "Product_Tag_light")
            tagSelectedImage = UIImage.imageInBundle(name: "product_selected_light")
            newPostSoundImage = UIImage.imageInBundle(name: "Sound_light")
            newPostNoSoundImage = UIImage.imageInBundle(name: "Mute_light")
            newPostAddImage = UIImage.imageInBundle(name: "Add_Product_light")
            newPostDelImage = UIImage.imageInBundle(name: "Del_Product_light")
            newPostMoveImage = UIImage.imageInBundle(name: "Move_Product_light")
            newPostSearchImage = UIImage.imageInBundle(name: "search1")//?.image(withTintColor: UIColor.init(hex6: 0x000102))
            newPostVideoAddImage = UIImage.imageInBundle(name: "ic_add_light")
            newPostVideoCancelImage = UIImage.imageInBundle(name: "Cancel_light")
            newPostTakePhotoPageTakeImage = UIImage.imageInBundle(name: "Take_Photo_press")
            newPostThemeImage = UIImage.imageInBundle(name: "theme_light")
            newPostThemeDownloadImage = UIImage.imageInBundle(name: "downloaded_light")
            
            searchBoxBgColor = UIColor.init(hex6: 0xF2F2F2)
            
            msgSendBGColor = UIColor.init(hex6: 0x1B99F5)
            msgRecvBGColor = UIColor.init(hex6: 0xFFFFFF)
            msgSendTextColor = UIColor.init(hex6: 0xFFFFFF)
            msgRecvTextColor = UIColor.init(hex6: 0x000102)
            msgChatBGColor = UIColor.init(hex6: 0xF2F2F2)
            msgTextBoxColor = UIColor.white
            msgChatBarVoiceImage = UIImage.imageInBundle(name: "msg_chatBar_voice_light")
            msgChatBarKeyboardImage = UIImage.imageInBundle(name: "msg_chatBar_keyboard_light")
            msgRecvAudioImage = UIImage.imageInBundle(name: "msg_recv_audio_light")
            msgRecvAudio1Image = UIImage.imageInBundle(name: "msg_recv_audio1_light")
            msgRecvAudio2Image = UIImage.imageInBundle(name: "msg_recv_audio2_light")
            msgDetailCellbgColor = UIColor.init(hex6: 0xFFFFFF)
            msgDetailSeparatorColor = UIColor.init(hex6: 0xF2F2F2)
            msgDetailSwitchOffColor = UIColor(red: 221/255.0, green: 221/255.0, blue: 221/255.0, alpha: 1)
            msgDetailBGColor = UIColor.init(hex6: 0xF2F2F2)
            msgListMuteImage = UIImage.imageInBundle(name: "msg_MuteNotification_light")
            msgAbumImage = UIImage.imageInBundle(name: "msg_album_light")
            
            break
        }
    }
}

extension String {
    var tc_localized : String { return TCLocalizableManager.getValueFor(key: self) }
    
    static var tc_localized_buyNow : String { return "Buy Now".tc_localized }
    static var tc_localized_store : String { return "Store".tc_localized }
    static var tc_localized_install : String { return "Install:".tc_localized }
    static var tc_localized_editProfile : String { return "Edit Profile".tc_localized }
    static var tc_localized_Cancel : String { return "Cancel".tc_localized }
    static var tc_localized_YES : String { return "Yes".tc_localized }
    static var tc_localized_BlockUser : String { return "Block User".tc_localized }
    static var tc_localized_blockPrompt : String { return "blockPrompt".tc_localized }
    static var tc_localized_UnblockUser : String { return "Unblock User".tc_localized }
    static var tc_localized_Unblock : String { return "Unblock".tc_localized }
    static var tc_localized_unblockPrompt : String { return "unblockPrompt".tc_localized }
    static var tc_localized_REGULAR : String { return "REGULAR".tc_localized }
    static var tc_localized_CONTEST : String { return "CONTEST".tc_localized }
    static var tc_localized_Share : String { return "Share".tc_localized }
    static var tc_localized_Submit : String { return "Submit".tc_localized }
    static var tc_localized_Email : String { return "Email".tc_localized }
    static var tc_localized_Item : String { return "Item".tc_localized }
    static var tc_localized_Items : String { return "Items".tc_localized }
    static var tc_localized_Enteryour : String { return "Enteryour".tc_localized }
    static var tc_localized_info : String { return "info".tc_localized }
    static var tc_localized_usernameAlready : String { return "usernameAlready".tc_localized }
    static var tc_localized_Posts : String { return "Posts".tc_localized }
    static var tc_localized_Followers : String { return "Followers".tc_localized }
    static var tc_localized_Following : String { return "Following".tc_localized }
    static var tc_localized_Notification : String { return "Notification".tc_localized }
    static var tc_localized_Follow : String { return "Follow".tc_localized }
    static var tc_localized_Followed : String { return "Followed".tc_localized }
    static var tc_localized_Followback : String { return "Follow back".tc_localized }
    static var tc_localized_SharePhotosandVideos : String { return "Share Photos and Videos".tc_localized }
    static var tc_localized_SharePrompt : String { return "SharePrompt".tc_localized }
    static var tc_localized_Shareyourfirstphotoorvideo : String { return "Share your first photo or video".tc_localized }
    static var tc_localized_Username : String { return "Username".tc_localized }
    static var tc_localized_Bio : String { return "Bio".tc_localized }
    static var tc_localized_ChangeProfilePhoto : String { return "Change Profile Photo".tc_localized }
    static var tc_localized_Done : String { return "Done".tc_localized }
    static var tc_localized_Next : String { return "Next".tc_localized }
    static var tc_localized_RecentlyDeleted : String { return "Recently Deleted".tc_localized }
    static var tc_localized_Recents : String { return "Recents".tc_localized }
    static var tc_localized_CameraRoll : String { return "Camera Roll".tc_localized }
    static var tc_localized_WriteSomething : String { return "Write something about it".tc_localized }
    static var tc_localized_TagProduct : String { return "Tag Product".tc_localized }
    static var tc_localized_SwipeMore : String { return "Swipe to see more".tc_localized }
    static var tc_localized_TapAdd : String { return "Tap to Add".tc_localized }
    static var tc_localized_TapRemove : String { return "Tap again to remove".tc_localized }
    static var tc_localized_DragMove : String { return "Drag to move".tc_localized }
    static var tc_localized_AddTag : String { return "Add Product Tag".tc_localized }
    static var tc_localized_TypeNameNumber : String { return "Type name or item number".tc_localized }
    static var tc_localized_SelectProduct : String { return "Select Product".tc_localized }
    static var tc_localized_Processing : String { return "Processing...".tc_localized }
    static var tc_localized_Processing1 : String { return "Processing".tc_localized }
    static var tc_localized_FOLLOWERS : String { return "FOLLOWERS".tc_localized }
    static var tc_localized_FOLLOWING : String { return "FOLLOWING".tc_localized }
    static var tc_localized_AddComment : String { return "Add a comment...".tc_localized }
    static var tc_localized_ReplyingTo : String { return "Replying to".tc_localized }
    static var tc_localized_DeletePost : String { return "Delete Post".tc_localized }
    static var tc_localized_ViewAll : String { return "View All".tc_localized }
    static var tc_localized_Comment : String { return "Comment".tc_localized }
    static var tc_localized_Comments : String { return "Comments".tc_localized }
    static var tc_localized_CommentsText : String { return "CommentsText".tc_localized }
    static var tc_localized_OpenMoreReplies : String { return "Open more replies".tc_localized }
    static var tc_localized_Open : String { return "Open".tc_localized }
    static var tc_localized_ReplyText : String { return "ReplyText".tc_localized }
    static var tc_localized_Reply : String { return "Reply".tc_localized }
    static var tc_localized_Replies : String { return "Replies".tc_localized }
    static var tc_localized_reply : String { return "reply".tc_localized }
    static var tc_localized_replies : String { return "replies".tc_localized }
    static var tc_localized_like : String { return "like".tc_localized }
    static var tc_localized_likes : String { return "likes".tc_localized }
    static var tc_localized_Likes : String { return "Likes".tc_localized }
    static var tc_localized_DeleteAllCommentPrompt : String { return "Delete this comment and its sub-comments?".tc_localized }
    static var tc_localized_DeleteCommentPrompt : String { return "Delete selected comment?".tc_localized }
    static var tc_localized_hide : String { return "hide".tc_localized }
    static var tc_localized_hidden : String { return "hidden".tc_localized }
    static var tc_localized_SupCommentPrompt : String { return "Do you want to hide this comment with all subcomments?".tc_localized }
    static var tc_localized_AreYouSure : String { return "Are you sure?".tc_localized }
    static var tc_localized_DoYouWantTo : String { return "Do you want to".tc_localized }
    static var tc_localized_thisComment : String { return "this comment?".tc_localized }
    static var tc_localized_thisReply : String { return "this reply?".tc_localized }
    static var tc_localized_UploadTimeout : String { return "Upload timeout. Please try again. ".tc_localized }
    static var tc_localized_ReportContent : String { return "Report Inappropriate Content".tc_localized }
    static var tc_localized_Report : String { return "Report".tc_localized }
    static var tc_localized_ReportUser : String { return "Report User".tc_localized }
    static var tc_localized_WhyReport : String { return "Why are you reporting this post".tc_localized }
    static var tc_localized_Thankyou : String { return "Thank you!".tc_localized }
    static var tc_localized_OK : String { return "OK".tc_localized }
    static var tc_localized_ReportPrompt : String { return "Your report has been submitted and someone from our team will look at it soon!".tc_localized }
    static var tc_localized_Unfollow : String { return "Unfollow".tc_localized }
    static var tc_localized_NoSoundPrompt : String { return "This video has no sound".tc_localized }
    static var tc_localized_SignOut : String { return "Sign Out".tc_localized }
    static var tc_localized_Searchhashtag : String { return "Search hashtag".tc_localized }
    static var tc_localized_Searchaccount : String { return "Search account".tc_localized }
    static var tc_localized_Top : String { return "Top".tc_localized }
    static var tc_localized_Tags : String { return "Tags".tc_localized }
    static var tc_localized_Accounts : String { return "Accounts".tc_localized }
    static var tc_localized_Suggested : String { return "Suggested".tc_localized }
    static var tc_localized_Hashtags : String { return "Hashtags".tc_localized }
    static var tc_localized_posts : String { return "posts".tc_localized }
    static var tc_localized_post : String { return "post".tc_localized }
    static var tc_localized_followers : String { return "followers".tc_localized }
    static var tc_localized_follower : String { return "follower".tc_localized }
    static var tc_localized_ReplyingtoSomeone : String { return "Replying to Someone...".tc_localized }
    static var tc_localized_likedyourpost : String { return "liked your post".tc_localized }
    static var tc_localized_startedfollowingyou : String { return "started following you".tc_localized }
    static var tc_localized_likedyourcomment : String { return "liked your comment:".tc_localized }
    static var tc_localized_repliedtoyou : String { return "replied to you:".tc_localized }
    static var tc_localized_commentedonyourpost : String { return "commented on your post:".tc_localized }
    static var tc_localized_Yourposthasbeenfeatured : String { return "Your post has been featured".tc_localized }
    static var tc_localized_mentionedyouinacomment : String { return "mentioned you in a comment".tc_localized }
    static var tc_localized_mentionedyouinapost : String { return "mentioned you in a post".tc_localized }
    static var tc_localized_and : String { return "and".tc_localized }
    static var tc_localized_other : String { return "other".tc_localized }
    static var tc_localized_others : String { return "others".tc_localized }
    static var tc_localized_Likedby : String { return "Liked by".tc_localized }
    static var tc_localized_CustomerPosts : String { return "Customer Posts".tc_localized }
    static var tc_localized_Pickavideolessthan : String { return "Pick a video less than".tc_localized }
    static var tc_localized_seconds : String { return "seconds.".tc_localized }
    static var tc_localized_Thevideomustbeatleast : String { return "The video must be at least".tc_localized }
    static var tc_localized_ViewPost : String { return "View Post".tc_localized }
    static var tc_localized_Close : String { return "Close".tc_localized }
    static var tc_localized_ShowAll : String { return "ShowAll".tc_localized }
    static var tc_localized_ProductHasTagged : String { return "The product has been tagged.".tc_localized }
    static var tc_localized_NoMoreProductsTagged : String { return "No more than 9 products can be tagged".tc_localized }
    static var tc_localized_Minutes : String { return "minutes.".tc_localized }
    static var tc_localized_SavedPersonalCollection : String { return "Saved to personal Collection".tc_localized }
    static var tc_localized_PointMore : String { return "...  more".tc_localized }
    static var tc_localized_HidePost : String { return "Hide Post".tc_localized }
    static var tc_localized_Delete : String { return "Delete".tc_localized }
    static var tc_localized_NoResultsFound : String { return "No Results Found for".tc_localized }
    static var tc_localized_Search : String { return "Search".tc_localized }
    static var tc_localized_Settings : String { return "Settings".tc_localized }
    static var tc_localized_ManageBlockedAccounts : String { return "Manage Blocked Accounts".tc_localized }
    static var tc_localized_PrivacyPolicy : String { return "Privacy Policy".tc_localized }
    static var tc_localized_TermsAndConditions : String { return "Terms and Conditions".tc_localized }
    static var tc_localized_BlockedAccounts : String { return "Blocked Accounts".tc_localized }
    static var tc_localized_hidePrompt : String { return "hidePrompt".tc_localized }
    static var tc_localized_enterReason : String { return "Please enter your reason".tc_localized }
    static var tc_localized_SignOutPrompt : String { return "Do you want to sign out?".tc_localized }
    static var tc_localized_ReportedPrompt : String { return "You have reported this post".tc_localized }
    static var tc_localized_Details : String { return "Details".tc_localized }
    static var tc_localized_Detail : String { return "Detail".tc_localized }
    static var tc_localized_ReportSubmitted : String { return "Report Submitted".tc_localized }
    static var tc_localized_SelectTheme : String { return "Select Theme".tc_localized }
    static var tc_localized_For : String { return "For".tc_localized }
    static var tc_localized_ThemeDownloaded : String { return "ThemeDownloaded".tc_localized }
    static var tc_localized_GoToTheme : String { return "Go To Theme".tc_localized }
    static var tc_localized_DownloadedNot : String { return "just downloaded your theme".tc_localized }
    static var tc_localized_ShareTheme : String { return "Share Theme".tc_localized }
    static var tc_localized_LinkCopied : String { return "Link copied to clipboard".tc_localized }
    static var tc_localized_view : String { return "view".tc_localized }
    static var tc_localized_views : String { return "views".tc_localized }
    static var tc_localized_OfficialStaff : String { return "Official Staff".tc_localized }
    static var tc_localized_Message : String { return "Message".tc_localized }
    static var tc_localized_SendMessage : String { return "Send Message".tc_localized }
    static var tc_localized_NoChatInformation : String { return "No chat information".tc_localized }
    static var tc_localized_AreYouSureToDelete : String { return "Are you sure to delete?".tc_localized }
    static var tc_localized_StickOnTop : String { return "Stick on Top".tc_localized }
    static var tc_localized_CancelOnTop : String { return "Cancel on Top".tc_localized }
    static var tc_localized_MarkAsRead : String { return "Mark as Read".tc_localized }
    static var tc_localized_MarkAsUnread : String { return "Mark as Unread".tc_localized }
    static var tc_localized_Typing : String { return "Typing...".tc_localized }
    static var tc_localized_Album : String { return "Album".tc_localized }
    static var tc_localized_Camera : String { return "Camera".tc_localized }
    static var tc_localized_SendAMessage : String { return "Send a message...".tc_localized }
    static var tc_localized_Read : String { return "Read".tc_localized }
    static var tc_localized_Picture : String { return "Picture".tc_localized }
    static var tc_localized_Video : String { return "Video".tc_localized }
    static var tc_localized_SomeoneMe : String { return "Someone @ me".tc_localized }
    static var tc_localized_YouRetractMessage : String { return "You retract a message".tc_localized }
    static var tc_localized_TheOtherPartyWithdrawsMessage : String { return "The other party withdraws a message".tc_localized }
    static var tc_localized_Copy : String { return "Copy".tc_localized }
    static var tc_localized_Withdraw : String { return "Withdraw".tc_localized }
    static var tc_localized_Forward : String { return "Forward".tc_localized }
    static var tc_localized_SelectLinkOpen : String { return "Please select the link to open".tc_localized }
    static var tc_localized_GetThumbnails : String { return "Get thumbnails...".tc_localized }
    static var tc_localized_DownloadOriginal : String { return "Download original...".tc_localized }
    static var tc_localized_FailedDownloadOriginal : String { return "Failed to download original image".tc_localized }
    static var tc_localized_FailedGetOriginal : String { return "Failed to get original image".tc_localized }
    static var tc_localized_DownloadingVoiceLater : String { return "Downloading voice, click later".tc_localized }
    static var tc_localized_DownloadVoice : String { return "Download voice...".tc_localized }
    static var tc_localized_FailedDownloadVoice : String { return "Failed to download voice".tc_localized }
    static var tc_localized_DownloadVideo : String { return "Download video...".tc_localized }
    static var tc_localized_FailedDownloadVideo : String { return "Failed to download video".tc_localized }
    static var tc_localized_DownloadingVideoLater : String { return "Downloading video, click later".tc_localized }
    static var tc_localized_DownloadThumbnails : String { return "Download thumbnails".tc_localized }
    static var tc_localized_HoldToTalk : String { return "Press and hold to talk".tc_localized }
    static var tc_localized_ReleaseSend : String { return "Release to send".tc_localized }
    static var tc_localized_ReleaseCancel : String { return "Release to cancel".tc_localized }
    static var tc_localized_PictureTooBig : String { return "The picture is too big".tc_localized }
    static var tc_localized_VideoTooLarge : String { return "The video is too large".tc_localized }
    static var tc_localized_SpeakingTimeTooShort : String { return "Speaking time is too short".tc_localized }
    static var tc_localized_RelayMessage : String { return "Relay message".tc_localized }
    static var tc_localized_ClearChatPrompt : String { return "Do you want to clear chat history?".tc_localized }
    static var tc_localized_Clear : String { return "Clear".tc_localized }
    static var tc_localized_ChatHistoryCleared : String { return "Chat history cleared".tc_localized }
    static var tc_localized_FailedClearChatRecord : String { return "Failed to clear chat record".tc_localized }
    static var tc_localized_FailedSetNoDisturb : String { return "Failed to set no disturb".tc_localized }
    static var tc_localized_SearchChatHistory : String { return "Search Chat History".tc_localized }
    static var tc_localized_BrowseChatMedia : String { return "Browse Chat Media".tc_localized }
    static var tc_localized_MuteNotification : String { return "Mute Notification".tc_localized }
    static var tc_localized_StickyOnTop : String { return "Sticky on Top".tc_localized }
    static var tc_localized_ClearChatHistory : String { return "Clear Chat History".tc_localized }
    static var tc_localized_Media : String { return "Media".tc_localized }
    static var tc_localized_No : String { return "No".tc_localized }
    static var tc_localized_Chathistoryfound : String { return "chat history found".tc_localized }
    static var tc_localized_Voice : String { return "Voice".tc_localized }
    static var tc_localized_NoResult : String { return "No Result".tc_localized }
    static var tc_localized_Send : String { return "Send".tc_localized }
    static var tc_localized_Retake : String { return "Retake".tc_localized }
    static var tc_localized_Yesterday : String { return "Yesterday".tc_localized }
    static var tc_localized_AccountCancellation : String { return "Account Cancellation".tc_localized }
    static var tc_localized_Continue : String { return "Continue".tc_localized }
    static var tc_localized_DeleteAccountPrompt : String { return "DeleteAccountPrompt".tc_localized }
    static var tc_localized_MsgHasBlockdPrompt : String { return "Coversation has been blocked".tc_localized }
    static var tc_localized_BANALLACTIVITIESPrompt : String { return "Due to violation of community policies, you have been banned from this activity.".tc_localized }
    static var tc_localized_Save : String { return "Save".tc_localized }
    
}

struct TCTextStyle {
    
    enum Helvetica: String {
        case light = "Helvetica-Light"
        case regular = "Helvetica"
        case bold = "Helvetica-Bold"
        
        static let bold14 = font(.bold, size: 14.0)
        static let light14 = font(.light, size: 14.0)
        
        static func font(_ font: Helvetica = .regular, size: CGFloat = 13.0) -> UIFont {
            return UIFont(name: font.rawValue, size: size)! //?? UIFont.systemFont(ofSize: size)
        }
    }
    
     enum HelveticaNeue: String {
        case light = "HelveticaNeue-Light"
        case regular = "HelveticaNeue"
        case medium = "HelveticaNeue-Medium"
        case bold = "HelveticaNeue-Bold"
        
        static let light13 = font(.light)
        static let medium13 = font(.medium)
        static let bold14 = font(.bold, size: 14.0)
        static let light14 = font(.light, size: 14.0)
        
        static func font(_ font: HelveticaNeue = .regular, size: CGFloat = 13.0) -> UIFont {
            return UIFont(name: font.rawValue, size: size)! //?? UIFont.systemFont(ofSize: size)
        }
    }
}

