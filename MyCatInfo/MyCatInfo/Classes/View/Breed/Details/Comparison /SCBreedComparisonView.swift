//
//  SCBreedComparisonView.swift
//  MyCatInfo
//
//  Created by Stephen Cao on 5/8/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import UIKit

protocol SCBreedComparisonViewDelegate: NSObjectProtocol {
    func didSelectedCell(view: SCBreedComparisonView, index: Int)
    func didDismissComparisonView(view: SCBreedComparisonView?)
}
private let reuseIdentifier = "comparison_cell"
class SCBreedComparisonView: UIView {
    weak var delegate: SCBreedComparisonViewDelegate?
    
    var breedNames: [String]?
    
    @IBOutlet weak var tableView: UITableView!
    class func comparisonView()->SCBreedComparisonView{
        let nib = UINib(nibName: "SCBreedComparisonView", bundle: nil)
        let v = nib.instantiate(withOwner: self, options: nil)[0] as! SCBreedComparisonView
        v.frame = UIScreen.main.bounds
        v.alpha = 0
        return v
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SCBreedComparisonCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = 44
    
    }
    @IBAction func clickComparisonMaskButton(_ sender: Any) {
        dismissComparisonView()
        guard let index = tableView.indexPathForSelectedRow?.row else{
            return 
        }
        delegate?.didSelectedCell(view: self, index: index)
    }
    
    func showComparisonView(completion:@escaping ()->()){
        addPopAlphaAnimation(fromValue: 0, toValue: 1, duration: 0.25) { (_, _) in
            completion()
        }
    }
    func dismissComparisonView(){
        addPopAlphaAnimation(fromValue: 1, toValue: 0, duration: 0.25) { [weak self](_, _) in
            self?.delegate?.didDismissComparisonView(view: self)
        }
    }
}
extension SCBreedComparisonView: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breedNames?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SCBreedComparisonCell
        cell.breedNameLabel.text = breedNames?[indexPath.row]
        return cell
    }
}
