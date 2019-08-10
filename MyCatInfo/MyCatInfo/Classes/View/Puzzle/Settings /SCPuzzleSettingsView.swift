//
//  SCPuzzleSettingsView.swift
//  MyCatInfo
//
//  Created by Stephen Cao on 9/8/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import UIKit
import FTFoldingTableView

protocol SCPuzzleSettingsViewDelegate: NSObjectProtocol {
    func settingsOption(view: SCPuzzleSettingsView, difficulty: puzzleLevel, image: UIImage?)
}
private let difficultyIdentifier = "difficulty_cell"
private let imageIdentifier = "image_cell"

class SCPuzzleSettingsView: UIView {
    weak var delegate: SCPuzzleSettingsViewDelegate?
    private var selectedDifficulty: puzzleLevel = .easy
    private var selectedImage: UIImage?
    
    private let titles = ["Difficulties", "Image Database"]
    private let difficulties = ["Very Easy", "Easy", "Normal", "Hard"]
    
    private let imageGroups = [["cat_1","cat_2","cat_3"],
                               ["cat_4","cat_5","cat_6"],
                               ["cat_7","cat_8","cat_9"],
                               ["cat_10","cat_11","cat_sample"]]

    @IBOutlet weak var tableView: FTFoldingTableView!
    @IBAction func clickSettingsMaskButton(_ sender: Any) {
        hideSettingsView()
    }
    
    @objc private func didSwipeToLeft(recognizer: UISwipeGestureRecognizer){
        if recognizer.state == .ended{
            hideSettingsView()
        }
    }
    
    class func settingsView()-> SCPuzzleSettingsView{
        let nib = UINib(nibName: "SCPuzzleSettingsView", bundle: nil)
        let v = nib.instantiate(withOwner: self, options: nil)[0] as! SCPuzzleSettingsView
        v.frame = UIScreen.main.bounds
        return v
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTableView()
        
        let recognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeToLeft))
        recognizer.direction = .left
        tableView.addGestureRecognizer(recognizer)
    }
    func cancelAllSettingsSelectedImages(){
        for row in 0..<imageGroups.count{
            guard let cell = tableView.cellForRow(at: IndexPath(row: row, section: 1)) as? SCPuzzleImagesCell else{
                continue
            }
            cell.clearAllSelection()
        }
        selectedImage = nil
    }
}
extension SCPuzzleSettingsView: FTFoldingTableViewDelegate{
    func perferedArrowPosition(for ftTableView: FTFoldingTableView!) -> FTFoldingSectionHeaderArrowPosition {
        return .left
    }
    
    func numberOfSection(for ftTableView: FTFoldingTableView!) -> Int {
        return titles.count
    }
    
    func ftFoldingTableView(_ ftTableView: FTFoldingTableView!, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return difficulties.count
        case 1:
            return imageGroups.count
        default:
            return 0
        }
    }
    
    func ftFoldingTableView(_ ftTableView: FTFoldingTableView!, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func ftFoldingTableView(_ ftTableView: FTFoldingTableView!, heightForRowAt indexPath: IndexPath!) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 44
        case 1:
            let margin: CGFloat = 5
            let width = (UIScreen.screenWidth() * 0.8 - 5 * margin) / 3
            return width + 2 * margin
        default:
            return 44
        }
    }
    
    func ftFoldingTableView(_ ftTableView: FTFoldingTableView!, titleForHeaderInSection section: Int) -> String! {
        return titles[section]
    }
    
    func ftFoldingTableView(_ ftTableView: FTFoldingTableView!, cellForRowAt indexPath: IndexPath!) -> UITableViewCell! {
        switch indexPath.section {
        case 0:
            let cell = ftTableView.dequeueReusableCell(withIdentifier: difficultyIdentifier, for: indexPath) as! SCPuzzleDifficultyCell
            cell.settingsLabel.text = difficulties[indexPath.row]
            return cell
        case 1:
            let cell = ftTableView.dequeueReusableCell(withIdentifier: imageIdentifier, for: indexPath) as! SCPuzzleImagesCell
            cell.imageNameStrings = imageGroups[indexPath.row]
            cell.delegate = self
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    func ftFoldingTableView(_ ftTableView: FTFoldingTableView!, didSelectRowAt indexPath: IndexPath!) {
        switch indexPath.section {
        case 0:
        selectedDifficulty = handleSelectedDifficulity(with: indexPath.row)
        default:
            break
        }
    }
    func ftFoldingTableView(_ ftTableView: FTFoldingTableView!, backgroundColorForHeaderInSection section: Int) -> UIColor! {
        return InfoCommon.comparisonBarColor
    }
}
extension SCPuzzleSettingsView{
    func setupTableView(){
        tableView.foldingDelegate = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "SCPuzzleDifficultyCell", bundle: nil), forCellReuseIdentifier: difficultyIdentifier)
        tableView.register(UINib(nibName: "SCPuzzleImagesCell", bundle: nil), forCellReuseIdentifier: imageIdentifier)
    }
    
    func showSettingsView(completion:@escaping ()->()){
        addPopHorizontalAnimation(fromValue: -UIScreen.screenWidth() / 2, toValue: UIScreen.screenWidth() / 2, springBounciness: 4, springSpeed: 4, delay: 0) { (_, _) in
            completion()
        }
    }
    func hideSettingsView(completion:(()->())? = nil){
        addPopHorizontalAnimation(fromValue: UIScreen.screenWidth() / 2, toValue: -UIScreen.screenWidth() / 2, springBounciness: 4, springSpeed: 4, delay: 0) { (_, _) in
            if let completion = completion{
                completion()
            }
        }
        delegate?.settingsOption(view: self, difficulty: selectedDifficulty, image: selectedImage)
    }
    func handleSelectedDifficulity(with row: Int)->puzzleLevel{
        switch row {
        case 0:
            return puzzleLevel.veryEasy
        case 1:
            return puzzleLevel.easy
        case 2:
            return puzzleLevel.normal
        case 3:
            return puzzleLevel.hard
        default:
            return puzzleLevel.easy
        }
    }
}
extension SCPuzzleSettingsView: SCPuzzleImagesCellDelegate{
    func didTapImageView(view: SCPuzzleImagesCell, name: String?) {
        cancelAllSettingsSelectedImages()
        guard let name = name else{
            return 
        }
        selectedImage = UIImage(named: name)
    }
}
