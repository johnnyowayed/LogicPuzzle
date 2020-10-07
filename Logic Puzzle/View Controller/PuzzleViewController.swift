//
//  ViewController.swift
//  Logic Puzzle
//
//  Created by Johnny Owayed on 7/30/20.
//  Copyright © 2020 Johnny Owayed. All rights reserved.
//

import UIKit
import SnapKit
import GestureRecognizerClosures
import AudioToolbox

class PuzzleViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var gridItemDimension = 40
    var gridSize = 4
    var puzzleModel = PuzzleModel()
    var correctIndices = [IndexPath]()
    var wrongIndices = [IndexPath]()
    var emptyIndices = [IndexPath]()
    var previousGrid = [[Int]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.alpha = 0
        self.setupUI()
        self.buildGrid()
        
        
        let pzMod = Utils.createDummyData()
        let puzModArray = Utils.fromDictionaryToArrayOfIntegers(puzzleModel: pzMod)
        print("PuzMod: \(puzModArray)")
        
        
    }
    
    func setupUI() {
        self.puzzleModel.gridSize = self.gridSize
        self.title = "\(self.puzzleModel.gridSize!)x\(self.puzzleModel.gridSize!)"
    }
    
    func buildGrid() {
        for _ in 0..<self.puzzleModel.gridSize {
            var array_NumberofRows = [Int]()
            for _ in 0...self.puzzleModel.gridSize-1 {
                array_NumberofRows.append(Answer.Empty.rawValue)
            }
            self.puzzleModel.puzzleProgress.append(array_NumberofRows)
        }
        
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.isScrollEnabled = false
        if traitCollection.userInterfaceStyle == .dark {
            self.collectionView.layer.borderColor = UIColor.lightGray.cgColor
        }else{
            self.collectionView.layer.borderColor = UIColor.black.cgColor
        }
        self.collectionView.layer.borderWidth = 1
        self.collectionView.snp.makeConstraints { (make) in
            make.height.width.equalTo(self.puzzleModel.gridSize*gridItemDimension)
            make.center.equalToSuperview()
        }
        
        UIView.animate(withDuration: 2) {
            self.collectionView.alpha = 1
        }

        self.buildLettersStack()
        self.buildNumbersStack()
    }
    
    func buildLettersStack() {
        let stackView_Letters = UIStackView()
        self.view.addSubview(stackView_Letters)
        
        for i in 1...self.self.puzzleModel.gridSize {
            let label = UILabel()
            label.text = "\(i)".numbersToLetters()
            label.textAlignment = .center
            stackView_Letters.addArrangedSubview(label)
        }
        
        stackView_Letters.distribution = .fillEqually
        stackView_Letters.axis = .vertical
        stackView_Letters.spacing = 0
        stackView_Letters.alpha = 0
        
        stackView_Letters.snp.makeConstraints { (make) in
            make.top.equalTo(self.collectionView)
            make.bottom.equalTo(self.collectionView)
            make.left.equalTo(self.collectionView).offset(-20)
        }
        
        UIView.animate(withDuration: 2) {
            stackView_Letters.alpha = 1
        }
    }
    
    func buildNumbersStack() {
        let stackView_Numbers = UIStackView()
        self.view.addSubview(stackView_Numbers)
        
        for i in 1...self.self.puzzleModel.gridSize {
            let label = UILabel()
            label.text = "\(i)"
            label.textAlignment = .center
            stackView_Numbers.addArrangedSubview(label)
        }
        
        stackView_Numbers.distribution = .fillEqually
        stackView_Numbers.axis = .horizontal
        stackView_Numbers.spacing = 0
        stackView_Numbers.alpha = 0
        stackView_Numbers.snp.makeConstraints { (make) in
            make.right.equalTo(self.collectionView)
            make.left.equalTo(self.collectionView)
            make.top.equalTo(self.collectionView).offset(-25)
        }
        
        UIView.animate(withDuration: 2) {
            stackView_Numbers.alpha = 1
        }
    }
}

