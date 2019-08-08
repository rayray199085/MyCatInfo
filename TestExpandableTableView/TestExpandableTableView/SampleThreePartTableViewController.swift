//
//  SampleThreePartTableViewController.swift
//  TestExpandableTableView
//
//  Created by Stephen Cao on 8/8/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import UIKit

class SampleThreePartTableViewController: UIViewController {

    private lazy var expandableView = ExpandableTableView.initView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(expandableView)
    }
}
