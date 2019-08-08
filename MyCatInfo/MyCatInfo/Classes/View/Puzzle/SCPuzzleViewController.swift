//
//  SCPuzzleViewController.swift
//  MyCatInfo
//
//  Created by Stephen Cao on 3/8/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import UIKit

class SCPuzzleViewController: UIViewController {

    private var puzzleView: SlidingPuzzleView!{
        didSet{
            puzzleView.level = .veryEasy
            puzzleView.puzzleImage = UIImage(named: "cll")
            puzzleView.delegate = self
            puzzleView.pieceBorderColor = InfoCommon.barColor
            puzzleView.startPuzzle()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if puzzleView == nil {
            let width = UIScreen.screenWidth() - 3
            puzzleView = SlidingPuzzleView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: width)))
            puzzleView.center = view.center
            view.addSubview(puzzleView)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
extension SCPuzzleViewController: puzzleDelegate{
    func puzzleComplete(view: SlidingPuzzleView) {
        print("complete")
    }
    
    func puzzleSwapCount(view: SlidingPuzzleView, count: Int) {
        
    }
    
    
}
