//
//  MainViewController.swift
//  Logic Puzzle
//
//  Created by Johnny Owayed on 10/6/20.
//  Copyright © 2020 Johnny Owayed. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {

    @IBOutlet weak var button_NewGame: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.buttonActionUsingRx()
    }
    
    func buttonActionUsingRx() {
        self.button_NewGame.rx.controlEvent(.touchUpInside).subscribe(onNext: {
            let vc = self.storyboard?.instantiateViewController(identifier: "PuzzleViewController") as? PuzzleViewController ?? UIViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
    }
}
