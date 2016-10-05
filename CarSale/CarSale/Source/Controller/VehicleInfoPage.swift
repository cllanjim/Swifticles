//
//  VehicleInfo.swift
//  CarSale
//
//  Created by Nicholas Raptis on 10/4/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class VehicleInfoPage : UIViewController, WebFetcherDelegate
{
    
    weak var make: EdmundsMake?
    weak var model: EdmundsModel?
    weak var year: EdmundsYear?
    
    func setUp(withMake make: EdmundsMake, model: EdmundsModel, year: EdmundsYear) {
        self.make = make
        self.model = model
        self.year = year
    }
    
    private var _infoFetcher: EdmundsMakesFetcher?
    var infoFetcher: EdmundsMakesFetcher {
        if _infoFetcher == nil {
            _infoFetcher = EdmundsMakesFetcher()
            _infoFetcher!.delegate = self
        }
        return _infoFetcher!
    }
    var makes = [EdmundsMake]()
    var models = [EdmundsModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //infoFetcher.fetchAllMakes()
        
        
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
            if let checkSelf = weakSelf {
                
            }
            }, completion: nil)
    }
    
    func fetchDidSucceed(fetcher: WebFetcher, result: WebResult) {
        
    }
    
    func fetchDidFail(fetcher: WebFetcher, result: WebResult) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "year_picker" {
            if let yearPicker = segue.destination as? YearPickerPage {
                
            }
        }
    }
}








