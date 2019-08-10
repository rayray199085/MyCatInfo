//
//  SCFavouriteListViewModel.swift
//  MyCatInfo
//
//  Created by Stephen Cao on 6/8/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import Foundation

class SCFavouriteListViewModel: SCBaseListViewModel{
    func loadFavouriteBreedData(completion:@escaping (_ isSuccess: Bool)->()){
        let res = CoreDataManager.shared.getAllBreeds().filter { $0.isFavourite == true }
        if res.count == 0{
            self.viewModels = []
            completion(false)
            return
        }
        var breedViewModels = [SCBreedViewModel]()
        DispatchQueue.global().async {
            for item in res{
                guard let id = item.name,
                    let itemPath = Bundle.main.path(forResource: "\(id)", ofType: ".json"),
                    let itemData = try? Data(contentsOf: URL(fileURLWithPath: itemPath)),
                    let breedItem = try? JSONDecoder().decode([SCBreedData].self, from: itemData) else{
                        continue
                }
                breedViewModels.append(SCBreedViewModel(breedData: breedItem[0], favouriteStatus: true))
            }
            DispatchQueue.main.async(execute: {
                self.viewModels = breedViewModels
                completion(true)
            })
        }
    }
}
