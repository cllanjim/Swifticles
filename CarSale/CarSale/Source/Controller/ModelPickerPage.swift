//
//  ModelPickerPage.swift
//  CarSale
//
//  Created by Raptis, Nicholas on 10/5/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class ModelPickerPage : ThumbCollectionPage
{
    var make: EdmundsMake!
    
    weak var selectedModel: EdmundsModel?
    
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
        return make.models.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView!.dequeueReusableCell(withReuseIdentifier: "model_cell", for: indexPath) as! ModelPageCell
        cell.reset()
        let model = make.models[indexPath.row]
        cell.model = model
        cell.set = getImageSetForIndex(index: model.index)
        return cell
    }
    
    @IBAction func clickModel(_ button: CellHighlightButton) {
        if let cell = button.superview?.superview as? ModelPageCell {
            selectedModel = cell.model
            performSegue(withIdentifier: "model_year_picker", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "model_year_picker" {
            if let yearPicker = segue.destination as? YearPickerPage {
                yearPicker.navigationItem.title = selectedModel!.make.name + " " + selectedModel!.name
                yearPicker.model = selectedModel
                yearPicker.imageSets = imageSets
            }
        }
    }
}
