//
//  SCBaseListViewModel.swift
//  MyCatInfo
//
//  Created by Stephen Cao on 6/8/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import Foundation
class SCBaseListViewModel{
    var viewModels: [SCBreedViewModel]?
    var breedNames: [String]{
        var names = [String]()
        for viewModel in viewModels ?? []{
            names.append(viewModel.breedName ?? "")
        }
        return names
    }
}
