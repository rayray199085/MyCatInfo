//
//  SCBreedDetailsController.swift
//  MyCatInfo
//
//  Created by Stephen Cao on 4/8/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import UIKit
import DLSlideView

protocol SCBreedDetailsControllerDelegate: NSObjectProtocol {
    func didSelectedComparisonCell(view: SCBreedDetailsController,index: Int, complete:(_ viewModel: SCBreedViewModel?)->())
}
class SCBreedDetailsController: UIViewController {
    weak var delegate: SCBreedDetailsControllerDelegate?
    
    private lazy var comparisonView = SCBreedComparisonView.comparisonView()
    var breedNames: [String]?
    var viewModel: SCBreedViewModel?
    private lazy var comparisonButton: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "comparison"), for: [])
        btn.setBackgroundImage(UIImage(named: "comparison_highlighted"), for: .highlighted)
        return btn
    }()
    
    @IBOutlet weak var tabedSlideView: DLTabedSlideView!
    
    private let featureController = SCBreedFeatureController()
    
    private let tabInfoArray = [["image":"feature", "title": "Feature"],
                                ["image":"picture", "title": "Picture"]]
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    @objc private func clickComparisonButton(){
        comparisonButton.isEnabled = false
        comparisonView.showComparisonView {[weak self] in
            self?.comparisonButton.isEnabled = true
        }
    }
}
private extension SCBreedDetailsController{
    func setupUI(){
        setupTabedSlideView()
        setupNavigationItem()
        navigationController?.view.addSubview(comparisonView)
        comparisonView.breedNames = breedNames
        comparisonView.delegate = self
    }
    func setupNavigationItem(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: comparisonButton)
        comparisonButton.addTarget(self, action: #selector(clickComparisonButton), for: .touchUpInside)
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
extension SCBreedDetailsController: SCBreedComparisonViewDelegate{
    func didDismissComparisonView(view: SCBreedComparisonView?) {
        if tabedSlideView.selectedIndex != 0{
            tabedSlideView.selectedIndex = 0
        }
    }
    
    func didSelectedCell(view: SCBreedComparisonView, index: Int) {
        delegate?.didSelectedComparisonCell(view: self, index: index, complete: { [weak self](comparisonViewModel) in
            self?.featureController.comparisonViewModel = comparisonViewModel
        })
    }
}
