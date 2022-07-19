//
//  MissionCell.swift
//  MC3_Tamna
//
//  Created by Hyeonsoo Kim on 2022/07/17.
//

import UIKit

class MissionCell: UICollectionViewCell {
    
    static let identifier = "MissionCell"
    
    // MARK: UIComponents
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "stamp")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0
        return imageView
    }()
    
    // MARK: Override
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(checkImageView)
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configure Methods
    
    func configureCell(quiz: Quiz, clearIndex: Int) {
        titleLabel.text = quiz.question
        
        contentView.layer.cornerRadius = 10
        
        if quiz.id > clearIndex + 1 { // noOpen
            contentView.backgroundColor = .wwfGray
        } else if quiz.id == clearIndex + 1 { // open
            contentView.backgroundColor = .white
            contentView.layer.shadowRadius = 4
            contentView.layer.shadowOpacity = 0.7
            contentView.layer.shadowOffset = CGSize(width: 0, height: 4)
        } else { // clear
            contentView.backgroundColor = .wwfYellow
            checkImageView.alpha = 1
        }
    }
    
    private func configureConstraints() {
        let constraints = [
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .ten*3),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: .screenW * 0.7),
            
            checkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.ten*3),
            checkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkImageView.widthAnchor.constraint(equalToConstant: .hund/2)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
