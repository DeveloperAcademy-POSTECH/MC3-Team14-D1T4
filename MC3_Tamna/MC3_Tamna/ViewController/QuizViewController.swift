//
//  QuizViewController.swift
//  MC3_Tamna
//
//  Created by Hyeonsoo Kim on 2022/07/17.
//

import UIKit

protocol QuizDelegate {
    func didClearQuizID(id clearQuiz: Int)
}

class QuizViewController: UIViewController {
    
    var quiz: Quiz?
    
    var delegate: QuizDelegate?
    
    private lazy var clearButton: UIButton = {
        let button = UIButton()
        button.setTitle("Clear !!!", for: .normal)
        button.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        button.titleLabel?.font = .systemFont(ofSize: 30, weight: .black)
        button.titleLabel?.textColor = .label
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        view.addSubview(clearButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        clearButton.frame = view.bounds
    }
    
    @objc private func clearButtonTapped() {
        if let quiz = quiz {
            // 정답 맞췄을 때, 이런 식으로 건네주면 될 것 같다.
            delegate?.didClearQuizID(id: quiz.id)
        }
        navigationController?.popViewController(animated: true)
    }
}
