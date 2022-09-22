//
//  TCCircleVCtrl.swift
//  TeamCircleSDK
//
//  Created by JasonTang on 2021/5/19.
//

import UIKit

@objc open class TCCircleNavController: UINavigationController {
    
    public var circleVCtrl : TCCircleVCtrl?
    
    class func initCircleVCtrlNav() -> TCCircleNavController {
        let circle = TCCircleVCtrl()
        let nav = TCCircleNavController(rootViewController: circle)
        nav.circleVCtrl = circle
        return nav
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
}

@objc open class TCCircleVCtrl: TCBaseVCtrl {
    
//    var feedView : TCFeedView?
    var feedVC : TCFeedsVCtrl?
    var storeBtn : TCStoreBtn?
    var centerBtn : TCMeBtn?
    var imBtn : TCIMBtn?
    var storeItem : UIButton?
    var storeHeight : CGFloat?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        if TCManager.sharedInstance.tallVersion {
            storeItem = UIButton.init(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            storeItem?.setImage(TCUIConfig.defaultConfig.circleStore, for: .normal)
            storeItem?.alpha = 0
            storeItem?.isEnabled = false
            storeItem?.addTarget(self, action: #selector(toStoreAction), for: .touchUpInside)
        }
        
//        TCManager.sharedInstance.initSearchBtn(frame: CGRect(x: 0, y: 0, width: 40, height: 40), image: TCUIConfig.defaultConfig.circleSearch, title: "") { [weak self] (btn, error) in
//            if let me = btn {
//                me.navCtrl = self?.navigationController
//                me.imgView.snp.remakeConstraints { (make) in
//                    make.center.equalTo(me)
//                    make.width.height.equalTo(20)
//                }
//                self?.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: me)
//            } else {
//                tcDebugPrint(error ?? "")
//            }
//        }
        if TCManager.sharedInstance.imStatus {
            TCManager.sharedInstance.initIMBtn(frame: CGRect(x: 0, y: 0, width: 30, height: 30), image: TCUIConfig.defaultConfig.circleMessage, title: "") { [weak self] (btn, error) in
                if let im = btn {
                    self?.imBtn = im
                    im.navCtrl = self?.navigationController
                    im.imgView.snp.remakeConstraints { (make) in
                        make.center.equalTo(im)
                        make.width.height.equalTo(24)
                    }
                    im.messageCount.snp.remakeConstraints { (make) in
                        make.top.equalTo(0)
                        make.right.equalTo(3)
                        make.height.equalTo(16)
                        make.width.greaterThanOrEqualTo(16)
                    }
                    if (self?.storeItem) != nil {
                        self?.navigationItem.rightBarButtonItems = [UIBarButtonItem.init(customView: im), UIBarButtonItem.init(customView: self!.storeItem!)]
                    } else {
                        self?.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: im)
                    }
                } else {
                    debugPrint(error ?? "")
                }
            }
        } else {
            if (self.storeItem) != nil {
                self.navigationItem.rightBarButtonItems = [ UIBarButtonItem.init(customView: self.storeItem!)]
            }
        }
        
        TCManager.sharedInstance.initUserCenterBtn(frame: CGRect(x: 0, y: 0, width: 30, height: 30), image: TCUIConfig.defaultConfig.circleUserCenter, title: "") { [weak self] (btn, error) in
            if let me = btn {
                me.navCtrl = self?.navigationController
                me.imgView.snp.remakeConstraints { (make) in
                    make.center.equalTo(me)
                    make.width.height.equalTo(24)
                }
                me.messageCount.snp.remakeConstraints { (make) in
                    make.top.equalTo(0)
                    make.right.equalTo(3)
                    make.height.equalTo(16)
                    make.width.greaterThanOrEqualTo(16)
                }
                self?.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: me)
                
            } else {
                tcDebugPrint(error ?? "")
            }
        }
        
        TCManager.sharedInstance.initFeedController(nav: navigationController!) { [weak self] feedVC, error in
            if let feed = feedVC {
                self?.feedVC = feed
                feed.delegate = self
                feed.setShowStore(show: true)
                self?.addChild(feed)
                self?.view.addSubview(feed.view)
                feed.view.snp.remakeConstraints { make in
                    make.edges.equalToSuperview()
                }
            } else {
                tcDebugPrint(error ?? "")
            }
        }
        
//        TCManager.sharedInstance.initFeedsView(frame: CGRect(x: 0, y: NavHeight(), width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - NavHeight() - TabHeight()), nav: navigationController!) { [weak self] (view, error) in
//            if let feed = view {
//                self?.feedView = feed
////                feed.delegate = self
//                self?.view.addSubview(feed)
//                self?.setStoreView()
//            } else {
//                debugPrint(error ?? "")
//            }
//        }
    }
    
    @objc func toStoreAction() {
        TCManager.sharedInstance.toStoreVCtrl(nav: self.navigationController!) { _, _ in
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TCCircleVCtrl : TCFeedViewDelegate {
    public func storeHeightDidChange(height: CGFloat?) {
        storeHeight = height
    }
    
    public func didTapFavtor(imageURL: URL) {
        let height: CGFloat = 0
        let image = UIImageView.init(frame: CGRect(x: view.frame.width - 16 - 24, y: 16 + 24 + height, width: 0, height: 0))
        image.sd_setImage(with: imageURL)
        feedVC?.view.addSubview(image)
        UIView.animate(withDuration: 0.2) {
            image.frame = CGRect(x: self.view.frame.width - 14 - 52, y: 14 + height, width: 52, height: 52)
        } completion: { finish in
            UIView.animate(withDuration: 0.1) {
                image.frame = CGRect(x: self.view.frame.width - 16 - 48, y: 16 + height, width: 48, height: 48)
            } completion: { finish in
                delay(time: 1) {
                    UIView.animate(withDuration: 0.2) {
                        image.frame = CGRect(x: self.view.frame.width - 16 - 10 - 18, y: -28 + height, width: 28, height: 28)
                    } completion: { finish in
                        image.removeFromSuperview()
                        if let center = self.centerBtn {
                            UIView.animate(withDuration: 0.1) {
                                center.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
                            } completion: { finish in
                                UIView.animate(withDuration: 0.1) {
                                    center.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                                }
                            }

                        }
                    }
                }
            }
        }
    }
    
    public func collectionViewDidScroll(collection: UICollectionView) {
        if let store = storeHeight {
            let height = store / 2 + 48
            let offset = collection.contentOffset.y
            storeItem?.isEnabled = offset > height
            var alpha = (offset - height) / 10
            if alpha < 0 {
                alpha = 0
            } else if alpha > 1 {
                alpha = 1
            }
            storeItem?.alpha = alpha
        }
    }
}
