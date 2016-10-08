//
//  HomePage.swift
//  CarSale
//
//  Created by Nicholas Raptis on 9/28/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class HomePage : ThumbCollectionPage, WebFetcherDelegate
{
    @IBOutlet weak var header: HomePageHeader! { didSet { header.homePage = self } }
    
    @IBOutlet weak var searchResults: HomePageSearchResults! {
        didSet {
            searchResults.homePage = self
            searchResults.isHidden = true
        }
    }
    
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    
    weak var selectedMake: EdmundsMake?
    weak var selectedModel: EdmundsModel?
    
    var searchMode:Bool = false {
        didSet {
            if searchMode {
                searchResults.reset()
                animateSearchModeOn()
                header.animateSearchModeOn()
            } else {
                animateSearchModeOff()
                header.animateSearchModeOff()
            }
        }
    }
    
    private var _makeFetcher: EdmundsMakesFetcher?
    var makeFetcher: EdmundsMakesFetcher {
        if _makeFetcher == nil {
            _makeFetcher = EdmundsMakesFetcher()
            _makeFetcher!.delegate = self
        }
        return _makeFetcher!
    }
    var makes = [EdmundsMake]()
    var models = [EdmundsModel]()
    
    private var _imgFetcher: ImageSetFetcher?
    var imgFetcher: ImageSetFetcher {
        if _imgFetcher == nil {
            _imgFetcher = ImageSetFetcher()
            _imgFetcher!.delegate = self
        }
        return _imgFetcher!
    }
    var imageSets = [ImageSet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        header.searchResults = searchResults
        makeFetcher.fetchAllMakes()
        imgFetcher.fetchImageSets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ApplicationController.shared.navigationController.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { [weak weakSelf = self] (id:UIViewControllerTransitionCoordinatorContext) in

            }, completion: nil)
    }
    
    func fetchDidSucceed(fetcher: WebFetcher, result: WebResult) {
        //Don't know which order these will come back,
        //syncImages handles the case when both are ready.
        if fetcher === makeFetcher {
            print("___\nFetched Makes!\n___")
            makes = makeFetcher.makes
            makeFetcher.clear()
            syncImages()
            
            buildSearchTree()
            
        } else if fetcher === imgFetcher {
            print("___\nFetched Image Sets!\n___")
            imageSets = imgFetcher.sets
            imgFetcher.clear()
            syncImages()
        }
    }
    
    func fetchDidFail(fetcher: WebFetcher, result: WebResult) {
        //Present some type of error indicator to the user.
    }
    
    //A way to search through all the cars by model / make.
    //For example: "Lincoln Navigator" or "Lincoln" or "Navigator"
    //Pre-Condition: makes has been populated.
    func buildSearchTree() {
        models.removeAll()
        var makeIndex:Int = 0
        for make in makes {
            if make.name.characters.count > 0 {
                var modelIndex:Int = 0
                for model in make.models {
                    if model.name.characters.count > 0 {
                        models.append(model)
                        modelIndex += 1
                    }
                }
                makeIndex += 1
            }
        }
        searchResults.buildSearchTree(models: models)
    }
    
    func syncImages() {
        guard imageSets.count > 0 && makes.count > 0 else {
            //Show placeholder cells even if thumbs haven't come in..
            if makes.count > 0 {
                reloadData()
            }
            return
        }
        for i in 0..<makes.count {
            makes[i].set = getImageSetForIndex(index: i)
        }
        reloadData()
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
        return makes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView!.dequeueReusableCell(withReuseIdentifier: "car_cell", for: indexPath) as! HomePageMakeCell
        cell.reset()
        cell.make = makes[indexPath.row]
        return cell
    }
    
    @IBAction func clickMakeCell(_ button:CellHighlightButton) {
        if let cell = button.superview?.superview as? HomePageMakeCell {
            selectedMake = cell.make
            //performSegue(withIdentifier: "model_picker", sender: nil)
            performSegue(withIdentifier: "alt_model_picker", sender: nil)
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "year_picker" {
            if let yearPicker = segue.destination as? YearPickerPage {
                yearPicker.navigationItem.title = selectedModel!.make.name + " " + selectedModel!.name
                yearPicker.model = selectedModel
                yearPicker.imageSets = imageSets
            }
        }
        
        if segue.identifier == "model_picker" {
            if let modelPicker = segue.destination as? ModelPickerPage {
                modelPicker.navigationItem.title = selectedMake!.name
                modelPicker.imageSets = imageSets
                modelPicker.make = selectedMake!
            }
        }
        
        if segue.identifier == "alt_model_picker" {
            if let modelPicker = segue.destination as? AltModelPickerPage {
                modelPicker.navigationItem.title = selectedMake!.name
                modelPicker.imageSets = imageSets
                modelPicker.make = selectedMake!
            }
        }
    }
    
    
    
    internal func animateSearchModeOn() {
        headerHeightConstraint.constant = 78 - 20.0//Device.statusBarHeight
        view.setNeedsLayout()
        UIView.animate(withDuration: 0.42, delay: 0.0, options: .transitionCrossDissolve, animations: { [weak weakSelf = self] in
            weakSelf?.view.layoutIfNeeded()
            }, completion: nil)
        searchResults.animateIn()
    }
    
    internal func animateSearchModeOff() {
        headerHeightConstraint.constant = 78
        view.setNeedsLayout()
        UIView.animate(withDuration: 0.42, delay: 0.0, options: .transitionCrossDissolve, animations: { [weak weakSelf = self] in
            weakSelf?.view.layoutIfNeeded()
            }, completion: nil)
        searchResults.animateOut()
    }
    
    
    
}





