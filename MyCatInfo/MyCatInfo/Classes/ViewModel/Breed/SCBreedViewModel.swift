//
//  SCBreedViewModel.swift
//  MyCatInfo
//
//  Created by Stephen Cao on 3/8/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import Foundation

struct SCBreedViewModel {
    var breedName: String?
    var breedDescription: String?
    var breedImageUrlString: String?
    var imageHeight: CGFloat?
    var imageWidth: CGFloat?
    var displayCellHeight: CGFloat?
    var countryEmojiString: String?
    var temperament: String?
    var isFavourite = false
    var row: Int?
    var breedId: String?
    var features: [Int]?
    
    init(breedData: SCBreedData, favouriteStatus: Bool, index: Int) {
        let breed = breedData.breeds?[0]
        breedName = breed?.name
        breedDescription = breed?.description
        breedImageUrlString = breedData.url
        let imageSize = updateImageSize(width: breedData.width, height: breedData.height)
        imageWidth = imageSize.width
        imageHeight = imageSize.height
        temperament = breed?.temperament
        displayCellHeight = getDisplayViewCellHeight()
        countryEmojiString = breed?.country_code?.convertCountryCode2EmojiFlag()
        isFavourite = favouriteStatus
        row = index
        breedId = breed?.id
        features = loadFeatures(breed: breed)
    }
}
extension SCBreedViewModel{
    func loadFeatures(breed: SCBreedDataItem?)->[Int]{
        guard let breed = breed else{
            return []
        }
        
        var features = [Int]()
        features.append(breed.natural ?? 0)
        features.append(breed.vocalisation ?? 0)
        features.append(breed.suppressed_tail ?? 0)
        features.append(breed.stranger_friendly ?? 0)
        features.append(breed.social_needs ?? 0)
        features.append(breed.short_legs ?? 0)
        features.append(breed.shedding_level ?? 0)
        features.append(breed.rex ?? 0)
        features.append(breed.rare ?? 0)
        features.append(breed.lap ?? 0)
        features.append(breed.intelligence ?? 0)
        features.append(breed.indoor ?? 0)
        features.append(breed.hypoallergenic ?? 0)
        features.append(breed.health_issues ?? 0)
        features.append(breed.hairless ?? 0)
        features.append(breed.grooming ?? 0)
        features.append(breed.experimental ?? 0)
        features.append(breed.energy_level ?? 0)
        features.append(breed.dog_friendly ?? 0)
        features.append(breed.child_friendly ?? 0)
        features.append(breed.affection_level ?? 0)
        features.append(breed.adaptability ?? 0)
        return features
    }
    mutating func updateFavouriteStatus(newStatus: Bool){
        isFavourite = newStatus
    }
    
    func getDisplayViewCellHeight()->CGFloat{
        let margin: CGFloat = 3
        let separatorHeight: CGFloat = 1
        let nameLabelHeight: CGFloat = 21
        let viewWidth = UIScreen.screenWidth() - 2 * margin
        var height = margin
        height += nameLabelHeight
        height += margin + (temperament?.heightWithConstrainedWidth(width: viewWidth, font: UIFont.boldSystemFont(ofSize: 13)) ?? 0)
        height += margin + (breedDescription?.heightWithConstrainedWidth(width: viewWidth, font: UIFont.systemFont(ofSize: 15)) ?? 0)
        height += margin + (imageHeight ?? 0)
        height += margin + separatorHeight
        return height
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
        return size
    }
}
