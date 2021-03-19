//
//  UiColor+Extension.swift
//  CoreDataCompaniesProject
//
//  Created by Arthur Octavio Jatobá Macedo Leite - ALE on 18/03/21.
//

import UIKit

extension UIColor {

    static func rgbColor(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
}
