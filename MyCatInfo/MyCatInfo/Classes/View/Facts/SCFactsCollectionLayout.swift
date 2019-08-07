//
//  SCFactsCollectionLayout.swift
//  MyCatInfo
//
//  Created by Stephen Cao on 7/8/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import UIKit
import AnimatedCollectionViewLayout

class SCFactsCollectionLayout: AnimatedCollectionViewLayout {
    override func prepare() {
        super.prepare()
        sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        itemSize = collectionView?.bounds.size ?? CGSize.zero
        animator = ZoomInOutAttributesAnimator()
        scrollDirection = .horizontal
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
    }
}
