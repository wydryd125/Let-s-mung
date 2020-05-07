//
//  WalkHistoryListController.swift
//  
//
//  Created by cskim on 2020/01/22.
//

import UIKit

class WalkHistoryListController: UIViewController {
  
  private let tableView = UITableView()
  private var walks = [Walk]()
  var selectedPet: Pet!
  
  // MARK: Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if let walks = PetManager.shared.walksForPet[self.selectedPet.name],
      !PetManager.shared.isWalkUpdated {
      self.walks = walks
    } else {
      DataProvider.requestWalks(for: self.selectedPet) { [weak self] (walks) in
        guard let `self` = self else { return }
        self.walks = walks
        PetManager.shared.walksForPet[self.selectedPet.name] = walks
        PetManager.shared.isWalkUpdated = false
        self.tableView.reloadData()
      }
    }
  }
  
  // MARK: Initialize
  
  private func setupUI() {
    self.setupAttributes()
    self.setupNavigationBar()
    self.setupConstraints()
  }
  
  private func setupAttributes() {
    self.view.backgroundColor = .systemBackground
    self.tableView.dataSource = self
    self.tableView.rowHeight = UITableView.automaticDimension
    self.tableView.tableFooterView = UIView()
    self.tableView.register(WalkHistoryCell.self, forCellReuseIdentifier: WalkHistoryCell.identifier)
  }
  
  private func setupNavigationBar(){
    self.navigationItem.title = selectedPet?.name ?? ""
  }
  
  private func setupConstraints() {
    self.view.addSubview(tableView)
    let guide = self.view.safeAreaLayoutGuide
    self.tableView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.tableView.topAnchor.constraint(equalTo: guide.topAnchor),
      self.tableView.leftAnchor.constraint(equalTo: guide.leftAnchor),
      self.tableView.rightAnchor.constraint(equalTo: guide.rightAnchor),
      self.tableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
    ])
  }
}

// MARK:- UITableViewDataSource

extension WalkHistoryListController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return walks.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: WalkHistoryCell.identifier, for: indexPath) as! WalkHistoryCell
    cell.updateContents(with: walks[indexPath.row])
    return cell
  }
}
