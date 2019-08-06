//
//  SCFavouriteViewController.swift
//  MyCatInfo
//
//  Created by Stephen Cao on 3/8/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import UIKit
import CHTCollectionViewWaterfallLayout

private let reuseIdentifier = "favourite_cell"
class SCFavouriteViewController: UIViewController {
    private var shouldRefresh = false
    @IBOutlet weak var collectionView: UICollectionView!
    private let listViewModel = SCFavouriteListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        loadData()
        NotificationCenter.default.addObserver(self, selector: #selector(handleShouldRefreshCollectionView), name: NSNotification.Name(InfoCommon.SCShouldRefreshFavouriteCollectionView), object: nil)
    }
    @objc private func handleShouldRefreshCollectionView(){
        shouldRefresh = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if shouldRefresh{
            loadData()
            shouldRefresh = false
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(InfoCommon.SCShouldRefreshFavouriteCollectionView), object: nil)
    }
}

private extension SCFavouriteViewController{
    func loadData(){
        listViewModel.loadFavouriteBreedData { [weak self ](isSuccess) in
            self?.collectionView.reloadData()
        }
    }
    func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Create a waterfall layout
        let layout = CHTCollectionViewWaterfallLayout()
        
        // Change individual layout attributes for the spacing between cells
        layout.minimumColumnSpacing = 5.0
        layout.minimumInteritemSpacing = 5.0
        
        // Collection view attributes
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.alwaysBounceVertical = true
        
        // Add the waterfall layout to your collection view
        collectionView.collectionViewLayout = layout
        
        collectionView.register(UINib(nibName: "SCFavouriteCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
    }
}
extension SCFavouriteViewController: UICollectionViewDelegate,UICollectionViewDataSource,CHTCollectionViewDelegateWaterfallLayout{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = SCBreedDetailsController(
            viewModel: listViewModel.viewModels?[indexPath.item],
            breedNames: listViewModel.breedNames)
        vc.title = listViewModel.viewModels?[indexPath.item].breedName
        navigationController?.pushViewController(vc, animated: true)
        vc.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listViewModel.viewModels?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SCFavouriteCollectionViewCell
        cell.breedImageView.setImage(urlString: listViewModel.viewModels?[indexPath.item].breedImageUrlString, placeholderImage: UIImage(named: "empty_picture"), cornerRadius: 10)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        // create a cell size from the image size, and return the size
        let imageWidth = listViewModel.viewModels?[indexPath.item].imageWidth ?? 0
        let imageHeight = listViewModel.viewModels?[indexPath.item].imageHeight ?? 0
        return CGSize(width: imageWidth, height: imageHeight)
    }
}
extension SCFavouriteViewController: SCBreedDetailsControllerDelegate{
    func didSelectedComparisonCell(view: SCBreedDetailsController, index: Int, complete: (SCBreedViewModel?) -> ()) {
        complete(listViewModel.viewModels?[index])
    }
}
