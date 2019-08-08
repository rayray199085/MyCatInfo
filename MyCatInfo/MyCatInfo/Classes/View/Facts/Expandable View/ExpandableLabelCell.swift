//
//  ExpandableLabelCell.swift
//  MyCatInfo
//
//  Created by Stephen Cao on 3/8/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import UIKit

protocol ExpandableLabelCellDelegate: NSObjectProtocol {
	func moreTapped(cell: ExpandableLabelCell)
    func didTapImageView(view: ExpandableLabelCell, imageUrlString: String?)
}

class ExpandableLabelCell: UITableViewCell {
    var viewModel: SCFactsViewModel?{
        didSet{
            isExpanded = false
            labelBody.text = viewModel?.facts
            labelBody.numberOfLines = 0
            sizingLabel.text = viewModel?.facts
            sizingLabel.numberOfLines = 2
            
            if (viewModel?.shouldShowMore ?? false){
                buttonMoreHeightCons.constant = 21
                buttonMore.isHidden = false
            }else{
                buttonMoreHeightCons.constant = 0
                buttonMore.isHidden = true
            }
            imgWidthCons.constant = viewModel?.imageWidth ?? 0
            imgHeightCons.constant = viewModel?.imageHeight ?? 0
            layoutIfNeeded()
            
            itemImageView.setImage(urlString: viewModel?.imageUrl, placeholderImage: UIImage(named: "empty_picture"), cornerRadius: 10)
            
        }
    }
    @objc private func didTapImageView(recognizer: UITapGestureRecognizer){
        delegate?.didTapImageView(view: self, imageUrlString: viewModel?.imageUrl)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        improvePerformance()
        
        itemImageView.isUserInteractionEnabled = true
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTapImageView))
        itemImageView.addGestureRecognizer(recognizer)
    }
    
    @IBOutlet weak var buttonMoreHeightCons: NSLayoutConstraint!
    @IBOutlet weak var imgHeightCons: NSLayoutConstraint!
    @IBOutlet weak var imgWidthCons: NSLayoutConstraint!
    @IBOutlet weak var itemImageView: UIImageView!
	@IBOutlet weak var labelBody: UILabel!
	@IBOutlet weak var buttonMore: UIButton!
	@IBOutlet weak var sizingLabel: UILabel!
	
	
	weak var delegate: ExpandableLabelCellDelegate?
	var isExpanded: Bool = false
	
	@IBAction func btnMoreTapped(_ sender: Any) {
		if sender is UIButton {
			isExpanded = !isExpanded
			sizingLabel.numberOfLines = isExpanded ? 0 : 2
			buttonMore.setTitle(isExpanded ? "Read less..." : "Read more...", for: .normal)
			delegate?.moreTapped(cell: self)
		}
	}
}
