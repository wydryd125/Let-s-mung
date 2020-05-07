//
//  ViewController.swift
//  petInfo2
//
//  Created by Sunghyup Kim on 2020/01/17.
//  Copyright © 2020 SunghyupKim. All rights reserved.
//

import UIKit

class PetListController: UIViewController {
  
  private let pets = PetManager.shared.currentPets
  private let tableView = UITableView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  func setupUI(){
    self.setupAttributes()
    self.setupNavigationBar()
    self.setupConstriants()
  }
  
  private func setupAttributes() {
    self.view.backgroundColor = .systemBackground
//    tableView.separatorStyle = .none
    tableView.dataSource = self
    tableView.delegate = self
    tableView.rowHeight = 96
    tableView.tableFooterView = UIView()
    tableView.register(PetInfoCell.self, forCellReuseIdentifier: PetInfoCell.identifier)
  }
  
  private func setupNavigationBar() {
    self.navigationItem.title = "아이 정보"
    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
  }
  
  private func setupConstriants() {
    self.view.addSubview(tableView)
    let guide = self.view.safeAreaLayoutGuide
    self.tableView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.tableView.topAnchor.constraint(equalTo: guide.topAnchor),
      self.tableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
      self.tableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
      self.tableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
    ])
  }
}

// MARK:- UITableViewDataSource

extension PetListController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return pets.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: PetInfoCell.identifier, for: indexPath) as! PetInfoCell
    cell.updateContents(with: pets[indexPath.row])
    return cell
  }
}


// MARK:- UITableViewDelegate

extension PetListController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let nextVC = WalkHistoryListController()
    nextVC.selectedPet = pets[indexPath.row]
    self.navigationController?.pushViewController(nextVC, animated: true)
  }
}
