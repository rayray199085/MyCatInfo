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
    
    init(factsItem: SCFactsDataItem, imageItem: SCFactsImageDataItem) {
        facts = factsItem.text
        imageUrl = imageItem.url
        let size = updateImageSize(width: imageItem.width, height: imageItem.height)
        imageWidth = size.width
        imageHeight = size.height
    }
    func updateImageSize(width: Int?, height: Int?)->CGSize{
        let height = CGFloat(height ?? 0)
        let width = CGFloat(width ?? 0)
        var size = CGSize(width: width, height: height)
        let maxWidth: CGFloat = UIScreen.screenWidth() * 0.7
        if size.width > maxWidth {
            size.width = maxWidth
            size.height = size.width * height / width
        }
        if size.height > UIScreen.screenHeight() / 2{
            size.height = UIScreen.screenHeight() / 2
        }
        return size
    }
}
