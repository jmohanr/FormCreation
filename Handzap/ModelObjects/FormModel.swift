//
//  FormModel.swift
//  Handzap
//
//  Created by Jagan on 19/01/20.
//  Copyright © 2020 Jagan. All rights reserved.
//

import Foundation
class FormModel {
    var formTitle:String?
    var formDescription:String?
    var jobTerms:String?
    var paymentmethod:String?
    var startDate:String?
    var rate:String?
    var budget:String?
    var currencyType:String?

    init( formTitle:String?,formDescription:String?,jobTerms:String?, paymentmethod:String?,startDate:String?,rate:String?,budget:String,currencyType:String?) {
    self.formTitle = formTitle
    self.formDescription = formDescription
    self.jobTerms = jobTerms
    self.paymentmethod = paymentmethod
    self.startDate = startDate
    self.rate = rate
    self.budget = budget
    self.currencyType = currencyType
    }

}
struct FormTypeData {
    var selectedtype:String?
    var data:[String]?
}
struct UploadedDataArray {
    var fileName:URL?
    var fileType:String? = ""
}
