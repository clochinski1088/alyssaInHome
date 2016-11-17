//
//  SecondViewController.swift
//  Lularoe
//
//  Created by Collin Lochinski on 11/14/16.
//  Copyright © 2016 Collin Lochinski. All rights reserved.
//

import UIKit

class InventoryCollectionViewController: UICollectionViewController {
    
    fileprivate let reuseIdentifier = "ItemCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    let styles : [Style] = []
    let items : [Item] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath)
        
        return cell
    }
    
    
    
    
}

