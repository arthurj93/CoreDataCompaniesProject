//
//  CompaniesController.swift
//  CoreDataCompaniesProject
//
//  Created by Arthur Octavio Jatobá Macedo Leite - ALE on 18/03/21.
//

import UIKit

class CompaniesController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        tableView.backgroundColor = AppColors.darkBlue
//        tableView.separatorStyle = .none
//        tableView.register(UINib(nibName: "cellId", bundle: nil), forCellReuseIdentifier: "cellId")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        tableView.tableFooterView = UIView() //blank
        tableView.separatorColor = .white
        configureNavigationBar(largeTitleColor: .white,
                               backgoundColor: AppColors.lightRed,
                               tintColor: .white,
                               title: "Companies",
                               preferredLargeTitle: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(handleAddCompany))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.sizeToFit()
    }

    @objc func handleAddCompany() {
        print("adding company...")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.backgroundColor = AppColors.teal
        cell.textLabel?.text = "the company name"
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return cell
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = AppColors.lightBlue
        return header
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}
