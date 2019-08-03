//
//  SCBreedDisplayViewCell.swift
//  MyCatInfo
//
//  Created by Stephen Cao on 3/8/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import UIKit

class SCBreedDisplayViewCell: UITableViewCell {
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
        }
    }
    @IBOutlet weak var temperamentLabel: UILabel!
    @IBOutlet weak var breedNameLabel: UILabel!
    @IBOutlet weak var breedDescriptionLabel: UILabel!
    @IBOutlet weak var breedImageView: UIImageView!
    
    @IBOutlet weak var imageViewHeightCons: NSLayoutConstraint!
    @IBOutlet weak var imageViewWidthCons: NSLayoutConstraint!
    @IBOutlet weak var countryFlagLabel: UILabel!
}
