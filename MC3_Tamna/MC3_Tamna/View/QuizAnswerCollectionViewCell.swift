//
//  QuizAnswerCollectionViewCell.swift
//  MC3
//
//  Created by MBSoo on 2022/07/12.
//

import UIKit

class QuizAnswerCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "QuizAnswerCollectionViewCell"
    // cell을 재활용할 때 사용하는 identifier
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(quizAnswerButtonView)
        quizAnswerButtonView.isUserInteractionEnabled = false
        // quizAnswerButtonView가 button인데, collectionview 자체에서도 사용자의 터치 입력을 받아들이고 있었다..
        // 해당 문제로 isSelected가 이상하게 작동해서, 버튼의 유저인터랙션을 막았더니 해결됐다 !
        
    }
    
    override var isSelected: Bool {
        // cell이 눌렸는지 확인하는 변수(override)
        // isSelected == true -> 사용자가 누른 상태
        // isSelected == false -> 사용자가 안 누른 상태
        didSet {
            // property observer 값이 바뀐 직후 실행된다 !
            if !isSelected {
                clickCount = 0
                quizAnswerButtonView.layer.borderColor = UIColor.clear.cgColor
                quizAnswerButtonView.layer.borderWidth = 0
                
            } else {
                
            }
        }
    }
    var clickCount: Int = 0 {
        // 해당 cell이 눌린 상태인지 확인하는 변수, 해당 값을 초기화하는 함수는 QuizViewController의 delegate에 존재.
        // clickCount == 1 -> 눌린 상태
        didSet {
            if clickCount == 1 {
                quizAnswerButtonView.layer.borderWidth = 4
                quizAnswerButtonView.layer.borderColor = UIColor.red.cgColor
            } else {
                
            }
        }
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    let quizAnswerButtonView: UIButton  =  {
        var quizButton: UIButton = UIButton()
        quizButton.backgroundColor = UIColor.brown
        return quizButton
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        quizAnswerButtonView.frame = contentView.bounds
    }
}
