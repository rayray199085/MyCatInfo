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
        let group = DispatchGroup()
        var imageItems = [SCFactsImageDataItem]()
        for _ in 0..<10{
            group.enter()
            SCNetworkManager.shared.fetchARandomImage { (data, isSuccess) in
                if let data = data,
                   let imageItem = try? JSONDecoder().decode([SCFactsImageDataItem].self, from: data).first {
                    imageItems.append(imageItem)
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            SCNetworkManager.shared.fetchCatFacts { (data, isSuccess) in
                guard let data = data,
                    let factsItems = try? JSONDecoder().decode([SCFactsDataItem].self, from: data) else{
                        completion(false)
                        return
                }
                var viewModels = [SCFactsViewModel]()
                for (index,item) in factsItems.enumerated(){
                    viewModels.append(SCFactsViewModel(factsItem: item, imageItem: imageItems[index]))
                }
                if self.viewModels == nil{
                    self.viewModels = viewModels
                }else{
                    self.viewModels! += viewModels
                }
                completion(true)
            }
        }
    }
}
