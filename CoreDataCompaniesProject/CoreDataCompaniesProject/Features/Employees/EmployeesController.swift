//
//  EmployeesController.swift
//  CoreDataCompaniesProject
//
//  Created by Arthur Octavio Jatobá Macedo Leite - ALE on 23/03/21.
//

import UIKit

class EmployeesController: UITableViewController {

    var company: Company?
    var shortNameEmployees: [Employee] = []
    var longNameEmployees: [Employee] = []
    var realLongNameEmployees: [Employee] = []

    var allEmployees: [[Employee]] = .init()
    var employeeTypes = [
        EmployeeType.Executive.rawValue,
        EmployeeType.seniorManagement.rawValue,
        EmployeeType.Staff.rawValue
    ]

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = company?.name
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = AppColors.darkBlue
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "xxc")

        setupPlusButtonInNavBar(selector: #selector(handleAdd))
        fetchEmployees()
    }

    func fetchEmployees() {
        guard let companyEmployees = company?.employees?.allObjects as? [Employee] else { return }

        allEmployees = []
        employeeTypes.forEach { employeeType in
            allEmployees.append(
                companyEmployees.filter { $0.type == employeeType}
            )
        }
    }

    @objc func handleAdd() {
        let createEmployeeController = CreateEmployeeController()
        createEmployeeController.delegate = self
        createEmployeeController.company = company
        let navController = CustomNavigationController(rootViewController: createEmployeeController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }
    
}

extension EmployeesController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allEmployees[section].count
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return allEmployees.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "xxc") as? UITableViewCell else { return .init() }
        let employee = allEmployees[indexPath.section][indexPath.row]

        cell.textLabel?.text = employee.fullName

        if let birthday = employee.employeeInformation?.birthday {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            //            let locale = Locale(identifier: "EN")
            let foundedDateString = dateFormatter.string(from: birthday)
//            let dateString = "\(name) - Founded : \(foundedDateString)"
            cell.textLabel?.text = "\(employee.fullName ?? "")   \(foundedDateString)"
        }
//        if let taxId = employee.employeeInformation?.taxId {
//            cell.textLabel?.text = "\(employee.name ?? "")   \(taxId)"
//        }
        cell.backgroundColor = AppColors.teal
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        return cell
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = EmployeesHeaderView()
        headerView.headerNameLabel.text = employeeTypes[section]
        return headerView
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

extension EmployeesController: CreateEmployeeControllerDelegate {
    func didAddEmployee(employee: Employee) {
        guard let section = employeeTypes.firstIndex(of: employee.type!) else { return }
        let row = allEmployees[section].count
        let insertionIndexPath = IndexPath(row: row, section: section)
        allEmployees[section].append(employee)
        tableView.insertRows(at: [insertionIndexPath], with: .middle)
    }
}
