//
//  PaymentMethod.swift
//  Test MercadoLibre
//
//  Created by Diego Flores Domenech on 14/11/15.
//  Copyright © 2015 Diego Flores Domenech. All rights reserved.
//

import UIKit

class PaymentMethod{
    
    static let paymentTypeCreditCard = "credit_card"
    
    let idKey = "id"
    let nameKey = "name"
    let paymentTypeIdKey = "payment_type_id"
    
    var id : String = ""
    var name : String = ""
    var paymentTypeId : String = ""
    
    init(dictionary : NSDictionary){
        if let id = dictionary[idKey] as? String{
            self.id = id
        }
        if let name = dictionary[nameKey] as? String{
            self.name = name
        }
        if let paymentTypeId = dictionary[paymentTypeIdKey] as? String{
            self.paymentTypeId = paymentTypeId
        }
    }
    
}
