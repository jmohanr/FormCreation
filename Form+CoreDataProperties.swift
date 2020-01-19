//
//  Form+CoreDataProperties.swift
//  Handzap
//
//  Created by Jagan on 19/01/20.
//  Copyright © 2020 Jagan. All rights reserved.
//
//

import Foundation
import CoreData


extension Form {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Form> {
        return NSFetchRequest<Form>(entityName: "Form")
    }

    @NSManaged public var fbudget: String?
    @NSManaged public var fcurrencyType: String?
    @NSManaged public var fformDescription: String?
    @NSManaged public var fformTitle: String?
    @NSManaged public var fjobTerms: String?
    @NSManaged public var fpaymentmethod: String?
    @NSManaged public var frate: String?
    @NSManaged public var fstartDate: String?
    @NSManaged public var fuploadImage: String?
    @NSManaged public var fuploadVideo: String?

}
