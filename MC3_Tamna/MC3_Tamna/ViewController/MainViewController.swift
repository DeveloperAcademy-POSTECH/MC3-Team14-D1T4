//
//  ViewController.swift
//  MC3_Tamna
//
//  Created by Hyeonsoo Kim on 2022/07/17.
//

import UIKit
import SwiftUI

class MainViewController: UIViewController, ContentDelegate {
    
    // for saving
    private var clearContents: [Int] = [] {
        didSet {
            UserDefaults.standard.set(clearContents, forKey: "clearContents")
        }
    }
    
    // 1. StarVC에 넘길 동물의 이름
    private var animalList = ["polarbear", "elephant", "dolphin", "tiger", "panda"]
    
    private let mainTable: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(mainTable)
        mainTable.delegate = self
        mainTable.dataSource = self
        
        clearContents = (UserDefaults.standard.array(forKey: "clearContents") ?? []) as! [Int]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        mainTable.frame = view.bounds
    }
    
    func didClearContentID(id clearContent: Int) {
        clearContents.append(clearContent)
        mainTable.reloadData()
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animalList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if clearContents.contains(indexPath.row) {
            cell.textLabel?.text = animalList[indexPath.row] + "   완료~!!!"
        } else {
            cell.textLabel?.text = animalList[indexPath.row]
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = StarViewController()
        // 2. StarVC에 해당 animal 이름(String) 전달
        vc.animal = animalList[indexPath.row]
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}
