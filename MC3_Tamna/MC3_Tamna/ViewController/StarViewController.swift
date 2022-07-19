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
    
    // MainVC로부터 전달받음
    var animal: String?
    
    // 받은 animal을 기반으로 해당 content 불러와서 할당
    private var content: AnimalQuizzes {
        QuizDao().getQuizzessByName(animalName: animal ?? "panda")
    }
    
    // 받은 animal을 기반으로 해당 animal의 frame배열을 할당 (feat. getFrames())
    private var lottieFrames: [CGFloat] = []
    
    
    // 앞에서 왔는지, 뒤에서 왔는지!
    var isPushFromFront: Bool = true
    
    /*
     isPushFromFront 변수를 만든 이유
     - MainVC -> StarVC로 왔을 경우에는 애니메이션 동작이 일어나선 안된다.
     - QuizVC -> MainVC로 돌아올 경우에는 애니메이션 동작이 발생한다. 단, 문제가 풀렸을 경우만~! 그렇기에 oldValue != clearIndex조건 추가.
     */
    private var clearIndex = -1 {
        didSet {
            if !isPushFromFront && oldValue != clearIndex {
                reloadUIComponents()
            }
            guard clearIndex + 1 == content.quizzes.count else { return }
            delegate?.didClearContentID(id: content.id) //완료 시 delegate로 데이터 MainVC에 전달.
        }
    }
    
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
        
        loadUserDefaults() // clearIndex setting - clearIndex를 기반으로 형성되는 뷰가 있기에 가장 먼저 호출.
        
        configureSubviews() // subview setting

        setLottieFrames() // lottie frames array setting
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        
        loadUserDefaults() // clearIndex setting
        
        isPushFromFront = false // if push: true -> false, if pop: false -> false
        // false를 여기서 할당한 이유. loadUserDefaults는 필수적으로 viewWillAppear에서 구현되어야 제때 값의 변화를 감지할 수 있다.
        // 헌데 viewDidLoad에서 false를 할당할 경우에는 그 이후 호출되는 viewWillAppear에 의해 애니메이션이 발생해버릴 수가 있다.
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
}

// MARK: Delegate, DataSource
extension StarViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return content.quizzes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MissionCell.identifier, for: indexPath) as? MissionCell else { return UICollectionViewCell() }
        cell.configureCell(quiz: content.quizzes[indexPath.row], clearIndex: clearIndex)
        return cell
    }
}

extension StarViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath),
              indexPath.row == clearIndex + 1 else { return }
        cell.contentView.layer.shadowColor = UIColor.clear.cgColor
        cell.contentView.backgroundColor = .white.withAlphaComponent(0.5)
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath),
              indexPath.row == clearIndex + 1 else { return }
        cell.contentView.layer.shadowColor = UIColor.black.cgColor
        cell.contentView.backgroundColor = .white
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 11. clearIndex + 1 == open 케이스 -> 이 경우일 때만 들어갈 수 있도록. 추후 clear도 들어갈 수 있게 할 것이라면 수정해야함.
        guard indexPath.row == clearIndex + 1 else { return }
        let vc = QuizViewController()
        vc.quiz = content.quizzes[indexPath.row] // 12. quiz 건네기
        vc.animal = animal
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
        
        progressLabel.text = "\(clearIndex+1)/\(content.quizzes.count)"
        //text 할당을 UILabel 초기화 코드에서 하지않은 이유 -> breakPoint를 걸어보면 UILabel 초기화클로저가 viewDidLoad보다도 먼저 실행됨. 그렇기에 아직 UserDefaults에서 clearIndex를 로드해주지 못한 상황이라 "0/4"로 나타나게 되버림. 그렇기에 viewDidLoad에서 잡아줌.
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
        
        if clearIndex != -1 {
            lottieView.currentFrame = lottieFrames[clearIndex]
        }
    }
    
    // 저장 key없으면 guard return. 있으면 값 세팅.
    func loadUserDefaults() {
        guard UserDefaults.standard.dictionaryRepresentation().keys.contains(animal ?? "") else { return }
        clearIndex = UserDefaults.standard.integer(forKey: animal ?? "")
    }
    
    // clearIndex의 didSet구문 조건 참고. didSet 내부에서 호출.
    func reloadUIComponents() {
        progressLabel.text = "\(clearIndex+1)/\(content.quizzes.count)"
        
        lottieView.play(toFrame: lottieFrames[clearIndex]) // from-to에서 to로 수정. current상태는 남아있을것이기 때문.
        
        //reload collection item...
        collectionView.reloadItems(at: [IndexPath.init(row: clearIndex, section: 0)])
        
        if clearIndex < content.quizzes.count - 1 {
            collectionView.reloadItems(at: [IndexPath.init(row: clearIndex + 1, section: 0)])
        }
    }
}
