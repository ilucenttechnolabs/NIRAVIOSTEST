//
//  Constants.swift
//  Diary App
//
//  Created by Bhavik Darji on 04/12/20.
//

import Foundation
import SystemConfiguration
import UIKit
import Alamofire
import SwiftyJSON
import KRProgressHUD

struct Constants {
    // Server URL
    static let SERVER_API                       = ""
    static let kUserDefaults                    = UserDefaults.standard
    static let kSharedAppDelegate               = (UIApplication.shared.delegate as? AppDelegate)
    static let kDateToday                       = Date()
    static let Appname                          = "Organizator"

    static var DB_Path : String                 = ""
    
    static func IOS(x: Float) -> Bool {
        return ((Float(UIDevice.current.systemVersion) ?? 0.0 < x) ? true : false)
    }
    
    static let screenSize: CGRect = UIScreen.main.bounds
    
    

    // Server Api's myAccountApi
}

public class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
}

public class API {
    
    class func api_AlamofirePostNew(_ apiName: String, withparams parameters: [String:Any], IsLoder: Bool, sucess success: @escaping (_ response: JSON) -> Void, failure: @escaping (_ error: Error?) -> Void)
        {
            if Reachability.isConnectedToNetwork() == true
            {
                let Urlstring = "\(Constants.SERVER_API)\(apiName)"
                print ("Urlstring:: \(Urlstring)")
                print ("UrlPerms:: \(parameters)")

                if IsLoder == true
                {
                    KRProgressHUD.set(style: KRProgressHUDStyle.white)
                    KRProgressHUD.set(activityIndicatorViewColors: [.black])
                    KRProgressHUD.show()
                }
                
                
                let header:HTTPHeaders = [:]
                
                Alamofire.request(Urlstring, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: header).responseJSON { (response) in
                    switch response.result {
                    case .success:
                        
                        let result  = JSON(response.value!)
                        
//                        print("Response :: \(result)")
                        success(result)
                        KRProgressHUD.dismiss()

                        OperationQueue.main.addOperation {
                            //API call Successful and can perform other operatios
                        }
                        
                        break
                    case .failure(let error):
                        print(error)
                        failure(error)
                        KRProgressHUD.dismiss()
                    }
                }
                
            }
            else
            {
                KRProgressHUD.dismiss()
                let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
                DispatchQueue.main.async {
                    UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
                }
            }
        }
        
        
        class func api_AlamofireGetNew(_ apiName: String, withparams parameters: [String:Any], sucess success: @escaping (_ response: JSON) -> Void, failure: @escaping (_ error: Error?) -> Void)
        {
            if Reachability.isConnectedToNetwork() == true
            {
                KRProgressHUD.set(style: KRProgressHUDStyle.white)
                KRProgressHUD.set(activityIndicatorViewColors: [.black])
                KRProgressHUD.show()
                let Urlstring = "\(Constants.SERVER_API)\(apiName)"
                print ("Urlstring:: \(Urlstring)")
                print ("UrlPerms:: \(parameters)")
                
                let header:HTTPHeaders = [:]
                
                Alamofire.request(Urlstring, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: header).responseJSON { (response) in
                    switch response.result {
                    case .success:
                        
                        let result  = JSON(response.value!)
//                        print("Response :: \(result)")
                        
                        success(result)
                        KRProgressHUD.dismiss()
                        OperationQueue.main.addOperation {
                            //API call Successful and can perform other operatios
                        }
                        
                        break
                    case .failure(let error):
                        print(error)
                        failure(error)
                        KRProgressHUD.dismiss()
                        let alert = UIAlertController(title: Constants.Appname, message: "Something went wrong!\n Please try again.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
                        DispatchQueue.main.async {
                            UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
            else
            {
                KRProgressHUD.dismiss()
                let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
                DispatchQueue.main.async {
                    UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
                }

            }
        }
}

//MARK: - Date Extension

extension Date {
    var millisecondsSince1970: Int {
        return Int(timeIntervalSince1970.rounded())
    }
    
    init(milliseconds: Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
    
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfYear], from: date, to: self).weekOfYear ?? 0
    }
    
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date) > 0 { return years(from: date) > 1 ? "\(years(from: date)) years ago" : "\(years(from: date)) year ago" }
        if months(from: date) > 0 { return months(from: date) > 1 ? "\(months(from: date)) months ago" : "\(months(from: date)) month ago" }
        if weeks(from: date) > 0 { return weeks(from: date) > 1 ? "\(weeks(from: date)) weeks ago" : "\(weeks(from: date)) week ago" }
        if days(from: date) > 0 { return days(from: date) > 1 ? "\(days(from: date)) days ago" : "\(days(from: date)) day ago" }
        if hours(from: date) > 0 { return hours(from: date) > 1 ? "\(hours(from: date)) hours ago" : "\(hours(from: date)) hour ago" }
        if minutes(from: date) > 0 { return minutes(from: date) > 1 ? "\(minutes(from: date))" : "\(minutes(from: date))" }
        if seconds(from: date) > 0 { return "\(seconds(from: date)) secs ago" }
        return ""
    }
}
