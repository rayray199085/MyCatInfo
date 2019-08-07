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

private let reuseIdentifier = "facts_cell"
class SCFactsViewController: UIViewController {
    private let listViewModel = SCFactsListViewModel()
    private var shouldLoadMore = false
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configCollectionView()
        loadData()
    }
    func loadData(){
        SVProgressHUD.show()
        listViewModel.loadCatFacts { [weak self](isSuccess) in
            self?.collectionView.reloadData()
            SVProgressHUD.dismiss()
        }
    }
}
private extension SCFactsViewController{
    func configCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "SCFactsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
    }
}
extension SCFactsViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listViewModel.viewModels?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SCFactsCollectionViewCell
        cell.viewModel = listViewModel.viewModels?[indexPath.item]
        cell.delegate = self
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == (listViewModel.viewModels?.count ?? 0) - 1 && !shouldLoadMore{
            shouldLoadMore = true
            SVProgressHUD.show()
            listViewModel.loadCatFacts { [weak self](isSuccess) in
                self?.collectionView.reloadData()
                self?.shouldLoadMore = false
                SVProgressHUD.dismiss()
            }
        }
    }
}
extension SCFactsViewController: SCFactsCollectionViewCellDelegate{
    func didTapImageView(view: SCFactsCollectionViewCell, imageUrlString: String?) {
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
}
