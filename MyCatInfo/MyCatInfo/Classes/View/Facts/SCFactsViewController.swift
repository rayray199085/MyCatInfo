//
//  SCFactsViewController.swift
//  MyCatInfo
//
//  Created by Stephen Cao on 3/8/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import UIKit
import SVProgressHUD
import SKPhotoBrowser

class SCFactsViewController: UIViewController {
    private var expandableView: ExpandableTableView!
    private let listViewModel = SCFactsListViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }
}
private extension SCFactsViewController{
    func setupUI(){
        let topBarHeight = UIApplication.shared.statusBarFrame.size.height +
            (navigationController?.navigationBar.frame.height ?? 0.0)
        expandableView = ExpandableTableView.initView(navigationBarHeight: topBarHeight)
        view.addSubview(expandableView)
        expandableView.delegate = self
    }
    
    func loadData(){
        SVProgressHUD.show()
        listViewModel.loadCatFacts { [weak self](isSuccess) in
            self?.expandableView.viewModels = self?.listViewModel.viewModels
            SVProgressHUD.dismiss()
        }
    }
}
extension SCFactsViewController: ExpandableTableViewDelegate{
    func showImageInLargeMode(view: ExpandableTableView, imageUrlString: String?) {
        guard let urlString = imageUrlString,
            let url = URL(string: urlString) else{
                return
        }
        UIImage.downloadImage(url: url) { (image) in
            guard let image = image else{
                return
            }
            var images = [SKPhoto]()
            let photo = SKPhoto.photoWithImage(image)
            photo.shouldCachePhotoURLImage = false
            images.append(photo)
            
            let browser = SKPhotoBrowser(photos: images)
            browser.initializePageIndex(0)
            self.present(browser, animated: true, completion: {})
        }
    }
    
    func pullDownToRefresh(view: ExpandableTableView, completion: @escaping () -> ()) {
        listViewModel.viewModels = nil
        listViewModel.loadCatFacts { [weak self](isSuccess) in
            self?.expandableView.viewModels = self?.listViewModel.viewModels
            completion()
        }
    }
    
    func loadMoreData(view: ExpandableTableView, completion: @escaping () -> ()) {
        SVProgressHUD.show()
        listViewModel.loadCatFacts { [weak self](isSuccess) in
            self?.expandableView.viewModels = self?.listViewModel.viewModels
            completion()
            SVProgressHUD.dismiss()
        }
    }
}
