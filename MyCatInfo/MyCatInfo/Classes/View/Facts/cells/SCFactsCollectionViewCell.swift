//
//  SCFactsCollectionViewCell.swift
//  MyCatInfo
//
//  Created by Stephen Cao on 7/8/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import UIKit

protocol SCFactsCollectionViewCellDelegate: NSObjectProtocol {
    func didTapImageView(view: SCFactsCollectionViewCell, imageUrlString: String?)
}
class SCFactsCollectionViewCell: UICollectionViewCell {
    weak var delegate: SCFactsCollectionViewCellDelegate?
    
    var viewModel: SCFactsViewModel?{
        didSet{
            imageWidthCons.constant = viewModel?.imageWidth ?? 0
            imageHeightCons.constant = viewModel?.imageHeight ?? 0
            layoutIfNeeded()
            catImageView.setImage(urlString: viewModel?.imageUrl, placeholderImage: UIImage(named: "empty_picture"), cornerRadius: 10)
            factsTextView.text = viewModel?.facts
        }
    }
    @objc private func didTapImageView(recognizer : UITapGestureRecognizer){
        delegate?.didTapImageView(view: self, imageUrlString: viewModel?.imageUrl)
    }
    
    @IBOutlet weak var imageWidthCons: NSLayoutConstraint!
    @IBOutlet weak var imageHeightCons: NSLayoutConstraint!
    @IBOutlet weak var catImageView: UIImageView!
    @IBOutlet weak var factsTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        catImageView.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapImageView))
        catImageView.addGestureRecognizer(tapRecognizer)
    }
}
