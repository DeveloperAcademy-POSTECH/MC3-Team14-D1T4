//
//  QuizViewController.swift
//  MC3
//
//  Created by MBSoo on 2022/07/12.
//

import UIKit

class QuizViewController: UIViewController {
    var quiz: Quiz?

   
    
    // MARK: Properties
    
    var animal: String?
    // 전달받은 animal
    
    private var quizAnswers: [String] {
        let quizAnswer = quiz?.answers
        
        return quizAnswer ?? [""]
    }
    // 퀴즈 답변
    
    private var didChooseIndex: Int = 0
    // 사용자가 누른 값
    
    private var answerIndex: Int {
        quiz?.rightAnswerIndex ?? 0
    }
    // 해당 퀴즈에서 정답 값
    
    // MARK: UIComponents
    
    private lazy var quizImage: UIImageView = {
        // view 상단에 있는 이미지
        var quizImage = UIImage(named: animal ?? "dolphin")
        // Image 생성
        quizImage = quizImage?.withRenderingMode(.alwaysOriginal)
        // Image가 깨지지 않고 원본을 그대로 렌더링 하게 설정
        let imageView: UIImageView = UIImageView(image: quizImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var quizSubmit: UIButton = {
        // view 최하단에 있는 제출 버튼
        let quizSubmit = UIButton()
        quizSubmit.setTitle("정답 제출하기", for: .normal)
        quizSubmit.titleLabel?.textColor = UIColor.white
        quizSubmit.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        quizSubmit.translatesAutoresizingMaskIntoConstraints = false
        quizSubmit.backgroundColor = UIColor.brown
        quizSubmit.addTarget(self, action: #selector(QuizViewController.submitButtonTapped), for: .touchUpInside)
        return quizSubmit
    }()
    
    private lazy var quizText: UITextView = {
        // view 중앙에 있는 퀴즈 소개
        var quizText: UITextView = UITextView(frame: CGRect(x: 20, y: 350, width: self.view.bounds.width - 40, height: 100))
        // TextView 객체 생성
        quizText.backgroundColor = .systemGray4
        // 배경색 넣기
        quizText.text = quiz?.question
        
        quizText.layer.masksToBounds = true
        // 둥글게 만들기
        
        quizText.layer.cornerRadius = 20
        // 20만큼 둥글게 만들기
        
        quizText.font = UIFont.systemFont(ofSize: 20)
        // font 사이즈 설정
        
        quizText.textColor = UIColor.black
        // 색 설정
        quizText.textAlignment = NSTextAlignment.left
        // 정렬
        quizText.textContainerInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        quizText.translatesAutoresizingMaskIntoConstraints = false
        quizText.isEditable = false
        quizText.isScrollEnabled = false
        return quizText
    }()
    
    private let quizAnswerCollection: UICollectionView = {
        // view 하단에 있는 quizAnswer 4개
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.register(QuizAnswerCollectionViewCell.self, forCellWithReuseIdentifier: QuizAnswerCollectionViewCell.identifier)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .red
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        return scrollView
      }()
    
    // MARK: Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        configureSubviews()
//        configureNavbar()
        applyConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .default
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        scrollView.frame = view.bounds
    }
    
    // MARK: Private Methods
    
    @objc private func submitButtonTapped() {
        // 퀴즈를 제출하면 해당 값들을 검사하고, 틀리면 alert을, 맞으면 SubmitCompleteViewController로 navigate 한다.
        let detailController = SubmitCompleteViewController()
        detailController.quiz = quiz
        detailController.animal = animal
        // quiz, animal 넘겨주기
        if (didChooseIndex == answerIndex) {
            navigationController?.pushViewController(detailController, animated: true)
        } else {
            let alert = UIAlertController(title: "오답입니다", message: "다시 한번 생각해볼까요?", preferredStyle: .alert)
            let tryAgain = UIAlertAction(title: "알겠어요!", style: .default, handler: nil)
            
            alert.addAction(tryAgain)
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    private func configureNavbar(){
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "lightbulb.fill"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = UIColor.wwfYellow
        // 객체의 색깔을 바꾸는 방법
    }
    private func configureSubviews(){
        scrollView.addSubview(quizImage)
        scrollView.addSubview(quizText)
        scrollView.addSubview(quizAnswerCollection)
        scrollView.addSubview(quizSubmit)
        quizAnswerCollection.delegate = self
        // delegate 연결
        quizAnswerCollection.dataSource = self
        // datasource 연결
        quizAnswerCollection.contentInset = UIEdgeInsets(top: 15, left: 30, bottom: 0, right: 30)
        // padding
        
    }
    private func applyConstraints(){
        let quizQuestionLines: Int = (quiz?.question.count ?? 25) / 10
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 30),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            scrollView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        NSLayoutConstraint.activate([
            quizImage.centerXAnchor.constraint(equalTo:  scrollView.centerXAnchor),
            quizImage.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 100),
            quizImage.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 30),
            quizImage.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            quizImage.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.3)
            // autolayout
        ])
        NSLayoutConstraint.activate([
            quizText.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            quizText.topAnchor.constraint(equalTo: quizImage.bottomAnchor, constant: 30),
            quizText.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            quizText.heightAnchor.constraint(equalToConstant: CGFloat(40 * quizQuestionLines))
        ])
        NSLayoutConstraint.activate([
            quizAnswerCollection.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            quizAnswerCollection.topAnchor.constraint(equalTo: quizText.bottomAnchor, constant: 30 ),
            quizAnswerCollection.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            quizAnswerCollection.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.5)
            // auto layout
        ])
        NSLayoutConstraint.activate([
            quizSubmit.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            quizSubmit.topAnchor.constraint(equalTo: quizAnswerCollection.bottomAnchor, constant: 30),
            quizSubmit.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -60),
            quizSubmit.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}

// MARK: Delegate, DataSource
extension QuizViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QuizAnswerCollectionViewCell.identifier, for: indexPath) as? QuizAnswerCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.quizAnswerButtonView.setTitle(quizAnswers[indexPath.row], for: .normal)
        cell.quizAnswerButtonView.titleLabel?.textColor = .white
        cell.quizAnswerButtonView.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        cell.quizAnswerButtonView.layer.borderColor = UIColor.white.cgColor
        cell.quizAnswerButtonView.layer.cornerRadius = 20
        cell.tag = indexPath.item
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! QuizAnswerCollectionViewCell
        didChooseIndex = cell.tag
        if cell.clickCount == 1 {
            // 이미 눌린 것을 누를 경우
            cell.clickCount = 0
            // 초기화
        } else {
            // 안 눌린 것을 누를 경우
            cell.clickCount += 1
        }
    }
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        // 선택 활성화
        return true
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 50
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 20
        return CGSize(width: (collectionView.bounds.width / 2 - spacing * 2), height: 70)
    }
}
