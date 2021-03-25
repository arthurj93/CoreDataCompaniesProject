//
//  CreateCompanyController.swift
//  CoreDataCompaniesProject
//
//  Created by Arthur Octavio Jatobá Macedo Leite - ALE on 18/03/21.
//

import UIKit
import CoreData

protocol CreateCompanyControllerDelegate: class {
    func didAddCompany(company: Company)
    func didEditCompany(company: Company)
}

class CreateCompanyController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var companyImageView: UIImageView!

    weak var delegate: CreateCompanyControllerDelegate?
    var company: Company?
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = AppColors.darkBlue
        setupNavigationBar()
        setupImageView()
    }

    func setupNavigationBar() {
        configureNavigationBar(largeTitleColor: .white,
                               backgoundColor: AppColors.lightRed,
                               tintColor: .white,
                               title: "",
                               preferredLargeTitle: true)

        setupCancelButton()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
    }

    func setupImageView() {
        let tapGesture: UITapGestureRecognizer = .init(target: self, action: #selector(handleSelectPhoto))
        companyImageView.addGestureRecognizer(tapGesture)
    }

    @objc func handleSelectPhoto() {

        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleCompany()
    }

    private func handleCompany() {
        navigationItem.title = company == nil ? "Create Company" : "Edit Company"
        if company != nil {
            nameTextField.text = company?.name
            if let imageData = company?.imageData {
                companyImageView.image = UIImage(data: imageData)
                setupCircularImageStyle()
            }
            guard let founded = company?.founded else { return }
            datePicker.date = founded
        }
    }

    private func setupCircularImageStyle() {
        companyImageView.layer.cornerRadius = companyImageView.frame.size.width / 2
        companyImageView.layer.borderColor = AppColors.darkBlue.cgColor
        companyImageView.layer.borderWidth = 2
        companyImageView.clipsToBounds = true
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
        if let image = companyImageView.image {
            let imageData = image.jpegData(compressionQuality: 0.8)
            company.setValue(imageData, forKey: "imageData")
        }

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

        if let image = companyImageView.image {
            let imageData = image.jpegData(compressionQuality: 0.8)
            company?.imageData = imageData
        }

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

extension CreateCompanyController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let editedImage = info[.editedImage] as? UIImage {
            companyImageView.image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            companyImageView.image = originalImage
        }
        setupCircularImageStyle()
        dismiss(animated: true, completion: nil)
    }
}
