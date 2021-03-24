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

    var delegate: CreateEmployeeControllerDelegate?

    @IBOutlet weak var nameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = AppColors.darkBlue

        configureNavigationBar(largeTitleColor: .white,
                               backgoundColor: AppColors.lightRed,
                               tintColor: .white,
                               title: "Create Employee",
                               preferredLargeTitle: true)

        setupCancelButton()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(handleSave))
    }

    @objc func handleSave() {
        guard let name = nameTextField.text else { return }
        CoreDataManager.shared.createEmployee(name: name) { savedEmployee, error  in
            if let error = error {
                print(error)
            }
            if let employee = savedEmployee {
                self.dismiss(animated: true) {
                    self.delegate?.didAddEmployee(employee: employee)
                }
            }
        }
    }

}
