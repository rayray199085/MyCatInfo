//
//  SCFactsViewController.swift
//  MyCatInfo
//
//  Created by Stephen Cao on 3/8/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import UIKit
import SVProgressHUD

private let reuseIdentifier = "facts_cell"
class SCFactsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private let listViewModel = SCFactsListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }
}
private extension SCFactsViewController{
    func setupUI(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "SCFactsTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
    }
    func loadData(){
        SVProgressHUD.show()
        listViewModel.loadCatFacts { (isSuccess) in
            self.tableView.reloadData()
            SVProgressHUD.dismiss()
        }
    }
}
extension SCFactsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.viewModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SCFactsTableViewCell
        cell.factsLabel.text = listViewModel.viewModels?[indexPath.row].facts
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return listViewModel.viewModels?[indexPath.row].cellHeight ?? 0
    }
}
