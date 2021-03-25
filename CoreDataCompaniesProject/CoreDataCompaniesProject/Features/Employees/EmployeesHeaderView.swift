//
//  EmployeesHeaderView.swift
//  CoreDataCompaniesProject
//
//  Created by Arthur Octavio Jatobá Macedo Leite - ALE on 24/03/21.
//

import UIKit

class EmployeesHeaderView: UIView {

    static let viewId = "EmployeesHeaderView"

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var headerNameLabel: UILabel!


    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        Bundle.main.loadNibNamed(EmployeesHeaderView.viewId, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

}
