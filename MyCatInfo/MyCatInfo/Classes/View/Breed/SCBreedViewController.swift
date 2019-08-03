//
//  SCBreedViewController.swift
//  MyCatInfo
//
//  Created by Stephen Cao on 3/8/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import UIKit
import SVProgressHUD

class SCBreedViewController: UIViewController {
    private let listViewModel = SCBreedListViewModel()
    private let displayView = SCBreedDisplayView.displayView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }
}
private extension SCBreedViewController{
    func setupUI(){
        view.addSubview(displayView)
    }
    func loadData(){
        SVProgressHUD.show()
        listViewModel.loadBreedData { [weak self](isSuccess) in
            self?.displayView.listViewModel = self?.listViewModel
            SVProgressHUD.dismiss()
        }
    }
}
