//
//  ExpandableTableView.swift
//  MyCatInfo
//
//  Created by Stephen Cao on 3/8/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import UIKit
protocol ExpandableTableViewDelegate: NSObjectProtocol {
    func loadMoreData(view: ExpandableTableView, completion:@escaping ()->())
    func pullDownToRefresh(view: ExpandableTableView, completion:@escaping ()->())
    func showImageInLargeMode(view: ExpandableTableView, imageUrlString: String?)
}

private let reuseIdentifier = "expandable_cell"
class ExpandableTableView: UIView{
    
    private var refreshControl: SCRRefreshControl!{
        didSet{
            tableView.addSubview(refreshControl)
            refreshControl.addTarget(self, action: #selector(pullDownRefreshData), for: .valueChanged)
        }
    }
    
    private var shouldLoadMore = false
    weak var delegate: ExpandableTableViewDelegate?
    
    var viewModels: [SCFactsViewModel]?{
        didSet{
            tableView.reloadData()
        }
    }
    
    class func initView(navigationBarHeight: CGFloat = 64)->ExpandableTableView{
        let nib = UINib(nibName: "ExpandableTableView", bundle: nil)
        let v = nib.instantiate(withOwner: self, options: nil)[0] as! ExpandableTableView
        v.frame = UIScreen.main.bounds
        v.refreshControl = SCRRefreshControl(style: .simple, navigationBarHeight: navigationBarHeight)
        return v
    }
    @IBOutlet weak var tableView: UITableView!
    var myArray = [String]()
	
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300; //Set this to any value that works for you.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ExpandableLabelCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
    }
    
    @objc private func pullDownRefreshData(){
        refreshControl.beginRefreshing()
        delegate?.pullDownToRefresh(view: self, completion: { [weak self] in
            self?.refreshControl.endRefreshing()
        })
    }
}
extension ExpandableTableView: ExpandableLabelCellDelegate{
    func didTapImageView(view: ExpandableLabelCell, imageUrlString: String?) {
        delegate?.showImageInLargeMode(view: self, imageUrlString: imageUrlString)
    }
    
    // MARK: - my cell delegate
    func moreTapped(cell: ExpandableLabelCell) {
        // this will "refresh" the row heights, without reloading
        tableView.beginUpdates()
        tableView.endUpdates()
        // do anything else you want because the switch was changed
    }
}
extension ExpandableTableView: UITableViewDelegate, UITableViewDataSource{
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ExpandableLabelCell
        // Configure the cell...
        cell.viewModel = viewModels?[indexPath.row]
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // the last row
        if indexPath.row == (viewModels?.count ?? 0) - 1 && !shouldLoadMore{
            shouldLoadMore = true
            delegate?.loadMoreData(view: self, completion: { [weak self] in
                self?.shouldLoadMore = false
            })
        }
    }
}
