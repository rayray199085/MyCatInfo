//
//  SCBreedDisplayViewCell.swift
//  MyCatInfo
//
//  Created by Stephen Cao on 3/8/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import UIKit

protocol SCBreedDisplayViewCellDelegate: NSObjectProtocol {
    func updateFavouriteStatus(view: SCBreedDisplayViewCell,newStauts: Bool, row: Int)
    func didTapImageView(view: SCBreedDisplayViewCell,urlString: String?)
}
class SCBreedDisplayViewCell: UITableViewCell {
    weak var delegate: SCBreedDisplayViewCellDelegate?
    
    var viewModel: SCBreedViewModel?{
        didSet{
            breedNameLabel.text = viewModel?.breedName
            breedDescriptionLabel.text = viewModel?.breedDescription
            imageViewWidthCons.constant = viewModel?.imageWidth ?? 0
            imageViewHeightCons.constant = viewModel?.imageHeight ?? 0
            layoutIfNeeded()
            breedImageView.setImage(urlString: viewModel?.breedImageUrlString, placeholderImage: UIImage(named: "empty_picture"), cornerRadius: 10)
            countryFlagLabel.text = viewModel?.countryEmojiString
            temperamentLabel.text = viewModel?.temperament
            likeButton.isSelected = viewModel?.isFavourite ?? false
        }
    }
    @objc private func didTapImageView(recognizer: UITapGestureRecognizer){
        delegate?.didTapImageView(view: self, urlString: viewModel?.breedImageUrlString)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        breedImageView.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapImageView))
        breedImageView.addGestureRecognizer(tapRecognizer)
    }
    
    @IBOutlet weak var temperamentLabel: UILabel!
    @IBOutlet weak var breedNameLabel: UILabel!
    @IBOutlet weak var breedDescriptionLabel: UILabel!
    @IBOutlet weak var breedImageView: UIImageView!
    
    @IBOutlet weak var imageViewHeightCons: NSLayoutConstraint!
    @IBOutlet weak var imageViewWidthCons: NSLayoutConstraint!
    @IBOutlet weak var countryFlagLabel: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBAction func clickLikeButton(_ sender: Any) {
        let currentStatus = !likeButton.isSelected
        delegate?.updateFavouriteStatus(view: self, newStauts: currentStatus, row: viewModel?.row ?? 0)
        likeButton.isSelected = currentStatus
        CoreDataManager.shared.updateBreedFavouriteWith(name: viewModel?.breedId ?? "", newFavouriteStatus: currentStatus)
    }
}
