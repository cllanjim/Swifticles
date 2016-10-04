//
//  YearPickerPage.swift
//  CarSale
//
//  Created by Nicholas Raptis on 10/3/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class YearPickerPage : ThumbCollectionPage
{
    
    var model: EdmundsModel!
    weak var selectedYear: EdmundsYear?
    
    var imageSets = [ImageSet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ApplicationController.shared.navigationController.setNavigationBarHidden(false, animated: true)
    }
    
    override func getImageSetForIndex(index: Int) -> ImageSet? {
        var result:ImageSet?
        var slot = index
        if imageSets.count > 0 {
            while slot >= imageSets.count {
                slot -= imageSets.count
            }
            if slot >= 0 && slot < imageSets.count {
                result = imageSets[slot]
            }
        }
        return result
    }
    
    override func update() {
        super.update()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.years.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView!.dequeueReusableCell(withReuseIdentifier: "year_cell", for: indexPath) as! YearCell
        cell.reset()
        
        let year = model.years[indexPath.row]
        cell.year = year
        //cell.make = makes[indexPath.row]
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //selectedModel
        
        if segue.identifier == "year_picker" {
            if let yearPicker = segue.destination as? YearPickerPage {
                
                
            }
        }
    }
}





