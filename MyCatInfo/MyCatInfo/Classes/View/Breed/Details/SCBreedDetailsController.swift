//
//  SCBreedDetailsController.swift
//  MyCatInfo
//
//  Created by Stephen Cao on 4/8/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import UIKit
import DLSlideView

class SCBreedDetailsController: UIViewController {
    var viewModel: SCBreedViewModel?
    
    @IBOutlet weak var tabedSlideView: DLTabedSlideView!
    
    private let featureController = SCBreedFeatureController()
    
    private let tabInfoArray = [["image":"feature", "title": "Feature"],
                                ["image":"picture", "title": "Picture"]]
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}
private extension SCBreedDetailsController{
    func setupUI(){
        setupTabedSlideView()
        
    }
    private func getTabs()->[DLTabedbarItem]{
        var tabs = [DLTabedbarItem]()
        for dict in tabInfoArray{
            guard let imageName = dict["image"],
                let title = dict["title"],
                let normalImage = UIImage(named: imageName)?.modifyImageSize(newSize: CGSize(width: 20, height: 20)),
                let highlightedImage = UIImage(named: "\(imageName)_highlighted")?.modifyImageSize(newSize: CGSize(width: 20, height: 20)),
                let tabItem = DLTabedbarItem(title: title, image: normalImage, selectedImage: highlightedImage) else{
                    return tabs
            }
            tabs.append(tabItem)
        }
        return tabs
    }
    
    func setupTabedSlideView(){
        tabedSlideView.baseViewController = self
        tabedSlideView.delegate = self
        tabedSlideView.tabItemNormalColor = UIColor.darkGray
        tabedSlideView.tabItemSelectedColor = InfoCommon.barColor
        tabedSlideView.tabbarTrackColor = InfoCommon.barColor
        tabedSlideView.tabbarBottomSpacing = 3.0
        
        tabedSlideView.tabbarItems = getTabs()
        tabedSlideView.buildTabbar()
        tabedSlideView.selectedIndex = 0
    }
}
extension SCBreedDetailsController: DLTabedSlideViewDelegate{
    func numberOfTabs(in sender: DLTabedSlideView!) -> Int {
        return tabInfoArray.count
    }
    
    func dlTabedSlideView(_ sender: DLTabedSlideView!, controllerAt index: Int) -> UIViewController? {
        switch index {
        case 0:
            return featureController
        default:
            break
        }
        return UIViewController()
    }
    func dlTabedSlideView(_ sender: DLTabedSlideView!, didSelectedAt index: Int) {
        switch index {
        case 0:
            featureController.viewModel = viewModel
        default:
            break
        }
    }
}
