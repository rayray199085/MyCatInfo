//
//  InfoCommon.swift
//  MyCatInfo
//
//  Created by Stephen Cao on 3/8/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import Foundation

struct InfoCommon{
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return formatter
    }()
    static let regionKey = "region"
    static let apiKey = "6566aa4f-daf5-43b8-82e3-c49c3a5724c6"
    static let userId = "vazu7x"
    //#EDB7CA
    static let comparisonBarColor = UIColor(displayP3Red: 255.0 / 255, green: 47.0 / 255, blue: 146.0 / 255, alpha: 1.0)
    static let tinColor = UIColor.white
    static let barColor = UIColor(displayP3Red: 237.0 / 255, green: 183.0 / 255, blue: 202.0 / 255, alpha: 1.0)
    static let tabbarNormalColor = UIColor(displayP3Red: 128.0 / 255, green: 128.0 / 255, blue: 128.0 / 255, alpha: 1.0)
    static let navHighlightedColor = UIColor(displayP3Red: 68.0 / 255, green: 68.0 / 255, blue: 68.0 / 255, alpha: 1.0)
    
    static let breedUrl = "https://api.thecatapi.com/v1/breeds"
    static let searchBreedsUrl = "https://api.thecatapi.com/v1/images/search"
    static let catFactsUrl = "https://cat-fact.herokuapp.com/facts/random"
    static let randomPicUrl = "https://api.thecatapi.com/v1/images/search?mime_types=png,jpg"
    
    static let SCShouldRefreshFavouriteCollectionView = "SCShouldRefreshFavouriteCollectionView"
    static let SCShouldUpdateBreedTableView = "SCShouldUpdateBreedTableView"
}
