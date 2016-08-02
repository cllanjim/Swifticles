//
//  ViewController.swift
//  CollectionTest
//
//  Created by Raptis, Nicholas on 8/1/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            
            
            let cellNIB = UINib.init(nibName: "DemoViewCell", bundle: nil)
            collectionView.registerNib(cellNIB, forCellWithReuseIdentifier: "generic_cell")
            collectionView.dataSource = self
            
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: 220.0, height: 390.0)
            layout.scrollDirection = .Horizontal
            
            collectionView.setCollectionViewLayout(layout, animated: false)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 5
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
        
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //let item = currentArrangement[indexPath.section].items[indexPath.item]
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("generic_cell", forIndexPath: indexPath)
        
        //cell.frame = self.view.frame
        
        cell.backgroundColor = UIColor.redColor()
            if indexPath.row == 1 {
                cell.backgroundColor = UIColor.greenColor()
            }
        if indexPath.row == 2 {
            cell.backgroundColor = UIColor.yellowColor()
        }
        if indexPath.row == 3 {
            cell.backgroundColor = UIColor.cyanColor()
        }
        if indexPath.row == 4 {
            cell.backgroundColor = UIColor.orangeColor()
        }
        
        return cell
    }
    
    
}

