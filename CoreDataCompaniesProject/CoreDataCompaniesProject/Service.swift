//
//  Service.swift
//  CoreDataCompaniesProject
//
//  Created by Arthur Octavio Jatobá Macedo Leite - ALE on 28/03/21.
//

import CoreData

struct Service {

    static let shared = Service()

    let urlString = "https://api.letsbuildthatapp.com/intermediate_training/companies"

    func downloadCompaniesFromService() {
        print("service")
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            print("finishing download")

            if let error = error {
                print("failed to download companies:", error)
            }
            guard let data = data else { return }

            let jsonDecoder = JSONDecoder()

            do {
                let jsonCompanies = try jsonDecoder.decode([JSONCompany].self, from: data)

                let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                privateContext.parent = CoreDataManager.shared.persistentContainer.viewContext

                jsonCompanies.forEach { (jsonCompany) in
                    print(jsonCompany.name)
                    let company = Company(context: privateContext)
                    company.name = jsonCompany.name

                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy"
                    let foundedDate = dateFormatter.date(from: jsonCompany.founded)
                    company.founded = foundedDate



//                    privateContext.save()
                    jsonCompany.employees?.forEach({ (jsonEmployee) in
                        let employee = Employee(context: privateContext)
                        employee.fullName = jsonEmployee.name
                        employee.type = jsonEmployee.type
                        let employeeInformation = EmployeeInformation(context: privateContext)
                        let birthdayDate = dateFormatter.date(from: jsonEmployee.birthday)
                        employeeInformation.birthday = birthdayDate
                        employee.company = company
                        employee.employeeInformation = employeeInformation
                        print("  \(jsonEmployee.name)")
                    })

                    do {
                        try privateContext.save()
                        try privateContext.parent?.save()
                    } catch let saveErr {
                        print("Error save:", saveErr)
                    }
                }


            } catch let jsonDecoderError {
                print("Error to decote:", jsonDecoderError)
            }


//            let string = String(data: data, encoding: .utf8)

        }.resume() // dont forget to call resume
    }
}

struct JSONCompany: Decodable {
    let name: String
    let founded: String
    var employees: [JSONEmployee]?
}

struct JSONEmployee: Decodable {
    let name: String
    let birthday: String
    let type: String
}
