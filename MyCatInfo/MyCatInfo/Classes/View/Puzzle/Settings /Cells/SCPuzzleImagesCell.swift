//
//  SCPuzzleImagesCell.swift
//  MyCatInfo
//
//  Created by Stephen Cao on 9/8/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import UIKit

private let tagOffset = 100
protocol SCPuzzleImagesCellDelegate:NSObjectProtocol {
    func didTapImageView(view: SCPuzzleImagesCell, name: String?)
}
class SCPuzzleImagesCell: UITableViewCell {
    weak var delegate: SCPuzzleImagesCellDelegate?
    var imageNameStrings: [String]?{
        didSet{
            clearAllSelection()
            for (index,name) in (imageNameStrings ?? []).enumerated(){
                optionImageViews[index].image = UIImage(named: name)
            }
        }
    }
    @objc private func didTapImageView(recognizer: UITapGestureRecognizer){
        let ivTag = (recognizer.view?.tag ?? 0) - tagOffset
        if ivTag >= 0 && ivTag < imageFrameViews.count{
              delegate?.didTapImageView(view: self, name: imageNameStrings?[ivTag])
              imageFrameViews[ivTag].backgroundColor = InfoCommon.barColor
        }
    }
    
    @IBOutlet var optionImageViews: [UIImageView]!
    @IBOutlet var imageFrameViews: [UIView]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        for v in optionImageViews{
            v.isUserInteractionEnabled = true
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTapImageView))
            v.addGestureRecognizer(recognizer)
        }
    }
    
    func clearAllSelection(){
        for v in imageFrameViews{
            v.backgroundColor = .white
        }
    }
}
