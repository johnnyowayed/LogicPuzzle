//
//  ViewController.swift
//  Logic Puzzle
//
//  Created by Johnny Owayed on 7/30/20.
//  Copyright © 2020 Johnny Owayed. All rights reserved.
//

import UIKit
import SnapKit
import AudioToolbox
import RxSwift
import RxCocoa

class PuzzleViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var label_Equations: UILabel!
    @IBOutlet weak var imageView_Bracket: UIImageView!
    @IBOutlet weak var label_Equations2: UILabel!
    @IBOutlet weak var imageView_Bracket2: UIImageView!
    @IBOutlet weak var view_EquationSet1: UIView!
    @IBOutlet weak var view_EquationSet2: UIView!
    @IBOutlet weak var label_Timer: UILabel!
    @IBOutlet weak var button_Undo: UIButton!
    @IBOutlet weak var button_Redo: UIButton!
    @IBOutlet weak var button_Pause: UIButton!
    
    var gridItemDimension = 0
    var puzzleModel = PuzzleModel()
    var correctIndices = [IndexPath]()
    var wrongIndices = [IndexPath]()
    var automaticWrongIndices = [IndexPath]()
    var emptyIndices = [IndexPath]()
    var previousGrid = [[Int]]()
    var satisfiedEquationIndices = Set<Int>()
    var gridSize = 0
    var barButtonTheme:UIBarButtonItem!
    var timerIsPaused: Bool = true
     
    var timer: Timer? = nil
    var seconds = 0
    var minutes = 0
    var hours = 0
    
    var array_UndoProgress = [[[Int]]]()
    var array_RedoProgress = [[[Int]]]()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.alpha = 0
                    
        self.setupUI()
        self.buildGrid()
        self.startTimer()
    }
    
    func setupUI() {
        self.puzzleModel = PuzzleLogic.createDummyData()
        self.gridSize = PuzzleLogic.fetchGridSize(puzzleModel: self.puzzleModel)
        self.label_Timer.font = self.label_Timer.font.monospacedDigitFont
        self.setupNavBar()
        self.gridItemDimension = PuzzleLogic.calculateGridDimentions(gridSize: GridSize(rawValue: self.gridSize) ?? .grid4x4)
        self.fillEquations()
    }
    
    func setupNavBar() {
        
        self.title = PuzzleLogic.fetchPuzzleTitle(gridSize: GridSize(rawValue: self.gridSize) ?? GridSize.grid4x4)
        let changeColor = UIButton(type: .custom)
        let settings = UIButton(type: .custom)
        changeColor.setImage(UIImage(named:"paint-palette"), for: .normal)
        changeColor.addTarget(self, action: #selector(ChangeColorButtonPressed), for: .touchUpInside)
        changeColor.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        
        settings.setImage(UIImage(named:"settings"), for: .normal)
        settings.addTarget(self, action: #selector(settingsButtonPressed), for: .touchUpInside)
//        settings.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        
        self.barButtonTheme = UIBarButtonItem(customView: changeColor)
        let barButtonSettings = UIBarButtonItem(customView: settings)
        self.navigationItem.rightBarButtonItems = [barButtonSettings, self.barButtonTheme]
    }
    
    @objc func ChangeColorButtonPressed() {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PopoverViewController")
        vc.modalPresentationStyle = .popover
        let popover: UIPopoverPresentationController = vc.popoverPresentationController!
        popover.barButtonItem = self.barButtonTheme
        present(vc, animated: true, completion:nil)
    }
    
    @objc func settingsButtonPressed() {
        print("Settings")
    }
    
    func fillEquations(indicesSatisfiedEquations:[Int]? = nil) {
        
        var attributedText1 = NSMutableAttributedString.init(string: "")
        var attributedText2 = NSMutableAttributedString.init(string: "")
        
        self.label_Equations.font = UIFont.systemFont(ofSize: 16)
        self.label_Equations2.font = UIFont.systemFont(ofSize: 16)
        
        var textColor = UIColor.black
        if traitCollection.userInterfaceStyle == .dark {
            textColor = .white
        }
        
        if self.puzzleModel.equations.count < 5 {
            for i in 0...self.puzzleModel.equations.count-1 {
                attributedText1.append(self.puzzleModel.equations[i].attributedString().addAttribute(withTextColor: textColor).text())
                attributedText1.append(NSAttributedString.init(string: "\n"))
                
                if !(indicesSatisfiedEquations?.isEmpty ?? true){
                    for index in indicesSatisfiedEquations ?? [0]{
                        if index == i {
                            attributedText1 = NSMutableAttributedString.init(attributedString: attributedText1.attributedString().addAttribute(forSubstring: self.puzzleModel.equations[i], withTextColor: .systemGreen).text())
                        }
                    }
                }
            }
            
            attributedText1.trimCharactersInSet(charSet: .newlines)
            self.label_Equations.numberOfLines = self.puzzleModel.equations.count
            self.label_Equations.attributedText = attributedText1
            self.view_EquationSet2.isHidden = true
        }else {
            
            let equations = self.puzzleModel.equations ?? [String]()
            var numberofLines1 = 0
            var numberofLines2 = 0
            
            for i in 0...(equations.count-1)/2 {
                numberofLines1 = numberofLines1 + 1
                attributedText1.append(self.puzzleModel.equations[i].attributedString().addAttribute(withTextColor: textColor).text())
                attributedText1.append(NSAttributedString.init(string: "\n"))
                
                if !(indicesSatisfiedEquations?.isEmpty ?? true){
                    for index in indicesSatisfiedEquations ?? [0]{
                       
                        if index == i {
                            attributedText1 = NSMutableAttributedString.init(attributedString: attributedText1.attributedString().addAttribute(forSubstring: self.puzzleModel.equations[i], withTextColor: .systemGreen).text())
                        }
                    }
                }
            }
            
            for j in ((equations.count-1)/2)+1...equations.count-1 {
                numberofLines2 = numberofLines2 + 1
                attributedText2.append(self.puzzleModel.equations[j].attributedString().addAttribute(withTextColor: textColor).text())
                attributedText2.append(NSAttributedString.init(string: "\n"))
                
                if !(indicesSatisfiedEquations?.isEmpty ?? true){
                    for index in indicesSatisfiedEquations ?? [0]{
                        if index == j {
                            attributedText2 = NSMutableAttributedString.init(attributedString: attributedText2.attributedString().addAttribute(forSubstring: self.puzzleModel.equations[j], withTextColor: .systemGreen).text())
                        }
                    }
                }
            }
            
            attributedText1.trimCharactersInSet(charSet: .newlines)
            attributedText2.trimCharactersInSet(charSet: .newlines)
            self.label_Equations.numberOfLines = numberofLines1
            self.label_Equations2.numberOfLines = numberofLines2
            self.label_Equations.attributedText = attributedText1
            self.label_Equations2.attributedText = attributedText2
        }
    }
    
    func buildGrid() {
        for _ in 0..<self.gridSize {
            var array_NumberofRows = [Int]()
            for _ in 0...self.gridSize-1 {
                array_NumberofRows.append(Answer.Empty.rawValue)
            }
            self.puzzleModel.puzzleProgress.append(array_NumberofRows)
        }
        
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.isScrollEnabled = false
        if traitCollection.userInterfaceStyle == .dark {
            self.imageView_Bracket.tintColor = UIColor.lightGray
            self.imageView_Bracket2.tintColor = UIColor.lightGray
            self.collectionView.layer.borderColor = UIColor.lightGray.cgColor
        }else{
            self.imageView_Bracket.tintColor = UIColor.black
            self.imageView_Bracket2.tintColor = UIColor.black
            self.collectionView.layer.borderColor = UIColor.black.cgColor
        }
        self.collectionView.layer.borderWidth = 1
        self.collectionView.snp.makeConstraints { (make) in
            make.height.width.equalTo(self.gridSize*gridItemDimension)
//            make.centerX.equalToSuperview()
//            make.bottom.equalTo(-self.collectionView.bounds.width)
        }
        
        UIView.animate(withDuration: 2) {
            self.collectionView.alpha = 1
        }

        self.buildLettersStack()
        self.buildNumbersStack()
    }
    
    
    @IBAction func undo() {
        self.undofnc()
    }
    
    func undofnc() {
        if self.array_UndoProgress.count > 1 {
            self.puzzleModel.puzzleProgress = self.array_UndoProgress[self.array_UndoProgress.count-2]
            self.array_RedoProgress.append(self.array_UndoProgress.last ?? [[Int]]())
            self.array_UndoProgress.removeLast()
            self.collectionView.reloadData()
        }else if self.array_UndoProgress.count == 1{
            self.puzzleModel.puzzleProgress = PuzzleLogic.clearPuzzleProgress(puzzleModel: self.puzzleModel)
            self.array_RedoProgress.append(self.array_UndoProgress.last ?? [[Int]]())
            self.array_UndoProgress.removeAll()
            self.collectionView.reloadData()
        }else {
            print("Nothing to Undo")
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
    
    @IBAction func redo() {
        
    }
    
    @IBAction func restart() {
        self.puzzleModel.puzzleProgress = PuzzleLogic.clearPuzzleProgress(puzzleModel: self.puzzleModel)
        self.array_UndoProgress.removeAll()
        self.array_RedoProgress.removeAll()
        self.fillEquations()
        self.collectionView.reloadData()
        self.restartTimer()
    }
    
    func buildLettersStack() {
        let stackView_Letters = UIStackView()
        self.view.addSubview(stackView_Letters)
        
        for i in 1...self.gridSize {
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
        
        for i in 1...self.gridSize {
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
    
    func startTimer(){
        timerIsPaused = false
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ [self] tempTimer in
            if self.seconds == 59 {
                self.seconds = 0
                if self.minutes == 59 {
                    self.minutes = 0
                    self.hours = self.hours + 1
                } else {
                    self.minutes = self.minutes + 1
                }
            } else {
                self.seconds = self.seconds + 1
            }
            
            self.label_Timer.text = String(format: "%02d:%02d", self.minutes, self.seconds)
        }
    }
    
    func restartTimer() {
        self.timer?.invalidate()
        self.seconds = 0
        self.minutes = 0
        self.hours = 0
        self.label_Timer.text = String(format: "%02d:%02d", self.minutes, self.seconds)
        self.startTimer()
    }
}

extension PuzzleViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        (cell.viewWithTag(1))?.translatesAutoresizingMaskIntoConstraints = false
        (cell.viewWithTag(1))?.snp.makeConstraints({ (make) in
            make.width.height.equalTo(gridItemDimension)
        })
        
        let puzzleProgress = self.puzzleModel.puzzleProgress?[indexPath.row][indexPath.section]
        
        if puzzleProgress == Answer.Correct.rawValue {
            (cell.viewWithTag(2) as? UIImageView)?.image = UIImage.init(named: "correct")
            (cell.viewWithTag(2) as? UIImageView)?.tintColor = .systemGreen
        }else if puzzleProgress == Answer.Wrong.rawValue || puzzleProgress == Answer.AutomaticWrong.rawValue{
            (cell.viewWithTag(2) as? UIImageView)?.image = UIImage.init(named: "wrong")
            (cell.viewWithTag(2) as? UIImageView)?.tintColor = .red
        }else{
            (cell.viewWithTag(2) as? UIImageView)?.image = nil
        }

        cell.setOnTapListner {
            self.array_RedoProgress.removeAll()
            let row = PuzzleLogic.fetchRowAt(indexPath.section, puzzleModel:self.puzzleModel)
            let column = PuzzleLogic.fetchColumnAt(indexPath.row, puzzleModel:self.puzzleModel)
            var variableValue = [String:Int]()

            if (!row.contains(Answer.Empty.rawValue) || !column.contains(Answer.Empty.rawValue)) && (cell.viewWithTag(2) as? UIImageView)?.image == UIImage.init(named: "wrong"){
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            }else{
                self.correctIndices = PuzzleLogic.indicesOf(Answer.Correct.rawValue, puzzleModel:self.puzzleModel)
                self.wrongIndices = PuzzleLogic.indicesOf(Answer.Wrong.rawValue, puzzleModel:self.puzzleModel)
                self.automaticWrongIndices = PuzzleLogic.indicesOf(Answer.AutomaticWrong.rawValue, puzzleModel:self.puzzleModel)
                self.emptyIndices = PuzzleLogic.indicesOf(Answer.Empty.rawValue, puzzleModel:self.puzzleModel)
                variableValue = PuzzleLogic.fromCorrectIndicesToEquationVariables(correctIndices: self.correctIndices, puzzleModel: self.puzzleModel)
                if (cell.viewWithTag(2) as? UIImageView)?.image == nil && !PuzzleLogic.isAllWrongExceptOne(indexPath, puzzleModel: self.puzzleModel){
                    self.puzzleModel.puzzleProgress?[indexPath.row][indexPath.section] = Answer.Wrong.rawValue
                    (cell.viewWithTag(2) as? UIImageView)?.image = UIImage.init(named: "wrong")
                    (cell.viewWithTag(2) as? UIImageView)?.tintColor = .red
                    
                }else if (cell.viewWithTag(2) as? UIImageView)?.image == UIImage.init(named: "wrong") || PuzzleLogic.isAllWrongExceptOne(indexPath, puzzleModel: self.puzzleModel) {
                    for i in 0...self.gridSize-1{
                        if self.puzzleModel.puzzleProgress?[indexPath.row][i] == Answer.Empty.rawValue {
                            self.puzzleModel.puzzleProgress?[indexPath.row][i] = Answer.AutomaticWrong.rawValue
                        }else if self.puzzleModel.puzzleProgress?[indexPath.row][i] == Answer.Wrong.rawValue{
                            self.puzzleModel.puzzleProgress?[indexPath.row][i] = Answer.Wrong.rawValue
                        }
                        if let cell = self.getCellAtIndex(IndexPath.init(row: indexPath.row, section: i)) {
                            
                            (cell.viewWithTag(2) as? UIImageView)?.image = UIImage.init(named: "wrong")
                            (cell.viewWithTag(2) as? UIImageView)?.tintColor = .red
                        }
                    }
                    for j in 0...self.gridSize-1{
                        if self.puzzleModel.puzzleProgress?[j][indexPath.section] == Answer.Empty.rawValue {
                            self.puzzleModel.puzzleProgress?[j][indexPath.section] = Answer.AutomaticWrong.rawValue
                        }else if self.puzzleModel.puzzleProgress?[j][indexPath.section] == Answer.Wrong.rawValue{
                            self.puzzleModel.puzzleProgress?[j][indexPath.section] = Answer.Wrong.rawValue
                        }
                        if let cell = self.getCellAtIndex(IndexPath.init(row: j, section: indexPath.section)) {
                            (cell.viewWithTag(2) as? UIImageView)?.image = UIImage.init(named: "wrong")
                            (cell.viewWithTag(2) as? UIImageView)?.tintColor = .red
                        }
                    }
                    self.puzzleModel.puzzleProgress?[indexPath.row][indexPath.section] = Answer.Correct.rawValue
                    (cell.viewWithTag(2) as? UIImageView)?.image = UIImage.init(named: "correct")
                    (cell.viewWithTag(2) as? UIImageView)?.tintColor = .systemGreen
                    self.emptyIndices = PuzzleLogic.indicesOf(Answer.Empty.rawValue, puzzleModel:self.puzzleModel)
                    self.correctIndices = PuzzleLogic.indicesOf(Answer.Correct.rawValue, puzzleModel:self.puzzleModel)
                    variableValue = PuzzleLogic.fromCorrectIndicesToEquationVariables(correctIndices: self.correctIndices, puzzleModel: self.puzzleModel)
                    self.satisfiedEquationIndices = Set(PuzzleLogic.resturnSatisfiedEquationIndex(equations: self.puzzleModel.equations, dictionary: variableValue))
                    if PuzzleLogic.checkIfWinner(satisfiedEquationsCount: self.satisfiedEquationIndices.count, puzzleModel: self.puzzleModel) && self.emptyIndices.isEmpty{
                        //Show winner screen
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WinnerScreenViewController") as! WinnerScreenViewController
                        vc.finishingTime = ["minutes": self.minutes
                                            ,"seconds":self.seconds]
                        self.present(vc, animated: true) {
                            self.navigationController?.popViewController(animated: false)
                        }
                    }
                    
                }else if (cell.viewWithTag(2) as? UIImageView)?.image == UIImage.init(named: "correct") {
                    self.emptyIndices = PuzzleLogic.indicesOf(Answer.Empty.rawValue, puzzleModel: self.puzzleModel)
                    self.puzzleModel.puzzleProgress?[indexPath.row][indexPath.section] = Answer.Empty.rawValue
                    self.correctIndices = PuzzleLogic.indicesOf(Answer.Correct.rawValue, puzzleModel:self.puzzleModel)
                    self.automaticWrongIndices = PuzzleLogic.indicesOf(Answer.AutomaticWrong.rawValue, puzzleModel:self.puzzleModel)
                    self.wrongIndices = PuzzleLogic.indicesOf(Answer.Wrong.rawValue, puzzleModel:self.puzzleModel)
                    (cell.viewWithTag(2) as? UIImageView)?.image = nil
                    var exIndicesToBeRemoved = [IndexPath]()
                    
                    exIndicesToBeRemoved = PuzzleLogic.exIndicesToBeRemoved(wrongIndices: self.wrongIndices, automaticWrongIndices: self.automaticWrongIndices, correctIndices: self.correctIndices, emptyIndices: self.emptyIndices, removedIndex: indexPath)
                    variableValue = PuzzleLogic.fromCorrectIndicesToEquationVariables(correctIndices: self.correctIndices, puzzleModel: self.puzzleModel)
                    self.satisfiedEquationIndices = Set(PuzzleLogic.resturnSatisfiedEquationIndex(equations: self.puzzleModel.equations, dictionary: variableValue))
                    
                    if !exIndicesToBeRemoved.isEmpty {
                        for exIndexToBeRemoved in exIndicesToBeRemoved {
                            self.puzzleModel.puzzleProgress?[exIndexToBeRemoved.row][exIndexToBeRemoved.section] = Answer.Empty.rawValue
                            if let cell = self.getCellAtIndex(IndexPath.init(row: exIndexToBeRemoved.row, section: exIndexToBeRemoved.section)) {
                                (cell.viewWithTag(2) as? UIImageView)?.image = nil
                            }
                        }
                    }
                }
                self.satisfiedEquationIndices = self.satisfiedEquationIndices.filter(){$0 != -1}
                self.fillEquations(indicesSatisfiedEquations: Array(self.satisfiedEquationIndices))
            }
            
            self.array_UndoProgress.append(self.puzzleModel.puzzleProgress)
        }
        
        cell.layer.borderWidth = 0.5
        
        if traitCollection.userInterfaceStyle == .dark {
            cell.layer.borderColor = UIColor.lightGray.cgColor
        }else{
            cell.layer.borderColor = UIColor.black.cgColor
        }
        return cell
    }
    
    func updateEquationStatus() {
        
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

// Mark: IBActions
extension PuzzleViewController {
    
    func buttonActionUsingRx() {
        
        self.button_Undo.rx.controlEvent(.touchUpInside).subscribe(onNext: {
            self.undofnc()
        }).disposed(by: disposeBag)
        
        self.button_Redo.rx.controlEvent(.touchUpInside).subscribe(onNext: {
            if !self.array_RedoProgress.isEmpty {
                self.puzzleModel.puzzleProgress = self.array_RedoProgress.last
                self.array_UndoProgress.append(self.array_RedoProgress.last ?? [[Int]]())
                self.array_RedoProgress.removeLast()
                self.collectionView.reloadData()
            }else{
                print("Nothing to Redo")
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
        }).disposed(by: disposeBag)
        
        self.button_Pause.rx.controlEvent(.touchUpInside).subscribe(onNext: {
            self.timer?.invalidate()
            if !UIAccessibility.isReduceTransparencyEnabled {
                self.view.backgroundColor = .clear
                
                let blurEffect = UIBlurEffect(style: .extraLight)
                let blurEffectView = UIVisualEffectView(effect: blurEffect)
                blurEffectView.frame = self.view.bounds
                blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                self.view.addSubview(blurEffectView)
                
                let button = UIButton(frame: CGRect(x: self.view.frame.size.width/2 - 70/2, y: self.view.frame.size.height/2 - 70/2, width: 70, height: 70))
                button.setImage(UIImage.init(named: "play"), for: .normal)
                button.tintColor = .lightGray
                self.view.insertSubview(button, aboveSubview: blurEffectView)
                
                button.setOnTapListner {
                    blurEffectView.removeFromSuperview()
                    button.removeFromSuperview()
                    self.view.backgroundColor = .white
                    self.startTimer()
                }
            } else {
                self.view.backgroundColor = .black
            }
        }).disposed(by: disposeBag)
    }
}

