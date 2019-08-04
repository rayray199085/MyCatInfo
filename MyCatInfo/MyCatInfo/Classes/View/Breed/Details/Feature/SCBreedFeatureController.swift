//
//  SCBreedFeatureController.swift
//  MyCatInfo
//
//  Created by Stephen Cao on 4/8/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import UIKit

class SCBreedFeatureController: UIViewController {
    var viewModel: SCBreedViewModel?{
        didSet{
            print(viewModel?.breedName)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
