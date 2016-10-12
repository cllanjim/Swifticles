//
//  EdmundsDealerFetcher.swift
//  CarSale
//
//  Created by Nicholas Raptis on 10/12/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import Foundation

class EdmundsDealerFetcher : JSONFetcher
{
    var dealers = [EdmundsDealer]()
    
    override func clear() {
        super.clear()
        dealers.removeAll()
    }
    
    func fetch(withZip zip: Int, make: EdmundsMake) {
        let url = "https://api.edmunds.com/api/dealer/v2/franchises?zipcode=\(zip)&make=\(make.name.urlEncode)&api_key=yfwsqhj7ymscvt5sxh32f68a"
        
        //"https://api.edmunds.com/api/vehicle/v2/styles/\(style.id)?view=full&fmt=json&api_key=yfwsqhj7ymscvt5sxh32f68a"
        fetch(url)
    }
    
    override func parse(data: Any) -> Bool {
        print(data)
        
        //Is it the expected format?
        
        guard let dic = data as? [String:Any] else {
            return false
        }

        
        guard let _franchises = dic["franchises"] as? [[String:Any]] else {
            return false
        }
        
        for _franchise in _franchises {
            
            print(_franchise)
            
            var dealer = EdmundsDealer()
            
            if dealer.load(data: _franchise) {
                dealers.append(dealer)
            }
            
            
            
            //dealers
            
        }
        
        
        
        /*
        franchises =     (
            {
                active = 1;
                address =             {
                    apartment = "";
                    city = "Beverly Hills";
                    country = USA;
                    county = "Los Angeles";
                    latitude = "34.059358";
                    longitude = "-118.384838";
                    stateCode = CA;
                    stateName = California;
                    street = "8833 W Olympic Blvd";
                    zipcode = 90211;
                };
                customZipDefined = 0;
                dealerId = 21253;
                distance = "2.229198603083367";
                franchiseId = 66481;
                make =             {
                    name = Bentley;
                    niceName = bentley;
                };
                name = "Bentley Beverly Hills";
                niceName = "AstonMartinBentleyBugattiBeverlyHills_2";
                operations =             {
                    Friday = "9:00 AM-7:00 PM";
                    Monday = "9:00 AM-7:00 PM";
                    Saturday = "10:00 AM-5:00 PM";
                    Sunday = "11:00 AM-4:00 PM";
                    Thursday = "9:00 AM-7:00 PM";
                    Tuesday = "9:00 AM-7:00 PM";
                    Wednesday = "9:00 AM-7:00 PM";
                };
                premier = 0;
                state = NEW;
                type = DEALERFRANCHISE;
            },
            {
                active = 1;
                address =             {
                    apartment = "";
                    city = Pasadena;
                    
 */
                    
        
        return dealers.count > 0
    }
}