extension PuzzleViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        (cell.viewWithTag(1))?.translatesAutoresizingMaskIntoConstraints = false
        (cell.viewWithTag(1))?.snp.makeConstraints({ (make) in
            make.width.height.equalTo(gridItemDimension)
        })
        
        cell.onTap { (_) in
            let row = Utils.fetchRowAt(indexPath.section, puzzleModel:self.puzzleModel)
            let column = Utils.fetchColumnAt(indexPath.row, puzzleModel:self.puzzleModel)
            
            if (!row.contains(Answer.Empty.rawValue) || !column.contains(Answer.Empty.rawValue)) && (cell.viewWithTag(2) as? UIImageView)?.image == UIImage.init(named: "wrong"){
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            }else{
                self.correctIndices = Utils.indicesOf(Answer.Correct.rawValue, puzzleModel:self.puzzleModel)
                self.wrongIndices = Utils.indicesOf(Answer.Wrong.rawValue, puzzleModel:self.puzzleModel)
                self.emptyIndices = Utils.indicesOf(Answer.Empty.rawValue, puzzleModel:self.puzzleModel)
                
                if (cell.viewWithTag(2) as? UIImageView)?.image == nil && !Utils.isAllWrongExceptOne(indexPath, puzzleModel: self.puzzleModel){
                    self.puzzleModel.puzzleProgress?[indexPath.row][indexPath.section] = 0
                    (cell.viewWithTag(2) as? UIImageView)?.image = UIImage.init(named: "wrong")
                    (cell.viewWithTag(2) as? UIImageView)?.tintColor = .red
                    
                }else if (cell.viewWithTag(2) as? UIImageView)?.image == UIImage.init(named: "wrong") || Utils.isAllWrongExceptOne(indexPath, puzzleModel: self.puzzleModel) {
                    for i in 0...self.puzzleModel.gridSize-1{
                        self.puzzleModel.puzzleProgress?[indexPath.row][i] = 0
                        if let cell = self.getCellAtIndex(IndexPath.init(row: indexPath.row, section: i)) {
                            
                            (cell.viewWithTag(2) as? UIImageView)?.image = UIImage.init(named: "wrong")
                            (cell.viewWithTag(2) as? UIImageView)?.tintColor = .red
                        }
                    }
                    for j in 0...self.puzzleModel.gridSize-1{
                        self.puzzleModel.puzzleProgress?[j][indexPath.section] = Answer.Wrong.rawValue
                        if let cell = self.getCellAtIndex(IndexPath.init(row: j, section: indexPath.section)) {
                            (cell.viewWithTag(2) as? UIImageView)?.image = UIImage.init(named: "wrong")
                            (cell.viewWithTag(2) as? UIImageView)?.tintColor = .red
                        }
                    }
                    self.puzzleModel.puzzleProgress?[indexPath.row][indexPath.section] = Answer.Correct.rawValue
                    (cell.viewWithTag(2) as? UIImageView)?.image = UIImage.init(named: "correct")
                    (cell.viewWithTag(2) as? UIImageView)?.tintColor = .systemGreen
                    
                }else if (cell.viewWithTag(2) as? UIImageView)?.image == UIImage.init(named: "correct") {
                    self.puzzleModel.puzzleProgress?[indexPath.row][indexPath.section] = Answer.Empty.rawValue
                    (cell.viewWithTag(2) as? UIImageView)?.image = nil
                    
                    var exIndicesToBeRemoved = [IndexPath]()
                    
                    self.correctIndices = Utils.indicesOf(Answer.Correct.rawValue, puzzleModel:self.puzzleModel)
                    self.wrongIndices = Utils.indicesOf(Answer.Wrong.rawValue, puzzleModel:self.puzzleModel)
                    exIndicesToBeRemoved = Utils.exIndicesToBeRemoved(wrongIndices: self.wrongIndices, correctIndices: self.correctIndices, removedIndex: indexPath)
                    
                    if exIndicesToBeRemoved.isEmpty {
                        for i in 0...self.puzzleModel.gridSize-1{
                            self.puzzleModel.puzzleProgress?[indexPath.row][i] = Answer.Empty.rawValue
                            if let cell = self.getCellAtIndex(IndexPath.init(row: indexPath.row, section: i)) {
                                (cell.viewWithTag(2) as? UIImageView)?.image = nil
                            }
                        }
                        for j in 0...self.puzzleModel.gridSize-1{
                            self.puzzleModel.puzzleProgress?[j][indexPath.section] = Answer.Empty.rawValue
                            if let cell = self.getCellAtIndex(IndexPath.init(row: j, section: indexPath.section)) {
                                (cell.viewWithTag(2) as? UIImageView)?.image = nil
                            }
                        }
                    } else {
                        //Magic Begins
                        if !exIndicesToBeRemoved.isEmpty {
                            for exIndexToBeRemoved in exIndicesToBeRemoved {
                                self.puzzleModel.puzzleProgress?[exIndexToBeRemoved.row][exIndexToBeRemoved.section] = Answer.Empty.rawValue
                                if let cell = self.getCellAtIndex(IndexPath.init(row: exIndexToBeRemoved.row, section: exIndexToBeRemoved.section)) {
                                    (cell.viewWithTag(2) as? UIImageView)?.image = nil
                                }
                            }
                        }
                    }
                }
            }
        }
        cell.layer.borderWidth = 0.5
        
        if traitCollection.userInterfaceStyle == .dark {
            cell.layer.borderColor = UIColor.lightGray.cgColor
        }else{
            cell.layer.borderColor = UIColor.black.cgColor
        }
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.puzzleModel.puzzleProgress.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.puzzleModel.puzzleProgress[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func getCellAtIndex(_ index: IndexPath) -> UICollectionViewCell? {
        let cell = self.collectionView.cellForItem(at: index)
        return cell
    }
}

