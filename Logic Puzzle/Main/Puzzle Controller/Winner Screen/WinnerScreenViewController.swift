//
//  WinnerViewController.swift
//  Logic Puzzle
//
//  Created by Johnny Owayed on 11/2/20.
//  Copyright © 2020 Johnny Owayed. All rights reserved.
//

import UIKit

class WinnerScreenViewController: UIViewController {

    @IBOutlet weak var label_CongratsText: UILabel!
    @IBOutlet weak var button_NextGame: UIButton!
    @IBOutlet var imageView_Gif: UIImageView!
    
    var finishingTime = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.label_CongratsText.text = "Congrats!\n\(finishingTime["minutes"] ?? ""):\(finishingTime["seconds"] ?? "")"
        self.label_CongratsText.numberOfLines = 4
        self.button_NextGame.setTitle("Main Menu", for: .normal)
        self.imageView_Gif.image = UIImage.init(named: "winner_Image")
    }
}
