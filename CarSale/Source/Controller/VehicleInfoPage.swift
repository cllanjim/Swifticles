//
//  VehicleInfo.swift
//  CarSale
//
//  Created by Nicholas Raptis on 10/4/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

//https://a.tcimg.net/v/model_images/v1/2014/gmc/acadia/all/190x97/side
//https://a.tcimg.net/v/model_images/v1/2014/gmc/acadia/all/190x97/f3q
//https://a.tcimg.net/v/model_images/v1/2017/gmc/acadia-limited/all/360x185/side
//https://a.tcimg.net/v/model_images/v1/2017/gmc/acadia-limited/all/360x185/f3q

//Plug in the correct year / make / model / trim with data from the edmunds api, and the urls will return an image if there are matchs, or a placeholder image if nothing is there. Don't worry too much about accuracy here, as long as your app demonstrates that it can pull atleast some images correctly.

enum InfoSection : UInt32 { case dealer = 0, spec = 1 }


class VehicleInfoPage : UIViewController, WebFetcherDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, StylePickerDelegate
{
    @IBOutlet weak var stylePicker: StylePicker! {
        didSet {
            stylePicker.infoPage = self
            stylePicker.delegate = self
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView!.delegate = self
            tableView!.dataSource = self
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ApplicationController.shared.navigationController.setNavigationBarHidden(false, animated: true)
        adjustStickyHeader()
    }
    
    
    //weak var
    private var _header: PlaceholderTableHeader?
    private var headerHeight: CGFloat = 150.0
    
    @IBOutlet weak var stickyHeaderHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var stickyHeaderTopConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var stylePickerLeftConstraint: NSLayoutConstraint!
    
    var sideExpanded: Bool = true
    
    
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
            
            stylePicker.setUp(withInfoPage: self)
        }
    }
    
    func fetchDidFail(fetcher: WebFetcher, result: WebResult) {
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView!.dequeueReusableCell(withIdentifier: "locate_dealer_cell", for: indexPath) as! LocateDealerCell
        
        //let model = make.models[indexPath.row]
        cell.reset()
        //cell.titleLabel.text = model.name
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240.0
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //let model = make.models[indexPath.row]
        //selectedModel = model
        //performSegue(withIdentifier: "model_year_picker", sender: nil)
        
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return headerHeight
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if _header == nil {
            _header = PlaceholderTableHeader(frame: CGRect(x: 0.0, y: 0.0, width: view.bounds.size.width, height: headerHeight))
        }
        return _header
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        adjustStickyHeader()
    }
    
    func adjustStickyHeader() {
        let offsetY = tableView.contentOffset.y
        let insetTop = tableView.contentInset.top
        var y = -offsetY
        var height = headerHeight
        if y > insetTop {
            height += (y - insetTop)
            y = insetTop
        }
        stickyHeaderTopConstraint.constant = y
        stickyHeaderHeightConstraint.constant = height
    }
    
    func didPickStyle(picker: StylePicker, style: EdmundsStyle) {
        
    }
    
    @IBAction func clickSideExpand(_ sender: UIButton) {
        
        if sideExpanded == false {
            
            
            sideExpanded = true
            stylePickerLeftConstraint.constant = 0
            view.setNeedsUpdateConstraints()
            view.superview?.setNeedsUpdateConstraints()
            UIView.animate(withDuration: 0.4, animations: {
                [weak weakSelf = self] in
                weakSelf?.view.superview?.layoutIfNeeded()
                }, completion: nil)
            
            
        } else {
            
            sideExpanded = false
            stylePickerLeftConstraint.constant = -100.0
            view.setNeedsUpdateConstraints()
            view.superview?.setNeedsUpdateConstraints()
            UIView.animate(withDuration: 0.4, animations: {
                [weak weakSelf = self] in
                weakSelf?.view.superview?.layoutIfNeeded()
                }, completion: nil)
            
        }
        
        //@IBOutlet weak var stylePickerLeftConstraint: NSLayoutConstraint!
        //var sideExpanded: Bool = false
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}








