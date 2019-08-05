//
//  SCBreedListViewModel.swift
//  MyCatInfo
//
//  Created by Stephen Cao on 3/8/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import Foundation

class SCBreedListViewModel{
    var viewModels: [SCBreedViewModel]?
    var breedNames: [String]?
    
    func loadBreedData(completion:@escaping (_ isSuccess: Bool)->()){
        var breedViewModels = [SCBreedViewModel]()
        var names = [String]()
        guard let listPath = Bundle.main.path(forResource: "breedsIdList", ofType: "json"),
            let listData = try? Data(contentsOf: URL(fileURLWithPath: listPath)),
            let idList = try? JSONSerialization.jsonObject(with: listData, options: []) as? [String] else{
                completion(false)
                return
        }
        let favouriteStautsList = loadFavouriteData(idList: idList)
        DispatchQueue.global().async {
            for (index,id) in idList.enumerated(){
                if let itemPath = Bundle.main.path(forResource: id, ofType: "json"),
                   let itemData = try? Data(contentsOf: URL(fileURLWithPath: itemPath)),
                   let breedItem = try? JSONDecoder().decode([SCBreedData].self, from: itemData) {
                    names.append(breedItem[0].breeds?[0].name ?? "")
                    breedViewModels.append(SCBreedViewModel(breedData: breedItem[0], favouriteStatus: favouriteStautsList[index],index: index))
                }
            }
            DispatchQueue.main.async(execute: {
                self.viewModels = breedViewModels
                self.breedNames = names
                completion(true)
            })
        }
    }
    func loadFavouriteData(idList: [String])->[Bool]{
        let breeds = CoreDataManager.shared.getAllFavouriteBreeds()
        var favouriteStatus = [Bool]()
        if breeds.count == 0{
            for id in idList{
                CoreDataManager.shared.addFavouriteBreedWith(name: id)
                favouriteStatus.append(false)
            }
            return favouriteStatus
        }
        for breed in breeds{
            favouriteStatus.append(breed.isFavourite)
        }
        return favouriteStatus
    }
    
}
