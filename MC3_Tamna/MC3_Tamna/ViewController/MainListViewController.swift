//
//  ViewController.swift
//  MainSamples
//
//  Created by Dongjin Jeon on 2022/07/12.
//

import UIKit

class MainListViewController: UIViewController {
    
    let dirtyImages = ["scene1", "scene3", "scene5", "scene7", "scene9"]
    let cleanImages = ["scene2", "scene4", "scene6", "scene8", "scene10"]
    
    @objc func toQuizView(){
        print("Go to Quiz view")
        let detailController = QuizViewController()
        navigationController?.pushViewController(detailController, animated: true)
    }
    
    func makeButton(imageName: String) -> UIButton {
        
        let button: UIButton = {
            let button = UIButton()
            button.backgroundColor = .black
            let image = UIImage(named: imageName)
            button.setBackgroundImage(image, for: .normal)
            button.imageView?.contentMode = .scaleAspectFill
            button.translatesAutoresizingMaskIntoConstraints = false
            button.layer.borderColor = UIColor.white.cgColor
            button.layer.borderWidth = 2
            button.clipsToBounds = true
            button.layer.cornerRadius = 15
            button.layer.shadowColor = UIColor.gray.cgColor
            button.layer.shadowOpacity = 1.0
            button.layer.shadowOffset = CGSize.zero
            button.layer.shadowRadius = 6
            button.isEnabled = true
            button.setNeedsUpdateConfiguration()
            button.addTarget(self, action: #selector(toQuizView), for: .touchUpInside)
            button.addTarget(self, action: #selector(animationFunc(_:)), for: .touchUpInside)
            return button
        }()
        
        return button
    }
    
    func makeImageView(imageName: String) -> UIImageView {
        let imageView = UIImageView(image: UIImage(named: imageName))
        
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.layer.shadowColor = UIColor.gray.cgColor
        imageView.layer.shadowOpacity = 1.0
        imageView.layer.shadowOffset = CGSize.zero
        imageView.layer.shadowRadius = 6
        
        return imageView
    }
    
    @objc func animationFunc(_ sender:UIButton) {
        UIView.animate(withDuration: 1.2, animations: {
            sender.alpha = 0
        }, completion: {_ in
            sender.alpha = 0
            sender.isEnabled = false
        })
    }
    
    let contentView: UIView! = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        let scrollView = UIScrollView(frame: view.bounds)
        scrollView.backgroundColor = UIColor.white
        scrollView.contentSize = view.bounds.size
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
        ])
        
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true

        let contentViewHeight = contentView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor)
        contentViewHeight.priority = .defaultLow
        contentViewHeight.isActive = true
        
        let label = UILabel()
        label.text = "Enviroment Quiz"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.8),
            label.heightAnchor.constraint(equalToConstant: CGFloat(30)),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10)
        ])
        
        let buttonWidth = view.bounds.width * 0.9
        let buttonHeight = CGFloat(180)
        
        let imageView1 = makeImageView(imageName: cleanImages[0])
        let imageView2 = makeImageView(imageName: cleanImages[1])
        let imageView3 = makeImageView(imageName: cleanImages[2])
        let imageView4 = makeImageView(imageName: cleanImages[3])
        let imageView5 = makeImageView(imageName: cleanImages[4])
        
        contentView.addSubview(imageView1)
        contentView.addSubview(imageView2)
        contentView.addSubview(imageView3)
        contentView.addSubview(imageView4)
        contentView.addSubview(imageView5)
        
        NSLayoutConstraint.activate([
            imageView1.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView1.widthAnchor.constraint(equalToConstant: buttonWidth),
            imageView1.heightAnchor.constraint(equalToConstant: buttonHeight),
            imageView1.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
            
            imageView2.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView2.widthAnchor.constraint(equalToConstant: buttonWidth),
            imageView2.heightAnchor.constraint(equalToConstant: buttonHeight),
            imageView2.topAnchor.constraint(equalTo: imageView1.bottomAnchor, constant: 10),
            
            imageView3.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView3.widthAnchor.constraint(equalToConstant: buttonWidth),
            imageView3.heightAnchor.constraint(equalToConstant: buttonHeight),
            imageView3.topAnchor.constraint(equalTo: imageView2.bottomAnchor, constant: 10),
            
            imageView4.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView4.widthAnchor.constraint(equalToConstant: buttonWidth),
            imageView4.heightAnchor.constraint(equalToConstant: buttonHeight),
            imageView4.topAnchor.constraint(equalTo: imageView3.bottomAnchor, constant: 10),
            
            imageView5.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView5.widthAnchor.constraint(equalToConstant: buttonWidth),
            imageView5.heightAnchor.constraint(equalToConstant: buttonHeight),
            imageView5.topAnchor.constraint(equalTo: imageView4.bottomAnchor, constant: 10),
            imageView5.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        
        let button1 = makeButton(imageName: dirtyImages[0])
        let button2 = makeButton(imageName: dirtyImages[1])
        let button3 = makeButton(imageName: dirtyImages[2])
        let button4 = makeButton(imageName: dirtyImages[3])
        let button5 = makeButton(imageName: dirtyImages[4])
        
        contentView.addSubview(button1)
        contentView.addSubview(button2)
        contentView.addSubview(button3)
        contentView.addSubview(button4)
        contentView.addSubview(button5)
        
        NSLayoutConstraint.activate([
            button1.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            button1.widthAnchor.constraint(equalToConstant: buttonWidth),
            button1.heightAnchor.constraint(equalToConstant: buttonHeight),
            button1.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
            
            button2.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            button2.widthAnchor.constraint(equalToConstant: buttonWidth),
            button2.heightAnchor.constraint(equalToConstant: buttonHeight),
            button2.topAnchor.constraint(equalTo: button1.bottomAnchor, constant: 10),
            
            button3.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            button3.widthAnchor.constraint(equalToConstant: buttonWidth),
            button3.heightAnchor.constraint(equalToConstant: buttonHeight),
            button3.topAnchor.constraint(equalTo: button2.bottomAnchor, constant: 10),
            
            button4.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            button4.widthAnchor.constraint(equalToConstant: buttonWidth),
            button4.heightAnchor.constraint(equalToConstant: buttonHeight),
            button4.topAnchor.constraint(equalTo: button3.bottomAnchor, constant: 10),
            
            button5.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            button5.widthAnchor.constraint(equalToConstant: buttonWidth),
            button5.heightAnchor.constraint(equalToConstant: buttonHeight),
            button5.topAnchor.constraint(equalTo: button4.bottomAnchor, constant: 10),
            button5.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true // 뷰 컨트롤러가 나타날 때 숨기기
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false // 뷰 컨트롤러가 사라질 때 나타내기
    }
}
