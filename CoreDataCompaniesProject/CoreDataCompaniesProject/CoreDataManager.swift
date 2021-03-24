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

    func fetchCompanies() -> [Company] {
        let context = persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        do {
            let companies = try context.fetch(fetchRequest)
            return companies
        } catch let fetchError {
            print("Failed to fetch companies:", fetchError)
            return []
        }
    }

    func resetCompanies(companies: [Company], completion: @escaping ([IndexPath]) -> Void) {
        let context = persistentContainer.viewContext

        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
        do {
            try context.execute(batchDeleteRequest)
            var indexPathsToRemove: [IndexPath] = .init()
            for (index, _) in companies.enumerated() {
                let indexPath = IndexPath(row: index, section: 0)
                indexPathsToRemove.append(indexPath)
            }
            completion(indexPathsToRemove)
        } catch let deleteError {
            print("Failed to delete: ", deleteError)
        }
    }

    func createEmployee(name: String, completion: @escaping(Employee?, Error?) -> Void) {
        let context = persistentContainer.viewContext

        guard let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context) as? Employee else { return }
        employee.setValue(name, forKey: "name")
        do {
            try context.save()
            completion(employee, nil)
        } catch let createError {
            print("Failed to create Employee: ", createError)
            completion(nil, createError)
        }
    }

    func fetchEmployees() -> [Employee] {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Employee>(entityName: "Employee")
        do {
            let employees = try context.fetch(fetchRequest)
            employees.forEach { print("name: \($0.name ?? "")")}
            return employees
        } catch let fetchError {
            print("Failed to fetch employees: ", fetchError)
            return []
        }
    }

}
