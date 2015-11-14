//
//  ViewController.swift
//  Test MercadoLibre
//
//  Created by Diego Flores Domenech on 14/11/15.
//  Copyright © 2015 Diego Flores Domenech. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let titleString = "Test MercadoLibre"
    private let cellIdentifier = "cellIdentifier"
    private var paymentMethods : [PaymentMethod] = []
    
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = titleString
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        activityIndicator.hidesWhenStopped = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadPaymentMethods()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: load data
    
    func loadPaymentMethods(){
        let baseURL = ConnectionManager.baseURL
        let uri = ConnectionManager.paymentMethodsUri
        let publicKey = ConnectionManager.publicKey
        activityIndicator.startAnimating()
        ConnectionManager.getPaymentMethods(baseURL, uri: uri, publicKey: publicKey) { (success, paymentMethods, error) -> () in
            self.activityIndicator.stopAnimating()
            if success{
                self.paymentMethods = paymentMethods.filter({ (paymentMethod) -> Bool in
                    return paymentMethod.paymentTypeId == PaymentMethod.paymentTypeCreditCard
                })
                self.tableView.reloadData()
            }else{
                let alertController = UIAlertController(title: self.titleString, message: "Imposible conectarse con el servidor", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Default, handler: { (alertAction) -> Void in
                    
                })
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                if let error = error{
                    print(error)
                }
            }
        }
    }
    
}

//MARK: UITableView datasource

extension ViewController : UITableViewDataSource{
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        if let cell = cell{
            let paymentMethod = paymentMethods[indexPath.row]
            cell.selectionStyle = .None
            cell.textLabel?.text = paymentMethod.name
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentMethods.count
    }
    
}
