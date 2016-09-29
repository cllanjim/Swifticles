//
//  ViewController.swift
//  WeatherDawg
//
//  Created by Nicholas Raptis on 3/23/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController, WebServiceDelegate, LocationGrabberDelegate, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var navigationItemTitle: UINavigationItem!
    
    @IBOutlet weak var navigationBarTop: UINavigationBar!
    @IBOutlet weak var tableViewWeather: UITableView!
    @IBOutlet weak var viewLoadOverlay: UIView!
    @IBOutlet weak var activityIndicatorLoad: UIActivityIndicatorView!
    
    @IBOutlet weak var viewRefreshBar: UIView!
    @IBOutlet weak var activityIndicatorRefresh: UIActivityIndicatorView!
    
    private var refreshFirst:Bool = true
    private var refreshDistance:CGFloat = 48.0
    private var refreshTripped:Bool = false
    var refresh:Bool = true
    private var refreshLocation:Bool = true
    
    var arrayWeatherNodes:NSMutableArray = NSMutableArray(capacity: 16)
    
    let locationGrabber:LocationGrabber = LocationGrabber.sharedInstance;
    
    var webServiceWeather:WebService!
    var weekday:Int = 1
    
    
    var background:Bool = false
    var timerRefresh:NSTimer!
    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier?
    
    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        backgroundTaskIdentifier = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({
            UIApplication.sharedApplication().endBackgroundTask(self.backgroundTaskIdentifier!)
        })
        
        activityIndicatorLoad.startAnimating()
        activityIndicatorRefresh.startAnimating()
        
        tableViewWeather.userInteractionEnabled = false
        tableViewWeather.dataSource = self
        tableViewWeather.delegate = self
        tableViewWeather.reloadData()
        
        locationGrabber.delegate = self;
        
        weekday = getDayOfWeek()
        
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        
        //refreshBegin(false)
        timerRefresh = NSTimer.scheduledTimerWithTimeInterval(1800, target: self, selector: "refreshBeginTimer", userInfo: nil, repeats: true)
    }
    
    internal func parse(data:AnyObject!) -> Bool
    {
        if(data == nil){return false;}
        if(data.isKindOfClass(NSDictionary) == false){return false;}
        
        var result:Bool = false
        let rootDic:NSDictionary! = data as! NSDictionary
        
        if(rootDic != nil)
        {
            let cityDic:NSDictionary! = gParse.dicGetDic("city", pDic: rootDic)
            
            if(cityDic != nil)
            {
                let cityName:String = gParse.dicGetStr("name", pDic: cityDic)
                self.title = cityName
                navigationItemTitle.title = cityName
            }
            
            let list:NSArray! = gParse.dicGetArr("list", pDic: rootDic)
            
            if(list != nil)
            {
                while(arrayWeatherNodes.count < list.count)
                {
                    let node:WeatherNode = WeatherNode()
                    arrayWeatherNodes.addObject(node)
                }
                
                for var index:NSInteger=0; index<list.count; index++
                {
                    let obj:AnyObject! = list.objectAtIndex(index)
                    if(obj.isKindOfClass(NSDictionary))
                    {
                        let weather:NSDictionary! = obj as! NSDictionary
                        if(weather != nil)
                        {
                            result = true
                            
                            let node:WeatherNode! = arrayWeatherNodes.objectAtIndex(index) as! WeatherNode
                            node.loadFromDic(dic: weather)
                        }
                    }
                }
            }
        }
        return result
    }
    
    func webServiceDidStart(ws: WebService){}
    
    func webServiceDidSucceed(ws: WebService)
    {
        parse(ws.data)
        
        if(refresh){
            refreshComplete()
        }
    }
    
    func webServiceDidFail(ws: WebService)
    {
        if(refresh){
            refreshComplete()
        }
    }
    func webServiceDidReceiveResponse(ws: WebService){}
    func webServiceDidUpdate(ws: WebService){}
    
    
    func getDayOfWeek()->Int
    {
        let todayDate:NSDate = NSDate()
        let myCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        let myComponents = myCalendar?.components(NSCalendarUnit.Weekday, fromDate: todayDate)
        let weekDay:Int = Int((myComponents?.weekday)!)
        return weekDay
    }
    
    func refreshBegin(fromDrag:Bool)
    {
        tableViewWeather.userInteractionEnabled = false
        
        if(fromDrag == true)
        {
            tableViewWeather.setContentOffset(CGPoint(x: 0, y: -refreshDistance), animated: true);
        }
        else
        {
            tableViewWeather.setContentOffset(CGPoint(x: 0, y: 0.0), animated: true);
        }
        
        refreshLocation = true
        refresh = true
        
        //always start the pipeline with location grabber.. just in
        //case the user has enabled location in settings.
        locationGrabber.requestLocation()

        
        if(timerRefresh != nil)
        {
            timerRefresh.invalidate()
            timerRefresh = nil
        }
        
        timerRefresh = NSTimer.scheduledTimerWithTimeInterval(1800, target: self, selector: "refreshBeginTimer", userInfo: nil, repeats: true)
    }
    
    func refreshBeginTimer(){
        if(refresh == false){
            refreshBegin(false)
        }
    }
    
    func webServiceURL()->String
    {
        var url:String = "http://api.openweathermap.org/data/2.5/forecast/daily?lat="
        url = url.stringByAppendingString(String(locationGrabber.lat))
        url = url.stringByAppendingString("&lon=")
        url = url.stringByAppendingString(String(locationGrabber.lon))
        url = url.stringByAppendingString("&cnt=16&id=524901&appid=2d4f24b2fc1f6608d08fcd3b30c3cda3")
        return url
    }
    
    internal func refreshWebService()
    {
        if(webServiceWeather != nil){webServiceWeather.cancel()}
        
        let url:String = webServiceURL()
        
        webServiceWeather = WebService(url: url, requestType: WebServiceRequestType.RequestDefault, dataType: WebServiceDataType.TypeJSON)
        webServiceWeather.delegate = self
        webServiceWeather.start()
    }
    
    internal func refreshCompleteMainThread()
    {
        weekday = getDayOfWeek()
        
        tableViewWeather.userInteractionEnabled = true
        
        if(refreshTripped)
        {
            tableViewWeather.setContentOffset(CGPoint(x: 0, y: 0), animated: true);
            refreshTripped = false
        }
        tableViewWeather.reloadData()
        
        if(background == true)
        {
            var sendNotification:Bool = false
            
            if(arrayWeatherNodes.count > 1)
            {
                let node1:WeatherNode = arrayWeatherNodes.objectAtIndex(0) as! WeatherNode
                let node2:WeatherNode = arrayWeatherNodes.objectAtIndex(1) as! WeatherNode
                
                if(node1.main.lowercaseString.containsString("rain")){sendNotification = true}
                if(node2.main.lowercaseString.containsString("rain")){sendNotification = true}
            }
            
            if(sendNotification)
            {
                let notification = UILocalNotification()
                notification.timeZone = NSTimeZone.defaultTimeZone()
                notification.fireDate = NSDate()
                notification.alertBody = "WARNING: It's going to rain soon!"
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
            }
        }
        
        refresh = false
    }
    
    func refreshComplete()
    {
        if(refreshFirst)
        {
            refreshFirst = false;
            
            UIView.animateWithDuration(Double(0.3), delay: 0.7, options: UIViewAnimationOptions.TransitionNone , animations:
                {
                    self.viewLoadOverlay.alpha = 0.0
                    self.viewLoadOverlay.userInteractionEnabled = false
                    
                }, completion: nil)
        }
        
        //Prevent instant-snapback..
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 266 * Int64(NSEC_PER_MSEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.refreshCompleteMainThread()
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 16
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell:WeatherCell? = (tableView.dequeueReusableCellWithIdentifier("weather_cell") as! WeatherCell)
        
        if(cell == nil)
        {
            cell = WeatherCell(style: UITableViewCellStyle.Default, reuseIdentifier: "weather_cell")
        }
        
        let row:Int = indexPath.row
        
        if((row >= 0) && (row < arrayWeatherNodes.count))
        {
            let node:WeatherNode = arrayWeatherNodes.objectAtIndex(row) as! WeatherNode
            let day:Int = (weekday + row - 1) % 7;
            
            if(day == 1){cell!.labelWeekday.text = "Monday"}
            else if(day == 2){cell!.labelWeekday.text = "Tuesday"}
            else if(day == 3){cell!.labelWeekday.text = "Wednesday"}
            else if(day == 4){cell!.labelWeekday.text = "Thursday"}
            else if(day == 5){cell!.labelWeekday.text = "Friday"}
            else if(day == 6){cell!.labelWeekday.text = "Saturday"}
            else {cell!.labelWeekday.text = "Sunday"}
            
            cell!.labelTempMin.text = String(Int(node.tempMin + 0.5))
            cell!.labelTempMax.text = String(Int(node.tempMax + 0.5))
            cell!.labelMain.text = node.main
            cell!.labelDesc.text = node.desc
        }
        
        return cell!
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        if(refresh == false)
        {
            let dist:CGFloat = -refreshDistance;
            
            if(self.tableViewWeather.contentOffset.y < dist)
            {
                refreshTripped = true;
            }
            else
            {
                refreshTripped = false;
            }
            
            if(self.tableViewWeather.contentOffset.y < 0)
            {
                var factor:CGFloat = (self.tableViewWeather.contentOffset.y) / dist
                
                if(factor > 0)
                {
                    if(factor > 1){factor = 1}
                    activityIndicatorRefresh.transform = CGAffineTransformMakeScale(factor, factor)
                    activityIndicatorRefresh.alpha = factor
                }
                else
                {
                    activityIndicatorRefresh.alpha = 0.0
                    activityIndicatorRefresh.transform = CGAffineTransformIdentity;
                }
            }
            else
            {
                activityIndicatorRefresh.alpha = 0.0
                activityIndicatorRefresh.transform = CGAffineTransformIdentity;
            }
        }
        else
        {
            activityIndicatorRefresh.alpha = 1.0
            activityIndicatorRefresh.transform = CGAffineTransformIdentity;
        }
    }
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView)
    {
        if((refreshTripped == true) && (refresh == false))
        {
            refreshBegin(true)
        }
    }
    
    func locationDidFail(loc: LocationGrabber)
    {
        if(refreshLocation == true)
        {
            refreshLocation = false
            refreshWebService()
        }
    }
    
    func locationDidSucceed(loc: LocationGrabber)
    {
        //locationDidUpdate gets called too
    }
    
    func locationDidUpdate(loc: LocationGrabber)
    {
        if(refreshLocation == true)
        {
            refreshLocation = false
            refreshWebService()
        }
    }
    
    func enterBackground()
    {
        background = true
    }
    
    func enterForeground()
    {
        background = false
    }
    
}

