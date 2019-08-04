//
//  SCBreedViewController.swift
//  MyCatInfo
//
//  Created by Stephen Cao on 3/8/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import UIKit
import SVProgressHUD
import SKPhotoBrowser

class SCBreedViewController: UIViewController {
    private let listViewModel = SCBreedListViewModel()
    private let displayView = SCBreedDisplayView.displayView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }
}
private extension SCBreedViewController{
    func setupUI(){
        view.addSubview(displayView)
        displayView.delegate = self
        
        SKPhotoBrowserOptions.backgroundColor = InfoCommon.barColor
    }
    func loadData(){
        SVProgressHUD.show()
        listViewModel.loadBreedData { [weak self](isSuccess) in
            self?.displayView.listViewModel = self?.listViewModel
            SVProgressHUD.dismiss()
        }
    }
}
extension SCBreedViewController: SCBreedDisplayViewDelegate{
    func didSelectedCell(view: SCBreedDisplayView, index: Int) {
        let vc = SCBreedDetailsController()
        vc.viewModel = listViewModel.viewModels?[index]
        vc.title = listViewModel.viewModels?[index].breedName
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapCellImageView(view: SCBreedDisplayView, urlString: String?) {
        guard let urlString = urlString,
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
}
