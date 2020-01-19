//
//  CoreDataStack.swift
//  Handzap
//
//  Created by Jagan on 19/01/20.
//  Copyright © 2020 Jagan. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoredataStack: NSObject {
    
    //MARK:-StoringData into coredata
    static  func createData(inputData:[String:Any],completion:@escaping((Bool)->(Void))){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let userEntity = NSEntityDescription.entity(forEntityName: "Form", in: managedContext)!
        let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
        user.setValue(inputData["formTitle"], forKeyPath: "formTitle")
        user.setValue(inputData["formDescription"], forKeyPath: "formDescription")
        user.setValue(inputData["budget"], forKeyPath: "budget")
        user.setValue(inputData["currencyType"], forKeyPath: "currencyType")
        user.setValue(inputData["jobTerms"], forKeyPath: "jobTerms")
        user.setValue(inputData["paymentmethod"], forKeyPath: "paymentmethod")
        user.setValue(inputData["rate"], forKeyPath: "rate")
        user.setValue(inputData["startDate"], forKeyPath: "startDate")
        user.setValue(inputData["uploadImage"], forKeyPath: "uploadImage")
        user.setValue(inputData["uploadVideo"], forKeyPath: "uploadVideo")
        
        do {
            try managedContext.save()
            completion(true)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            completion(false)
        }
    }
    
    //MARK:-Retrive data from coredata
    static func retrieveData(completion:@escaping(([FormModel])->(Void))) {
        var formData = [FormModel]()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Form")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            for inputData in result as! [NSManagedObject] {
                let formTitle = inputData.value(forKey: "formTitle") as? String
                let formDescription = inputData.value(forKey: "formDescription") as? String
                let budget = inputData.value(forKey: "budget") as? String
                let currencyType = inputData.value(forKey: "currencyType") as? String
                let jobTerms = inputData.value(forKey: "jobTerms") as? String
                let paymentmethod = inputData.value(forKey: "paymentmethod") as? String
                let rate = inputData.value(forKey: "rate") as? String
                let startDate = inputData.value(forKey: "startDate") as? String
                let dataModel = FormModel.init(formTitle: formTitle, formDescription: formDescription, jobTerms: jobTerms, paymentmethod: paymentmethod, startDate: startDate, rate: rate, budget: budget ?? "", currencyType: currencyType)
                formData.append(dataModel)
            }
            completion(formData)
            
        } catch {
            
            print("Failed")
        }
    }
    
    //MARK:-Delete data from coredata
  static func deleteData(formTitle:String,completion:@escaping((Bool)->(Void))){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Form")
        fetchRequest.predicate = NSPredicate(format: "formTitle = %@", formTitle)
        
        do
        {
            let test = try managedContext.fetch(fetchRequest)
            
            let objectToDelete = test[0] as! NSManagedObject
            managedContext.delete(objectToDelete)
            
            do{
                try managedContext.save()
                completion(true)
            }
            catch
            {
                print(error)
                completion(false)
            }
            
        }
        catch
        {
            print(error)
            completion(false)

        }
    }
}
