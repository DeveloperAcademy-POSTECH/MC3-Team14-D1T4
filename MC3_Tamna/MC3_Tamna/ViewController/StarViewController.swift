//
//  StarViewController.swift
//  MC3_Tamna
//
//  Created by Hyeonsoo Kim on 2022/07/17.
//

import UIKit

import Lottie

protocol ContentDelegate {
    func didClearContentID(id clearContent: Int)
}

class StarViewController: UIViewController {
    
    var delegate: ContentDelegate?
    
    // MARK: Properties
    
    // 3. MainVC로부터 전달받음
    var animal: String?
    
    // 4. 받은 animal을 기반으로 해당 content 불러와서 할당
    private var content: AnimalQuizzes {
        QuizDao().getQuizzessByName(animalName: animal ?? "panda")
    }
    
    // 5. 받은 animal을 기반으로 해당 animal의 frame배열을 할당 (feat. getFrames())
    private var lottieFrames: [CGFloat] = []
    
    // 6. 가장 마지막으로 clear된 quiz의 index
    private var clearIndex = -1
    
    // MARK: UIComponents
    
    private lazy var backImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "\(animal ?? "panda")Sky")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private lazy var lottieView: AnimationView = {
        let lottieView = AnimationView(name: animal ?? "panda")
        lottieView.contentMode = .scaleToFill
        lottieView.loopMode = .playOnce
        lottieView.backgroundBehavior = .pauseAndRestore
        return lottieView
    }()
    
    private lazy var progressLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 25, weight: .black)
        label.layer.cornerRadius = 10
        label.layer.backgroundColor = UIColor.wwfYellow?.cgColor
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: .screenW*0.9, height: .screenW*0.15)
        layout.minimumLineSpacing = .screenW*0.07
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false //scroll 차단.
        collectionView.backgroundColor = .clear
        collectionView.register(MissionCell.self, forCellWithReuseIdentifier: MissionCell.identifier)
        return collectionView
    }()

    // MARK: Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: progressLabel)
        
        configureSubviews()
        
        // 8. 저장된 clear 단계 load (저장된 것이 없을 땐 default 0을 줘버리니 조건 걸어야함)
        if UserDefaults.standard.dictionaryRepresentation().keys.contains(animal ?? "") {
            clearIndex = UserDefaults.standard.integer(forKey: animal ?? "")
        }

        setLottieFrames() // 순서 중요
        
        progressLabel.text = "\(clearIndex+1)/\(content.quizzes.count)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: Layout frame
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let midY = view.bounds.midY
        
        backImageView.frame = view.bounds
        lottieView.frame = view.bounds
        collectionView.frame = CGRect(
            x: 0,
            y: content.quizzes.count == 4 ? midY + 30 : midY - 30,
            width: .screenW,
            height: .screenW + .hund
        )
    }
    
    // MARK: QuizDelegate Method
    
    func didClearQuizID(id clearQuiz: Int) { // clear한 Quiz의 id (Int) 값이 전달될 것임
        clearIndex = clearQuiz // 14. clear된 quiz의 id(==index)를 clearIndex에 할당
        
        collectionView.reloadItems(at: [IndexPath.init(row: clearIndex, section: 0)])
        
        if clearIndex < content.quizzes.count - 1 {
            collectionView.reloadItems(at: [IndexPath.init(row: clearIndex + 1, section: 0)])
        }
        
        // 15. label 갱신
        progressLabel.text = "\(clearIndex+1)/\(content.quizzes.count)"
        
        // 16. lottieView 재생
        if clearIndex == 0 {
            lottieView.play(fromFrame: 0, toFrame: lottieFrames[clearIndex])
        } else {
            lottieView.play(fromFrame: lottieFrames[clearIndex-1], toFrame: lottieFrames[clearIndex])
        }
        
        if clearIndex+1 == content.quizzes.count { // 모든 문제 완료 시
            delegate?.didClearContentID(id: content.id)
        }
    }
}

// MARK: Delegate, DataSource
extension StarViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return content.quizzes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MissionCell.identifier, for: indexPath) as? MissionCell else { return UICollectionViewCell() }
        cell.configureCell(quiz: content.quizzes[indexPath.row], clearIndex: clearIndex)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 11. clearIndex + 1 == open 케이스 -> 이 경우일 때만 들어갈 수 있도록. 추후 clear도 들어갈 수 있게 할 것이라면 수정해야함.
        guard indexPath.row == clearIndex + 1 else { return }
        let vc = QuizViewController()
        vc.quiz = content.quizzes[indexPath.row] // 12. quiz 건네기
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: Private Methods
private extension StarViewController {
    
    func configureSubviews() {
        view.addSubview(backImageView)
        view.addSubview(lottieView)
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let constraints = [
            progressLabel.widthAnchor.constraint(equalToConstant: .hund)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setLottieFrames() {
        guard let animal = animal else { return }
        // 9. 전달받은 animal 기반으로 lottie frame array 할당
        switch animal {
        case "polarbear":
            lottieFrames = [130, 270, 440, 900]
        case "elephant":
            lottieFrames = [130, 270, 440, 900]
        case "dolphin":
            lottieFrames = [130, 270, 440, 900]
        case "tiger":
            lottieFrames = [130, 270, 440, 620, 1020]
        case "panda":
            lottieFrames = [130, 270, 440, 620, 1020]
        default:
            break
        }
        // 10. 나갔다 들어왔을 때 clear한 단계까지의 lottie frame 상태가 되도록 설정
        if clearIndex != -1 {
            lottieView.currentFrame = lottieFrames[clearIndex]
        }
    }
}
