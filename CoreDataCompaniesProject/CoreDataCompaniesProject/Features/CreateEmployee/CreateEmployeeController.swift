//
//  CreateEmployeeController.swift
//  CoreDataCompaniesProject
//
//  Created by Arthur Octavio Jatobá Macedo Leite - ALE on 23/03/21.
//

import UIKit

protocol CreateEmployeeControllerDelegate: class {
    func didAddEmployee(employee: Employee)
}

class CreateEmployeeController: UIViewController {

    weak var delegate: CreateEmployeeControllerDelegate?
    var company: Company?

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var employeeTypeSegmentControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = AppColors.darkBlue

        configureNavigationBar(largeTitleColor: .white,
                               backgoundColor: AppColors.lightRed,
                               tintColor: .white,
                               title: "Create Employee",
                               preferredLargeTitle: true)

        setupCancelButton()
        setupUI()
    }

    private func setupUI() {
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppColors.darkBlue]
        let titleTextAttributesSelected = [NSAttributedString.Key.foregroundColor: UIColor.white]
        employeeTypeSegmentControl.setTitleTextAttributes(titleTextAttributes, for:.normal)
        employeeTypeSegmentControl.setTitleTextAttributes(titleTextAttributesSelected, for:.selected)


        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(handleSave))
    }

    @objc func handleSave() {
        guard let name = nameTextField.text else { return }
        guard let company = company else { return }
        guard let birthday = birthdayTextField.text else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"

        if birthday.isEmpty {
            showError(title: "Empty birthDay", message: "You have not entered a birthday")
            return
        }
        guard let birthdayDate = dateFormatter.date(from: birthday) else {
            showError(title: "Bad Date", message: "Birthday date entered not valid")
            return
        }

        guard let employeeType = employeeTypeSegmentControl.titleForSegment(at: employeeTypeSegmentControl.selectedSegmentIndex) else { return }

        CoreDataManager.shared.createEmployee(name: name,
                                              type: employeeType,
                                              birthday: birthdayDate,
                                              company: company) { [weak self] result  in
            switch result {
            case .success(let employee):
                if let employee = employee {
                    self?.dismiss(animated: true) {
                        self?.delegate?.didAddEmployee(employee: employee)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    private func showError(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertActionOK = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertActionOK)
        present(alertController, animated: true, completion: nil)
    }

}
