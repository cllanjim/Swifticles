//
//  VehicleInfo.swift
//  CarSale
//
//  Created by Nicholas Raptis on 10/4/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

//https://api.edmunds.com/api/vehicle/v2/styles/200487199?view=full&fmt=json&api_key=

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
        
        //spoofLoad()
    }
    
    var sections = [TableSection]()
    
    func spoofLoad() {
        
        let _make = EdmundsMake()
        _make.name = "Buick"
        _make.id = 200006659
        
        let _model = EdmundsModel()
        _model.name = "Encore"
        _model.id = "Buick_Encore"
        
        let _year = EdmundsYear()
        _year.year = 2017
        _year.id = 401631197
        
        setUp(withMake: _make, model: _model, year: _year)
    }
    
    //90069
    
    //weak var
    private var _header: PlaceholderTableHeader?
    private var headerHeight: CGFloat = 150.0
    
    @IBOutlet weak var stickyHeaderHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var stickyHeaderTopConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var stylePickerLeftConstraint: NSLayoutConstraint!
    
    var sideExpanded: Bool = true
    
    var styleDetail: EdmundsStyleExtended?
    
    var styles = [EdmundsStyle]()
    
    weak var make: EdmundsMake?
    weak var model: EdmundsModel?
    weak var year: EdmundsYear?
    
    func setUp(withMake make: EdmundsMake, model: EdmundsModel, year: EdmundsYear) {
        self.make = make
        self.model = model
        self.year = year
        
        ApplicationController.shared.selectedMake = make
        
        navigationItem.title = "\(year.year) \(model.name)"
        styleFetcher.fetch(make: make, model: model, year: year)
    }
    
    
    //EdmundsStyleDetailFetcher
    
    
    private var _styleFetcher: EdmundsStyleFetcher?
    var styleFetcher: EdmundsStyleFetcher {
        if _styleFetcher == nil {
            _styleFetcher = EdmundsStyleFetcher()
            _styleFetcher!.delegate = self
        }
        return _styleFetcher!
    }
    
    private var _detailFetcher: EdmundsStyleDetailFetcher?
    var detailFetcher: EdmundsStyleDetailFetcher {
        if _detailFetcher == nil {
            _detailFetcher = EdmundsStyleDetailFetcher()
            _detailFetcher!.delegate = self
        }
        return _detailFetcher!
    }
    
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
        
        if fetcher === detailFetcher {
            styleDetail = detailFetcher.styleDetail
            detailFetcher.clear()
            reloadData()
        }
        
    }
    
    func fetchDidFail(fetcher: WebFetcher, result: WebResult) {
        
    }
    
    func reloadData() {
        
        sections.removeAll()
        
        let dealerSection = TableSection(type:.dealer, count:1, id: nil)
        sections.append(dealerSection)
        
        if let detail = styleDetail {
            
            if detail.doorCount.characters.count > 0 {
                
                let doorSection = TableSection(type:.stat, count:1, id: "door_count")
                sections.append(doorSection)
                
            }
            
            if detail.mpg != nil {
                let mpgSection = TableSection(type:.mpg, count:1, id: nil)
                sections.append(mpgSection)
            }
            
            //stat_cell
            
        }
        
        
        tableView.reloadData()
        
        
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let section = sections[indexPath.section]
        
        if section.type == .dealer {
            let cell = self.tableView!.dequeueReusableCell(withIdentifier: "locate_dealer_cell", for: indexPath) as! LocateDealerCell
            cell.reset()
            return cell
        } else if section.type == .mpg {
            let cell = self.tableView!.dequeueReusableCell(withIdentifier: "mpg_cell", for: indexPath) as! MPGCell
            cell.reset()
            
            cell.cityLabel?.text = styleDetail?.mpg?.city
            cell.highwayLabel?.text = styleDetail?.mpg?.highway
            
            return cell
            
        } else {
            
            let cell = self.tableView!.dequeueReusableCell(withIdentifier: "stat_cell", for: indexPath) as! StatCell
            
            cell.reset()
            
            if section.id == "door_count" {
                cell.titleLabel?.text = "Number of Doors:"
                cell.valueLabel?.text = styleDetail!.doorCount
            }
            
            return cell
            
        }
        
        
        
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let section = sections[indexPath.section]
        
        if section.type == .dealer {
            return 240.0
        } else if section.type == .mpg {
            return 68.0
        }else if section.type == .stat {
            return 44.0
        }
        
        
        //let doorSection = TableSection(type:.stat, count:1, id: "door_count")
        //sections.append(doorSection)
        
        return 110.0
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int
    {
        return sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //let model = make.models[indexPath.row]
        //selectedModel = model
        //performSegue(withIdentifier: "model_year_picker", sender: nil)
        
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if section == 0 {
            return headerHeight
        }
        
            return 0.0
        
        
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if section == 0 {
        if _header == nil {
            _header = PlaceholderTableHeader(frame: CGRect(x: 0.0, y: 0.0, width: view.bounds.size.width, height: headerHeight))
        }
        return _header
        }
        return nil
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
        
        detailFetcher.fetch(style: style)
        
    }
    
    
    
    @IBAction func clickLocateDealer(_ sender: AnyObject) {
        
        performSegue(withIdentifier: "dealer_picker", sender: nil)
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








