//
//  SCFactsListViewModel.swift
//  MyCatInfo
//
//  Created by Stephen Cao on 6/8/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import Foundation

class SCFactsListViewModel{
    var viewModels: [SCFactsViewModel]?
    
    func loadCatFacts(completion:@escaping (_ isSuccess: Bool)->()){
        SCNetworkManager.shared.fetchCatFacts { (data, isSuccess) in
            guard let data = data,
                  let factsItems = try? JSONDecoder().decode([SCFactsDataItem].self, from: data) else{
                    completion(false)
                    return
            }
            var viewModels = [SCFactsViewModel]()
            for item in factsItems{
                viewModels.append(SCFactsViewModel(factsItem: item))
            }
            self.viewModels = viewModels
            completion(true)
        }
    }
}
