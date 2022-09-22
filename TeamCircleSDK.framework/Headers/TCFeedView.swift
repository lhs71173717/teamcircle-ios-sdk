//
//  TCFeedView.swift
//  TeamCircleSDK
//
//  Created by JasonTang on 2021/3/29.
//

import UIKit

public protocol TCFeedViewDelegate: AnyObject {
    func collectionViewDidScroll(collection: UICollectionView)
    func didTapFavtor(imageURL : URL)
    func storeHeightDidChange(height: CGFloat?)
}

public class TCFeedView: UIView {

    @IBOutlet public weak var collectionView : UICollectionView?
    @IBOutlet public weak var pickerButton : UIButton?
    
    private var canSave = true
    
    public override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        viewMove(toWindow: newWindow)
    }
    
    func viewMove(toWindow newWindow: UIWindow?) {
        if let controller = self.next as? TCFeedsVCtrl {
            switch controller.pageType {
            case .allPosts:
                if canSave {
                    if newWindow != nil {
                        TCDataPointsModel.nowPage = "FEED"
                        TCDataPointsModel.enterSave()
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "feedViewMove"), object: true)
                    } else {
                        canSave = false
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "feedViewMove"), object: false)
                        TCDataPointsModel.leaveSave()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            self.canSave = true
                        }
                    }
                }
            default:
                break
            }
        }
    }
}
