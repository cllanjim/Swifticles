import UIKit

class WeatherNode : NSObject
{
    
    var name:String! = nil
    var id:Int! = 0
    
    var clouds:Bool = false
    var degrees:CGFloat = 72.0
    var humidity:CGFloat = 80.0
    
    var tempMin:CGFloat = 72.0
    var tempMax:CGFloat = 72.0
    
    var desc:String = "???"
    var main:String = "???"
    
    
    func loadFromDic(dic dic:NSDictionary)
    {
        //print("load from dic")
        //print(dic)
        
        
        let dicTemp:NSDictionary! = gParse.dicGetDic("temp", pDic: dic)
        
        if(dicTemp != nil)
        {
            tempMin = CGFloat(gParse.dicGetFloat("min", pDic: dicTemp))
            tempMax = CGFloat(gParse.dicGetFloat("max", pDic: dicTemp))
            
            //degrees K to degrees F
            tempMin = (tempMin - 273.15) * 1.8 + 32.0
            tempMax = (tempMax - 273.15) * 1.8 + 32.0
        }
        
        //just pick description from any weather info, there appears
        //to always be 1
        let arrayWeather:NSArray = gParse.dicGetArr("weather", pDic: dic)
        for var index:NSInteger=0; index<arrayWeather.count; index++
        {
            let obj:AnyObject! = arrayWeather.objectAtIndex(index)
            if(obj.isKindOfClass(NSDictionary))
            {
                let info:NSDictionary! = obj as! NSDictionary
                if(info != nil)
                {
                    main = gParse.dicGetStr("main", pDic: info)
                    desc = gParse.dicGetStr("description", pDic: info)
                    
                    //print(main)
                }
            }
        }
    }
    
}
