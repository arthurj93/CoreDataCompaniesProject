//
//  CoreDataManager.swift
//  CoreDataCompaniesProject
//
//  Created by Arthur Octavio Jatobá Macedo Leite - ALE on 22/03/21.
//

import CoreData

struct CoreDataManager {

    static let shared = CoreDataManager()

    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataCompaniesModels")
            container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Loading of store failed: \(error)")
            }
        }
        return container
    }()

    func fetchCompanies(completion: (Result<[Company], Error>) -> Void) {
        let context = persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        do {
            let companies = try context.fetch(fetchRequest)
            completion(.success(companies))
        } catch let fetchError {
            print("Failed to fetch companies:", fetchError)
            completion(.failure(fetchError))
        }
    }

    func resetCompanies(companies: [Company], completion: (Result<[IndexPath], Error>) -> Void) {
        let context = persistentContainer.viewContext

        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
        do {
            try context.execute(batchDeleteRequest)
            var indexPathsToRemove: [IndexPath] = .init()
            for (index, _) in companies.enumerated() {
                let indexPath = IndexPath(row: index, section: 0)
                indexPathsToRemove.append(indexPath)
            }
            completion(.success(indexPathsToRemove))
        } catch let deleteError {
            completion(.failure(deleteError))
            print("Failed to delete: ", deleteError)
        }
    }

    func createEmployee(name: String, type: String, birthday: Date, company: Company, completion: (Result<Employee?, Error>) -> Void) {
        let context = persistentContainer.viewContext

        guard let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context) as? Employee else { return }

        employee.company = company
        employee.type = type
        employee.setValue(name, forKey: "name")

        guard let employeeInformation = NSEntityDescription.insertNewObject(forEntityName: "EmployeeInformation", into: context) as? EmployeeInformation else { return }

        employeeInformation.taxId = "456"
        employeeInformation.birthday = birthday
        employee.employeeInformation = employeeInformation


        do {
            try context.save()
            completion(.success(employee))
        } catch let createError {
            print("Failed to create Employee: ", createError)
            completion(.failure(createError))
        }
    }

    func fetchEmployees(completion: (Result<[Employee], Error>) -> Void) {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Employee>(entityName: "Employee")
        do {
            let employees = try context.fetch(fetchRequest)
            employees.forEach { print("name: \($0.fullName ?? "")")}
            completion(.success(employees))
        } catch let fetchError {
            print("Failed to fetch employees: ", fetchError)
            completion(.failure(fetchError))

        }
    }

}
