//
//  SCBreedDisplayView.swift
//  MyCatInfo
//
//  Created by Stephen Cao on 3/8/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import UIKit

protocol SCBreedDisplayViewDelegate: NSObjectProtocol {
    func didTapCellImageView(view: SCBreedDisplayView, urlString: String?)
    func didSelectedCell(view: SCBreedDisplayView, index: Int)
}
private let reuseIdentifier = "breed_cell"
class SCBreedDisplayView: UIView {
    weak var delegate: SCBreedDisplayViewDelegate?
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
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return listViewModel?.viewModels?[indexPath.row].displayCellHeight ?? 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectedCell(view: self, index: indexPath.row)
    }
}
extension SCBreedDisplayView: SCBreedDisplayViewCellDelegate{
    // update viewModel favourite status
    func updateFavouriteStatus(view: SCBreedDisplayViewCell, newStauts: Bool, row: Int) {
        listViewModel?.viewModels?[row].updateFavouriteStatus(newStatus: newStauts)
    }
    
    func didTapImageView(view: SCBreedDisplayViewCell, urlString: String?) {
        delegate?.didTapCellImageView(view: self, urlString: urlString)
    }
}
