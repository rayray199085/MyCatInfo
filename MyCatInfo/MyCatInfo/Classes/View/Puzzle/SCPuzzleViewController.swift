//
//  SCPuzzleViewController.swift
//  MyCatInfo
//
//  Created by Stephen Cao on 3/8/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import UIKit

class SCPuzzleViewController: UIViewController {
    private var puzzleView: SlidingPuzzleView?
    private lazy var settingsView = SCPuzzleSettingsView.settingsView()
    private let imagePickerController = UIImagePickerController()
    private var photoLibraryImage: UIImage?
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var hintImageView: UIImageView!{
        didSet{
            hintImageView.image = UIImage(named: "cat_sample")?.modifyImageSize(newSize: hintImageView.bounds.size, cornerRadius: 10)
        }
    }
    @IBOutlet weak var displayView: UIView!{
        didSet{
            // first time init puzzle view, level: default, image: default
            configPuzzleView(image: UIImage(named: "cat_sample"))
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationItem()
        setupImagePickerController()
    }
    
    @objc private func didClickShuffleButton(){
        puzzleView?.shufflePieces()
        countLabel.text = "0"
    }
    
    @objc private func didClickSettingsButton(){
        showSettingsView()
        
    }
    @IBAction func clickUploadButton(_ sender: Any) {
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc private func didLongPressOnView(recognizer: UILongPressGestureRecognizer){
        switch recognizer.state {
        case .began:
            hintImageView.isHidden = false
        case .failed, .ended, .cancelled:
            hintImageView.isHidden = true
        default:
            break
        }
    }
    @objc private func didSwipeRightOnView(recognizer: UISwipeGestureRecognizer){
        switch recognizer.state {
        case .ended:
            showSettingsView()
        default:
            break
        }
    }
}
extension SCPuzzleViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let selectedImage = info[.originalImage] as? UIImage else {
                return
            }
            photoLibraryImage = selectedImage
            // record current level
            let prevDifficulty = puzzleView?.level ?? .easy
            configPuzzleView(difficulty: prevDifficulty, image: photoLibraryImage)
            picker.dismiss(animated: true)
            // clear previous settings selected image
            settingsView.cancelAllSettingsSelectedImages()
    }
}
extension SCPuzzleViewController: SCPuzzleSettingsViewDelegate{
    func settingsOption(view: SCPuzzleSettingsView, difficulty: puzzleLevel, image: UIImage?) {
        if difficulty == puzzleView?.level{
            if image == nil{
                return
            }
            else if image == puzzleView?.puzzleImage{
                return
            }
        }
        let currentImage = image != nil ? image : puzzleView?.puzzleImage
        configPuzzleView(difficulty: difficulty, image: currentImage)
    }
}

private extension SCPuzzleViewController{
    func setupUI(){
        hintImageView.isHidden = true
        
        navigationController?.view.addSubview(settingsView)
        settingsView.center.x = -UIScreen.screenWidth() / 2
        settingsView.delegate = self
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didLongPressOnView))
        longPressRecognizer.minimumPressDuration = 0.5
        view.addGestureRecognizer(longPressRecognizer)
        
        let swipeRightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeRightOnView))
        swipeRightRecognizer.direction = .right
        view.addGestureRecognizer(swipeRightRecognizer)
        
    }
    
    func setupNavigationItem(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Shuffle", fontSize: 16, target: self, action: #selector(didClickShuffleButton), isBack: false)
        navigationItem.leftBarButtonItem = UIBarButtonItem(normalImageName: "settings", highlightedImageName: "settings_highlighted", target: self, action: #selector(didClickSettingsButton))
    }
    
    func configPuzzleView(difficulty: puzzleLevel = .easy, image: UIImage?){
        // reset puzzle view
        puzzleView?.removeFromSuperview()
        puzzleView = nil
        
        let margin: CGFloat = 3
        let width = UIScreen.screenWidth() - 2 * margin
        puzzleView = SlidingPuzzleView(frame: CGRect(x: 0, y: 0, width: width, height: width))
        puzzleView!.level = difficulty
        puzzleView!.puzzleImage = image != nil ? image : UIImage(named: "cat_sample")
        puzzleView!.pieceBorderColor = InfoCommon.barColor
        puzzleView!.backgroundColor = .lightGray
        
        puzzleView!.delegate = self
        displayView.addSubview(puzzleView!)
        puzzleView!.startPuzzle()
        
        hintImageView?.image = puzzleView!.puzzleImage?.modifyImageSize(newSize: hintImageView?.bounds.size ?? .zero, cornerRadius: 10)
        countLabel.text = "0"
    }
    
    func setupImagePickerController(){
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
    }
    func showSettingsView(){
        navigationItem.leftBarButtonItem?.isEnabled = false
        settingsView.showSettingsView { [weak self] in
            self?.navigationItem.leftBarButtonItem?.isEnabled = true
        }
    }
}
extension SCPuzzleViewController: puzzleDelegate{
    func puzzleComplete(view: SlidingPuzzleView) {
        let alert = UIAlertController(title: "Congratulations! You have won!", message: "", preferredStyle: UIAlertController.Style.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Play again", style: UIAlertAction.Style.default, handler: { (_) in
            self.didClickShuffleButton()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (_) in
        }))
        present(alert, animated: true, completion: nil)
    }

    func puzzleSwapCount(view: SlidingPuzzleView, count: Int) {
        countLabel.text = "\(count)"
    }
}
