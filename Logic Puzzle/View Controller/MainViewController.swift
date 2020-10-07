//
//  MainViewController.swift
//  Logic Puzzle
//
//  Created by Johnny Owayed on 10/6/20.
//  Copyright © 2020 Johnny Owayed. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var button_NewGame: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func newGamePressed(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "PuzzleViewController") as? PuzzleViewController ?? UIViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
