//
//  SubmitCompleteViewController.swift
//  MC3
//
//  Created by MBSoo on 2022/07/13.
//

import UIKit

class SubmitCompleteViewController: UIViewController {
    let didChooseIndex: Int
    
    init(didChooseIndex: Int){
        self.didChooseIndex = didChooseIndex
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        view.addSubview(successImage)
        view.addSubview(success)
        success.text = """
            정답은: \(didChooseIndex)
            돌고래 너무 귀엽죠 ~~
            돌고래 완전 굿 굿!
            돌고래와 함께 춤을...
        """
        NSLayoutConstraint.activate([
            successImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            successImage.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 250),
            successImage.widthAnchor.constraint(equalToConstant: view.frame.width - 100),
//            successImage.heightAnchor.constraint(equalToConstant: <#T##CGFloat#>)
        ])
        NSLayoutConstraint.activate([
            success.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            success.centerYAnchor.constraint(equalTo: successImage.bottomAnchor, constant: 200),
            success.widthAnchor.constraint(equalToConstant: view.frame.width - 100),
            success.heightAnchor.constraint(equalToConstant: 40 * 4)
        ])
        
    }
    
    private let successImage: UIImageView = {
        var image = UIImage(named: "dolphin")
        image = image?.withRenderingMode(.alwaysOriginal)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let success:UITextView = {
       let success = UITextView()
        success.text = "hi"
        success.isEditable = false
        success.textColor = UIColor.systemBrown
        success.font = UIFont.systemFont(ofSize: 25)
        success.textAlignment = .center
        success.backgroundColor = UIColor.systemGray4
        success.layer.cornerRadius = 20
        success.translatesAutoresizingMaskIntoConstraints = false
        
        return success
    }()
    
}
