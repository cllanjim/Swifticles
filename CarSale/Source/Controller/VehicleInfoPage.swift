//
//  VehicleInfo.swift
//  CarSale
//
//  Created by Nicholas Raptis on 10/4/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

//Unforunately there is no free image apis available for cars, but luckily we can use truecar's image urls for our demo needs, here are some sample urls:

//https://a.tcimg.net/v/model_images/v1/2014/gmc/acadia/all/190x97/side
//https://a.tcimg.net/v/model_images/v1/2014/gmc/acadia/all/190x97/f3q
//https://a.tcimg.net/v/model_images/v1/2017/gmc/acadia-limited/all/360x185/side
//https://a.tcimg.net/v/model_images/v1/2017/gmc/acadia-limited/all/360x185/f3q

//Plug in the correct year / make / model / trim with data from the edmunds api, and the urls will return an image if there are matchs, or a placeholder image if nothing is there. Don't worry too much about accuracy here, as long as your app demonstrates that it can pull atleast some images correctly.


class VehicleInfoPage : UIViewController, WebFetcherDelegate
{
    
    var styles = [EdmundsStyle]()
    
    weak var make: EdmundsMake?
    weak var model: EdmundsModel?
    weak var year: EdmundsYear?
    
    func setUp(withMake make: EdmundsMake, model: EdmundsModel, year: EdmundsYear) {
        self.make = make
        self.model = model
        self.year = year
        
        navigationItem.title = "\(year.year) \(model.name)"
        
        print("GET VEHICLE INFO")
        print("MAKE = \(make.name)")
        print("MODEL = \(model.name)")
        print("YEAR = \(year.year)")
        
        styleFetcher.fetch(make: make, model: model, year: year)
    }
    
    private var _styleFetcher: EdmundsStyleFetcher?
    var styleFetcher: EdmundsStyleFetcher {
        if _styleFetcher == nil {
            _styleFetcher = EdmundsStyleFetcher()
            _styleFetcher!.delegate = self
        }
        return _styleFetcher!
    }
    var makes = [EdmundsMake]()
    var models = [EdmundsModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //infoFetcher.fetchAllMakes()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ApplicationController.shared.navigationController.setNavigationBarHidden(false, animated: true)
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
        
        if fetcher === styleFetcher {
            
            styles = styleFetcher.styles
            styleFetcher.clear()
            
            print(styles)
        }
    }
    
    func fetchDidFail(fetcher: WebFetcher, result: WebResult) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}








