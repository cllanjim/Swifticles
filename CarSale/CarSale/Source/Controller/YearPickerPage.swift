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
        let cell = self.collectionView!.dequeueReusableCell(withReuseIdentifier: "year_cell", for: indexPath) as! YearPageCell
        cell.reset()
        let year = model.years[indexPath.row]
        cell.year = year
        cell.set = getImageSetForIndex(index: year.index)
        return cell
    }
    
    @IBAction func clickYear(_ button: CellHighlightButton) {
        if let cell = button.superview?.superview as? YearPageCell {
            selectedYear = cell.year
            performSegue(withIdentifier: "year_vehicle_info", sender: nil)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //selectedModel
        
        if segue.identifier == "year_vehicle_info" {
            if let vehicleInfo = segue.destination as? VehicleInfoPage {
                
                let year = selectedYear!
                let model = year.model!
                let make = model.make!
                
                vehicleInfo.setUp(withMake: make, model: model, year: year)
                
            }
        }
    }
}





