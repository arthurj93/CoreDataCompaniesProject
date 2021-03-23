//
//  CreateCompanyController.swift
//  CoreDataCompaniesProject
//
//  Created by Arthur Octavio Jatobá Macedo Leite - ALE on 18/03/21.
//

import UIKit
import CoreData

protocol CreateCompanyControllerDelegate {
    func didAddCompany(company: Company)
    func didEditCompany(company: Company)
}

class CreateCompanyController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!

    var delegate: CreateCompanyControllerDelegate?
    var company: Company?
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = AppColors.darkBlue

        configureNavigationBar(largeTitleColor: .white,
                               backgoundColor: AppColors.lightRed,
                               tintColor: .white,
                               title: "",
                               preferredLargeTitle: true)

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleCompany()
    }

    private func handleCompany() {
        navigationItem.title = company == nil ? "Create Company" : "Edit Company"
        if company != nil {
            nameTextField.text = company?.name
            guard let founded = company?.founded else { return }
            datePicker.date = founded
        }
    }

    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }

    @objc func handleSave() {
        print("Trying to save company")
        if company == nil {
            createCompany()
        } else {
            saveCompanyChanges()
        }

    }

    private func createCompany() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context)

        guard let name = nameTextField.text else { return }
        let date = datePicker.date
        company.setValue(name, forKey: "name")
        company.setValue(date, forKey: "founded")

        do {
            try context.save()
            dismiss(animated: true) {
                self.delegate?.didAddCompany(company: company as! Company)
            }
        } catch let saveError {
            print("Failed to save company:", saveError)
        }
    }

    private func saveCompanyChanges() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        company?.name = nameTextField.text
        company?.founded = datePicker.date

        do {
            try context.save()
            dismiss(animated: true) {
                self.delegate?.didEditCompany(company: self.company!)
            }
        } catch let saveError {
            print("Failed to save company changes: ", saveError)
        }

    }
}
