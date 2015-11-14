//
//  ConnectionManager.swift
//  Test MercadoLibre
//
//  Created by Diego Flores Domenech on 14/11/15.
//  Copyright © 2015 Diego Flores Domenech. All rights reserved.
//

import UIKit

class ConnectionManager: NSObject {
    
    static let baseURL = "https://api.mercadopago.com/v1/"
    static let paymentMethodsUri = "payment_methods"
    static let publicKey = "444a9ef5-8a6b-429f-abdf-587639155d88"
    
    private static let publicKeyString = "public_key"
    
    static func getPaymentMethods(baseURL : String, uri : String, publicKey: String, completion : (success : Bool, paymentMethods : [PaymentMethod], error : NSError?) -> ()){
        if let url = NSURL(string: baseURL + uri + "?" + publicKeyString + "=" + publicKey){
            let request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "GET"
            let queue:NSOperationQueue = NSOperationQueue()
            NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler: { (response, data, error) -> Void in
                if let data = data{
                    //check if received data
                    do{
                        //try to parse data
                        let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
                        if let jsonResult = jsonResult as? [NSDictionary]{
                            //check if received array of dictionaries (payment methods)
                            var paymentMethodsArray : [PaymentMethod] = []
                            for dictionary in jsonResult{
                                let paymentMethod = PaymentMethod(dictionary: dictionary)
                                paymentMethodsArray.append(paymentMethod)
                            }
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                completion(success: true,paymentMethods: paymentMethodsArray,error: nil)
                            })
                        }else if let jsonResult = jsonResult as? NSDictionary{
                            //check if received dictionary (possibly with error info)
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                completion(success: false, paymentMethods: [], error: NSError(dictionary: jsonResult))
                            })
                        }else{
                            //unknown error
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                completion(success: false, paymentMethods: [], error: nil)
                            })
                        }
                    }catch{
                        //unable to parse data
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completion(success: false, paymentMethods: [], error: nil)
                        })
                    }
                }else{
                    //didn't receive any data
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completion(success: false,paymentMethods: [], error: error)
                    })
                }
            })
        }else{
            //bad url
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(success: false, paymentMethods: [], error: nil)
            })
        }
    }
}

private extension NSError{
    
    convenience init(dictionary : NSDictionary) {
        self.init(domain: "API",code : 0, userInfo: dictionary as [NSObject : AnyObject])
    }
    
}
