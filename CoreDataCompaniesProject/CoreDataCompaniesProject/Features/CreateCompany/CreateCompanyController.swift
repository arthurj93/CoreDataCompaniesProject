//
//  CreateCompanyController.swift
//  CoreDataCompaniesProject
//
//  Created by Arthur Octavio Jatobá Macedo Leite - ALE on 18/03/21.
//

import UIKit

protocol CreateCompanyControllerDelegate {
    func didAddCompany(company: Company)
}

class CreateCompanyController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var nameTextField: UITextField!

    var delegate: CreateCompanyControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = AppColors.darkBlue

        configureNavigationBar(largeTitleColor: .white,
                               backgoundColor: AppColors.lightRed,
                               tintColor: .white,
                               title: "Create Company",
                               preferredLargeTitle: true)

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
    }

    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }

    @objc func handleSave() {
        print("Trying to save company")

        dismiss(animated: true) {
            guard let name = self.nameTextField.text else { return }
            let company = Company(name: name, founded: Date())
            self.delegate?.didAddCompany(company: company)
        }

    }

}
