//
//  DealerPickerPage.swift
//  CarSale
//
//  Created by Raptis, Nicholas on 10/12/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class DealerPickerPage : UIViewController, UITableViewDelegate, UITableViewDataSource, WebFetcherDelegate
{
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView!.delegate = self
            tableView!.dataSource = self
        }
    }
    
    var dealers = [EdmundsDealer]()
    
    
    var _dealerFetcher: EdmundsDealerFetcher?
    var dealerFetcher: EdmundsDealerFetcher {
        if _dealerFetcher == nil {
            _dealerFetcher = EdmundsDealerFetcher()
            _dealerFetcher!.delegate = self
        }
        return _dealerFetcher!
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dealerFetcher.fetch(withZip: 90069, make: ApplicationController.shared.selectedMake!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ApplicationController.shared.navigationController.setNavigationBarHidden(false, animated: true)
    }
    
    func fetchDidSucceed(fetcher: WebFetcher, result: WebResult) {
        
        if fetcher === dealerFetcher {
            dealers = dealerFetcher.dealers
            dealerFetcher.clear()
            
            tableView.reloadData()
        }
        
    }
    
    func fetchDidFail(fetcher: WebFetcher, result: WebResult) {
        
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return make.models.count
        return dealers.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView!.dequeueReusableCell(withIdentifier: "dealer_cell", for: indexPath) as! DealerPickerCell
        
        let dealer = dealers[indexPath.row]
        
        cell.reset()
        
        cell.titleLabel.text = dealer.name
        
        return cell
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //let model = make.models[indexPath.row]
        //selectedModel = model
        //performSegue(withIdentifier: "model_year_picker", sender: nil)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "model_year_picker" {
            /*
            if let yearPicker = segue.destination as? YearPickerPage {
                yearPicker.navigationItem.title = selectedModel!.make.name + " " + selectedModel!.name
                yearPicker.model = selectedModel
                yearPicker.imageSets = imageSets
            }
            */
        }
    }
}


