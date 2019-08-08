//
//  SCFactsViewModel.swift
//  MyCatInfo
//
//  Created by Stephen Cao on 6/8/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import Foundation

struct SCFactsViewModel {
    var facts: String?
    var imageUrl: String?
    var imageWidth: CGFloat?
    var imageHeight: CGFloat?
    var shouldShowMore: Bool?
    
    init(factsItem: SCFactsDataItem, imageItem: SCFactsImageDataItem) {
        facts = factsItem.text
        imageUrl = imageItem.url
        let size = updateImageSize(width: imageItem.width, height: imageItem.height)
        imageWidth = size.width
        imageHeight = size.height
        shouldShowMore = shouldShowMoreButton()
    }
    private func shouldShowMoreButton()->Bool{
        let margin: CGFloat = 3
        let singleLineLabelHeight: CGFloat = 21
        let viewWidth = UIScreen.screenWidth() - 2 * margin
        let height = facts?.heightWithConstrainedWidth(width: viewWidth, font: UIFont.systemFont(ofSize: 17)) ?? 0
        return height > 2 * singleLineLabelHeight
    }
    
    private func updateImageSize(width: Int?, height: Int?)->CGSize{
        let height = CGFloat(height ?? 0)
        let width = CGFloat(width ?? 0)
        var size = CGSize(width: width, height: height)
        let maxWidth: CGFloat = UIScreen.screenWidth() * 0.7
        if size.width > maxWidth {
            size.width = maxWidth
            size.height = size.width * height / width
        }
        return size
    }
}
