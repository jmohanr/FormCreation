//
//  FormListViewModel.swift
//  Handzap
//
//  Created by Jagan on 19/01/20.
//  Copyright © 2020 Jagan. All rights reserved.
//

import UIKit
import CoreData

class FormListViewModel: NSObject {
    var formData = [FormModel]()
    
    func fetchingData(completion:@escaping((Bool)->(Void))){
        CoredataStack.retrieveData { (data) -> (Void) in
            self.formData = data
            completion(true)
        }
    }
    func numberOfrows()->Int{
        self.formData.count
    }
    func displayingFormTitle(row:Int)->String{
        return self.formData[row].formTitle ?? ""
    }
    func displayingSatrtDate(row:Int)->String{
        return self.formData[row].startDate ?? ""
    }
    func displayingFormjobTerm(row:Int)->String{
        if self.formData[row].jobTerms ?? "" == ""  {
            return "(Job Term)"
        }else{
        return self.formData[row].jobTerms ?? ""
    }
    }
    func displayingRate(row:Int)->String{
        if self.formData[row].rate ?? "" == "" {
            return "(Rate)"
        }else{
            return self.formData[row].rate ?? ""
        }
    }
    func deleteFormFromCoreData(title:String,completion:@escaping((Bool)->(Void))){
        CoredataStack.deleteData(formTitle: title) { (sucess) -> (Void) in
            completion(sucess)
        }
    }
}
