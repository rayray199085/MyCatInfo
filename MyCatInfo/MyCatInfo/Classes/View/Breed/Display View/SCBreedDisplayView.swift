//
//  SCBreedDisplayView.swift
//  MyCatInfo
//
//  Created by Stephen Cao on 3/8/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import UIKit

private let reuseIdentifier = "breed_cell"
class SCBreedDisplayView: UIView {
    @IBOutlet weak var tableView: UITableView!
    
    var listViewModel: SCBreedListViewModel?{
        didSet{
            tableView.reloadData()
        }
    }
    
    class func displayView()->SCBreedDisplayView{
        let nib = UINib(nibName: "SCBreedDisplayView", bundle: nil)
        let v = nib.instantiate(withOwner: self, options: nil)[0] as! SCBreedDisplayView
        v.frame = UIScreen.main.bounds
        return v
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "SCBreedDisplayViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
    }
}
extension SCBreedDisplayView: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel?.viewModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SCBreedDisplayViewCell
        cell.viewModel = listViewModel?.viewModels?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return listViewModel?.viewModels?[indexPath.row].displayCellHeight ?? 0
    }
}
