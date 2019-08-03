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
    func loadBreedData(completion:@escaping (_ isSuccess: Bool)->()){
        var breedViewModels = [SCBreedViewModel]()
        DispatchQueue.global().async {
            if let listPath = Bundle.main.path(forResource: "breedsIdList", ofType: "json"),
               let listData = try? Data(contentsOf: URL(fileURLWithPath: listPath)),
               let idList = try? JSONSerialization.jsonObject(with: listData, options: []) as? [String] {
                for id in idList{
                    if let itemPath = Bundle.main.path(forResource: id, ofType: "json"),
                       let itemData = try? Data(contentsOf: URL(fileURLWithPath: itemPath)),
                       let breedItem = try? JSONDecoder().decode([SCBreedData].self, from: itemData) {
                       breedViewModels.append(SCBreedViewModel(breedData: breedItem[0]))
                    }
                }
            }
            DispatchQueue.main.async(execute: {
                self.viewModels = breedViewModels
                completion(true)
            })
        }
    }
}
