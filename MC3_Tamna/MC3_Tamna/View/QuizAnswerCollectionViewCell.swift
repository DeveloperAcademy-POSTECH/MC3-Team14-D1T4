//
//  QuizAnswerCollectionViewCell.swift
//  MC3
//
//  Created by MBSoo on 2022/07/12.
//

import UIKit

class QuizAnswerCollectionViewCell: UICollectionViewCell {
    static let identifier = "QuizAnswerCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(quizAnswerButtonView)
        quizAnswerButtonView.isUserInteractionEnabled = false
        
    }
    
    override var isSelected: Bool {
        didSet {
            if !isSelected{
                clickCount = 0
                quizAnswerButtonView.layer.borderColor = UIColor.clear.cgColor
                quizAnswerButtonView.layer.borderWidth = 0
                
            }else{
                
            }
        }
    }
    var clickCount: Int = 0{
        didSet{
            if clickCount == 1{
                quizAnswerButtonView.layer.borderWidth = 4
                quizAnswerButtonView.layer.borderColor = UIColor.red.cgColor
            }
            else{
                
            }
        }
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    let quizAnswerButtonView: UIButton  =  {
        var quizButton: UIButton = UIButton()
        quizButton.backgroundColor = UIColor.brown
//        quizButton.layer.borderColor =
        return quizButton
    }()
    override func layoutSubviews() {
        super.layoutSubviews()
        quizAnswerButtonView.frame = contentView.bounds
    }
    func setAnswerButtonView(){
        backgroundColor = UIColor.red
        contentView.addSubview(quizAnswerButtonView)
    }
}
