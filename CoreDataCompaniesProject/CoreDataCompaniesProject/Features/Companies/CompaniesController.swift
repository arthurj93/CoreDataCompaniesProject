//
//  CompaniesController.swift
//  CoreDataCompaniesProject
//
//  Created by Arthur Octavio Jatobá Macedo Leite - ALE on 18/03/21.
//

import UIKit

class CompaniesController: UITableViewController {

    var companies: [Company] = [
        Company(name: "Apple", founded: Date()),
        Company(name: "Google", founded: Date()),
        Company(name: "Facebook", founded: Date())
    ]

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
        let createCompanyController = CreateCompanyController()
        createCompanyController.delegate = self
        let navController = CustomNavigationController(rootViewController: createCompanyController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.backgroundColor = AppColors.teal

        let company = companies[indexPath.row]

        cell.textLabel?.text = company.name
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

extension CompaniesController: CreateCompanyControllerDelegate {
    func didAddCompany(company: Company) {
        companies.append(company)
        let newIndexPath = IndexPath(row: companies.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
}
