//
//  CompaniesController.swift
//  CoreDataCompaniesProject
//
//  Created by Arthur Octavio Jatobá Macedo Leite - ALE on 18/03/21.
//

import UIKit

class CompaniesController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
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

    @objc func handleAddCompany() {
        print("adding company...")
    }
}
