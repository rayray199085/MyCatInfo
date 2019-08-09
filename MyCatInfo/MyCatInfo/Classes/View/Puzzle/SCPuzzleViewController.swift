//
//  SCPuzzleViewController.swift
//  MyCatInfo
//
//  Created by Stephen Cao on 3/8/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import UIKit

class SCPuzzleViewController: UIViewController {
    private var puzzleView: SlidingPuzzleView!
    private lazy var settingsView = SCPuzzleSettingsView.settingsView()
    private let imagePickerController = UIImagePickerController()
    private var uploadedImage: UIImage?
    @IBOutlet weak var displayView: UIView!{
        didSet{
            configPuzzleView(image: UIImage(named: "cat_sample"))
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationItem()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
    }
    
    @objc private func didClickShuffleButton(){
        puzzleView.shufflePieces()
    }
    
    @objc private func didClickSettingsButton(){
        navigationItem.leftBarButtonItem?.isEnabled = false
        settingsView.showSettingsView { [weak self] in
            self?.navigationItem.leftBarButtonItem?.isEnabled = true
        }
        
    }
    @IBAction func clickUploadButton(_ sender: Any) {
        present(imagePickerController, animated: true, completion: nil)
    }
    
}
extension SCPuzzleViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            return
        }
        uploadedImage = selectedImage
        let prevDifficulty = puzzleView.level
        puzzleView.removeFromSuperview()
        puzzleView = nil
        configPuzzleView(difficulty: prevDifficulty, image: uploadedImage)
        picker.dismiss(animated: true)
        // clear previous settings record
        settingsView.cancelAllSelectedImages()
    }
}
extension SCPuzzleViewController: SCPuzzleSettingsViewDelegate{
    func settingsOption(view: SCPuzzleSettingsView, difficulty: puzzleLevel, image: UIImage?) {
        if difficulty == puzzleView.level && (image == puzzleView.puzzleImage || (puzzleView.puzzleImage == uploadedImage && image == nil) || (image == nil && uploadedImage == nil)){
            return
        }
        let currentImage = image != nil ? image : puzzleView.puzzleImage
        puzzleView.removeFromSuperview()
        puzzleView = nil
        configPuzzleView(difficulty: difficulty, image: currentImage)
    }
}

private extension SCPuzzleViewController{
    func setupUI(){
        navigationController?.view.addSubview(settingsView)
        settingsView.center.x = -UIScreen.screenWidth() / 2
        settingsView.delegate = self
    }
    
    func setupNavigationItem(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Shuffle", fontSize: 16, target: self, action: #selector(didClickShuffleButton), isBack: false)
        navigationItem.leftBarButtonItem = UIBarButtonItem(normalImageName: "settings", highlightedImageName: "settings_highlighted", target: self, action: #selector(didClickSettingsButton))
    }
    
    func configPuzzleView(difficulty: puzzleLevel = .easy, image: UIImage?){
        let margin: CGFloat = 3
        let width = UIScreen.screenWidth() - 2 * margin
        puzzleView = SlidingPuzzleView(frame: CGRect(x: 0, y: 0, width: width, height: width))
        puzzleView.level = difficulty
        puzzleView.puzzleImage = image != nil ? image : UIImage(named: "cat_sample")
        puzzleView.pieceBorderColor = InfoCommon.barColor
        puzzleView.backgroundColor = .lightGray
        
        puzzleView.delegate = self
        displayView.addSubview(puzzleView)
        puzzleView.startPuzzle()
    }
}
extension SCPuzzleViewController: puzzleDelegate{
    func puzzleComplete(view: SlidingPuzzleView) {
        print("complete")
    }

    func puzzleSwapCount(view: SlidingPuzzleView, count: Int) {

    }
}
