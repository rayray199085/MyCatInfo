//
//  SCNetworkManager+extension.swift
//  MyCatInfo
//
//  Created by Stephen Cao on 3/8/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import Foundation

extension SCNetworkManager{
    func fetchBreedData(completion:@escaping (_ data: Data?, _ isSuccess: Bool)->()){
        request(urlString: InfoCommon.breedUrl, method: .get, params: nil) { (data, _, isSuccess, _, _) in
            completion(data, isSuccess)
        }
    }
    
    func fetchBreedDataWithId(id: String, completion:@escaping (_ data: Data?, _ isSuccess: Bool)->()){
        let params = ["breed_ids":id]
        request(urlString: InfoCommon.searchBreedsUrl, method: .get, params: params) { (data, _, isSuccess, _, _) in
            completion(data, isSuccess)
        }
    }
    
}
