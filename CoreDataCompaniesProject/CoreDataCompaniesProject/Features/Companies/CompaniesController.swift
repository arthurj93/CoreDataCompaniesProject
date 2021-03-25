//
//  CompaniesController.swift
//  CoreDataCompaniesProject
//
//  Created by Arthur Octavio Jatobá Macedo Leite - ALE on 18/03/21.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController {

    var companies: [Company] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        fetchCompanies()
        setupTableView()
        setupNavigationBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.sizeToFit()
    }

    private func setupTableView() {
        tableView.backgroundColor = AppColors.darkBlue
//        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: CompanyCell.cellId, bundle: nil), forCellReuseIdentifier: CompanyCell.cellId)
        tableView.tableFooterView = UIView() //blank
        tableView.separatorColor = .white
    }

    private func fetchCompanies() {
        CoreDataManager.shared.fetchCompanies { [weak self] result in
            switch result {
            case .success(let companies):
                self?.companies = companies
            case .failure(let error):
                break
            }
        }
    }

    private func setupNavigationBar() {
        configureNavigationBar(largeTitleColor: .white,
                               backgoundColor: AppColors.lightRed,
                               tintColor: .white,
                               title: "Companies",
                               preferredLargeTitle: true)

        setupPlusButtonInNavBar(selector: #selector(handleAddCompany))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))
    }

    @objc private func handleAddCompany() {
        let createCompanyController = CreateCompanyController()
        createCompanyController.delegate = self
        let navController = CustomNavigationController(rootViewController: createCompanyController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }

    @objc private func handleReset() {
        CoreDataManager.shared.resetCompanies(companies: companies) { [weak self] result in

            switch result {
            case .success(let indexPath):
                self?.companies.removeAll()
                self?.tableView.deleteRows(at: indexPath, with: .left)
                self?.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }

        }
    }
}
