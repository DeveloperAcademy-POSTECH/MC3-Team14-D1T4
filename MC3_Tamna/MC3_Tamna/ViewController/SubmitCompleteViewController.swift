//
//  SubmitCompleteViewController.swift
//  MC3
//
//  Created by MBSoo on 2022/07/13.
//

import UIKit

class SubmitCompleteViewController: UIViewController {
    
    var quiz: Quiz?
    var animal: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        view.addSubview(successImage)
        view.addSubview(success)
        view.addSubview(endButton)
        success.text = """
            정답은: \(quiz?.answer[quiz?.rightAnswerIndex ?? 0] ?? "")
            돌고래 너무 귀엽죠 ~~
            돌고래 완전 굿 굿!
            돌고래와 함께 춤을...
        """
        NSLayoutConstraint.activate([
            successImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            successImage.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 250),
            successImage.widthAnchor.constraint(equalToConstant: view.frame.width - 100)
        ])
        NSLayoutConstraint.activate([
            success.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            success.centerYAnchor.constraint(equalTo: successImage.bottomAnchor, constant: 200),
            success.widthAnchor.constraint(equalToConstant: view.frame.width - 100),
            success.heightAnchor.constraint(equalToConstant: 40 * 4)
        ])
        NSLayoutConstraint.activate([
            endButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            endButton.centerYAnchor.constraint(equalTo: success.bottomAnchor, constant: 200),
            endButton.widthAnchor.constraint(equalToConstant: view.frame.width - 100),
            endButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
    }
    
    private let successImage: UIImageView = {
        // 성공시 띄워줄 이미지
        var image = UIImage(named: "dolphin")
        image = image?.withRenderingMode(.alwaysOriginal)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let success:UITextView = {
        // 퀴즈에 대한 해설이 있는 텍스트 뷰
       let success = UITextView()
        success.text = ""
        success.isEditable = false
        success.textColor = UIColor.systemBrown
        success.font = UIFont.systemFont(ofSize: 25)
        success.textAlignment = .center
        success.backgroundColor = UIColor.systemGray4
        success.layer.cornerRadius = 20
        success.translatesAutoresizingMaskIntoConstraints = false
        
        return success
    }()
    
    private lazy var endButton: UIButton = {
        // 해설을 전부 보고, 나가는 버튼
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.titleLabel?.textColor = .white
        button.backgroundColor = UIColor.systemBrown
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // FIXME: func didClearQuizID did not work
    
    @objc private func clearButtonTapped() {
        UserDefaults.standard.set(quiz!.id, forKey: animal ?? "panda")
        print("버킬: \(quiz?.id)")
        print("버킬: \(animal)")
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: StarViewController.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
        }
        // reference: https://stackoverflow.com/questions/30003814/how-can-i-pop-specific-view-controller-in-swift
         }
    //notification center
}
