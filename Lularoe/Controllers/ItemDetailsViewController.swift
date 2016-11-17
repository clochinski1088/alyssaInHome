//
//  ItemDetailsViewController.swift
//  Lularoe
//
//  Created by Collin Lochinski on 11/16/16.
//  Copyright © 2016 Collin Lochinski. All rights reserved.
//

import UIKit

class ItemDetailsViewController: UIViewController {

    @IBOutlet weak var itemIDLbl: UILabel!
    
    var itemID : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        if let itemIDLbl = itemIDLbl, let itemID = itemID {
            itemIDLbl.text = itemID
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
