//
//  CompanyCell.swift
//  CoreDataCompaniesProject
//
//  Created by Arthur Octavio Jatobá Macedo Leite - ALE on 23/03/21.
//

import UIKit

class CompanyCell: UITableViewCell {

    static let cellId = "CompanyCell"
    @IBOutlet weak var companyImageView: UIImageView!
    @IBOutlet weak var nameFoundedDateLabel: UILabel!

    var company: Company? {
        didSet {
            setupCompany()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }

    func setupCell() {
        companyImageView.layer.cornerRadius = companyImageView.frame.size.width / 2
        companyImageView.layer.borderColor = AppColors.darkBlue.cgColor
        companyImageView.layer.borderWidth = 1
        companyImageView.clipsToBounds = true
    }

    func setupCompany() {
        if let name = company?.name, let founded = company?.founded {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            //            let locale = Locale(identifier: "EN")
            let foundedDateString = dateFormatter.string(from: founded)
            let dateString = "\(name) - Founded : \(foundedDateString)"
            nameFoundedDateLabel?.text = dateString
        } else {
            nameFoundedDateLabel?.text = company?.name
        }
        if let imageData = company?.imageData {
            if imageData.count == 0 {
                companyImageView?.image = #imageLiteral(resourceName: "select_photo_empty")
            } else {
                companyImageView?.image = UIImage(data: imageData)
            }

        }
    }
    
}
