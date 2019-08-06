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
    var cellHeight: CGFloat?
   
    
    init(factsItem: SCFactsDataItem) {
        facts = factsItem.text
        cellHeight = calculateCellHeight()
    }
    func calculateCellHeight()->CGFloat{
        let margin: CGFloat = 3
        let viewWidth = UIScreen.screenWidth() - margin * 2
        var height = margin
        height += facts?.heightWithConstrainedWidth(width: viewWidth, font: UIFont.systemFont(ofSize: 15)) ?? 0
        height += margin
        return height
    }
}
