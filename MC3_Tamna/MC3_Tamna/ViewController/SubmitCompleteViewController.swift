//
//  SubmitCompleteViewController.swift
//  MC3
//
//  Created by MBSoo on 2022/07/13.
//

import UIKit

class SubmitCompleteViewController: UIViewController {
    // MARK: Properties
    
    var quiz: Quiz?
    var animal: String?
    
    // MARK: UIComponents
    
    private lazy var successImage: UIImageView = {
        // 성공시 띄워줄 이미지
        var image = UIImage(named: animal ?? "dolphin")
        image = image?.withRenderingMode(.alwaysOriginal)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let success: UITextView = {
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
    
    // MARK: Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        configureSubviews()
        success.text = """
            정답은: \(quiz?.answers[quiz?.rightAnswerIndex ?? 0] ?? "")
            돌고래 너무 귀엽죠 ~~
            돌고래 완전 굿 굿!
            돌고래와 함께 춤을...
        """
        applyConstraints()
        
    }
    
    
    
    // MARK: Private Methods
    
    private func configureSubviews() {
        view.addSubview(successImage)
        view.addSubview(success)
        view.addSubview(endButton)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            successImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            successImage.topAnchor.constraint(equalTo: view.topAnchor, constant: -50),
            successImage.widthAnchor.constraint(equalToConstant: view.frame.width - 100)
        ])
        NSLayoutConstraint.activate([
            success.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            success.topAnchor.constraint(equalTo: successImage.centerYAnchor, constant: 150),
            success.widthAnchor.constraint(equalToConstant: view.frame.width - 60),
            success.heightAnchor.constraint(equalToConstant: 40 * 4)
        ])
        NSLayoutConstraint.activate([
            endButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            endButton.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            endButton.widthAnchor.constraint(equalToConstant: view.frame.width - 100),
            endButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func clearButtonTapped() {
        UserDefaults.standard.set(quiz!.id, forKey: animal ?? "panda")
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
