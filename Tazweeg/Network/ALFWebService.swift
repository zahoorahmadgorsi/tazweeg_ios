//
//  WebService.swift
//  BrandsPK
//
//  Created by Naveed on 12/1/16.
//  Copyright © 2016 Technation. All rights reserved.
//

import UIKit
import Alamofire
import AFNetworking     //used to load images on uiImageView via URL
import MOLH

typealias SuccessBlock = (_ response: AnyObject) -> Void
typealias FailureBlock = (_ response: AnyObject) -> Void

class ALFWebService: NSObject {
    static let shared = ALFWebService()
    
    private func urlString(subUrl: String) -> String {
//        Old Website URL
//        return "http://www.tazweeg.ae/api/\(subUrl)"
        //Ahsan Local URL
//        return "http://10.3.141.169/api/api/\(subUrl)"
        //Local staging server
//        return "http://192.168.2.150:5757/tazweegapi/api/\(subUrl)"
        //Local staging server
//        return "http://bulahej.dyndns.org:5757/tazweegapi/api/\(subUrl)"
        //AWS Server
//        return "https://54.196.95.55/api/api/\(subUrl)"
        return "https://tazweeg.ae/api/api/\(subUrl)"
    }
    
    /****************************  ***********************************/
    /******************* GET Method with PARAMS **********************/
    /****************************  ***********************************/
    
    func doGetData(method: String, success:@escaping SuccessBlock, fail: @escaping FailureBlock) {
        self.getMethodWithoutParams(forMethod: self.urlString(subUrl: method), success: success, fail: fail)
    }
    
    private func getMethodWithoutParams( forMethod: String, success:@escaping SuccessBlock, fail:@escaping FailureBlock){
        var headers: HTTPHeaders?
        if UserDefaults.standard.object(forKey: "deviceToken") != nil {
            headers = ["deviceToken":UserDefaults.standard.object(forKey: "deviceToken") as! String]
        } else {
            headers = [:]
        }
        headers?["deviceType"] = "1"   //1 mean ios
        print(headers as Any)
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 30
        manager.request(forMethod, method: .get, headers: headers).responseJSON { response in
//            print(headers ??  "NIL")
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    success(response.result.value as AnyObject)
                }
                break
                
            case .failure(_):
                fail(response.result.error as AnyObject)
                break
            }
        }
        
    }
    
//    func doGetData(parameters: Dictionary<String, AnyObject>,method: String, success:@escaping SuccessBlock, fail: @escaping FailureBlock) {
//        self.getMethodWithParams(parameters: parameters, method: self.urlString(subUrl: method), success: success, fail: fail)
//    }
//
//    private func getMethodWithParams(parameters: Dictionary<String, AnyObject>, method: String, success:@escaping SuccessBlock, fail:@escaping FailureBlock){
//        var headers: HTTPHeaders?
//        if UserDefaults.standard.object(forKey: "deviceToken") != nil {
//            headers = ["deviceToken":UserDefaults.standard.object(forKey: "deviceToken") as! String]
//        } else {
//            headers = [:]
//        }
//        headers?["deviceType"] = "1"   //1 mean ios
//        print(headers as Any)
//
//        let manager = Alamofire.SessionManager.default
//        manager.session.configuration.timeoutIntervalForRequest = 30
//        print(method)
//        print(parameters)
//        manager.request(method, method: .get, parameters: parameters, headers: headers).responseJSON { response in
//            print(response.result.value as Any,response.result.error as Any)
////            print(headers ?? "default value")
//            switch(response.result) {
//                case .success(_):
//                    if response.result.value != nil{
//                        success(response.result.value as AnyObject)
//                    }
//                    break
//                case .failure(_):
//                    fail(response.result.error as AnyObject)
//                    break
//            }
//        }
//
//    }
    
    
    /******************* END OF GET Method with PARAMS **********************/
    
    
    /****************************  ***********************************/
    /******************* POST Method with PARAMS *********************/
    /****************************  ***********************************/
    
    func doPostData(parameters: Dictionary<String, AnyObject>, method: String, success:@escaping SuccessBlock, fail: @escaping FailureBlock) {
        self.postMethodWithParams(parameters: parameters, forMethod: self.urlString(subUrl: method), success: success, fail: fail)
    }
    
    private func postMethodWithParams(parameters: Dictionary<String, AnyObject>, forMethod: String, success:@escaping SuccessBlock, fail:@escaping FailureBlock){
        var headers: HTTPHeaders?
        if UserDefaults.standard.object(forKey: "deviceToken") != nil {
            headers = ["deviceToken":UserDefaults.standard.object(forKey: "deviceToken") as! String]
        } else {
            headers = [:]
        }
        headers?["deviceType"] = "1"   //1 mean ios
        print(headers as Any)
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 30
//        print(headers ?? "default value")
        manager.request(forMethod, method: .post, parameters: parameters,  headers: headers).responseJSON { response in
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
//                    print(headers ?? "default value")
                    success(response.result.value as AnyObject)
                }
                break
                
            case .failure(_):
                if (response.data?.count)! > 0 {
                    fail(response.result.error as AnyObject)
                }
                else{ //When ever there is empty response e.g. when verification code is verified
                    success("Success" as AnyObject)
                }
                break
            }
        }
        
    }

    /******************* END OF POST Method with PARAMS **********************/
    
    
    /****************************  ***********************************/
    /*************** POST Method with PARAMS and IMAGE *******************/
    /****************************  ***********************************/

    
    func doPostDataWithImage(parameters: [String:String], method: String, image: UIImage?, success:@escaping SuccessBlock, fail: @escaping FailureBlock) {
        
        self.postMethodWithParamsAndImage(parameters: parameters, forMethod: self.urlString(subUrl: method), image: image, success: success, fail: fail)
    }
    private func postMethodWithParamsAndImage(parameters: [String:String], forMethod: String, image: UIImage?, success:@escaping SuccessBlock, fail:@escaping FailureBlock){
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 30
        let headers: HTTPHeaders?
        
        if UserDefaults.standard.object(forKey: "deviceToken") != nil {
            headers = ["deviceToken":UserDefaults.standard.object(forKey: "deviceToken") as! String]
        } else {
            headers = [:]
        }
        print(headers as Any)
        
        manager.upload(
            multipartFormData: { multipartFormData in
//                print(parameters)
//                print(image as Any)
                if image != nil {
                    var imgData = (image?.jpeg(.high))!
//                    print(imgData.count)
                    multipartFormData.append(imgData, withName: "signature_file", fileName: "signature_file.png", mimeType: "signature_file/png")
                }
                if !(parameters.isEmpty) {
                    for (key, value) in parameters {
//                        print("key: \(key) -> val: \(value)")
                        if let dic = value as? Dictionary<String,AnyObject>{
//                            print(key)
//                            print(value)
                            do {
                                let jsonData = try JSONSerialization.data(withJSONObject: dic, options: [])
                                let str = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
                                //                                multipartFormData.append(jsonData, withName: key)
                                multipartFormData.append(str.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
                            } catch {
                                print(error.localizedDescription)
                            }
                            
                        }else{
                            multipartFormData.append(value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
                        }
                        
                    }
                }
//                print(multipartFormData)
        },
            to: forMethod,  method: .post, headers: headers, encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        
                        success(response.result.value as AnyObject)
                    }
                case .failure(let encodingError):
                    
                    fail(encodingError as AnyObject)
                }
        })
        
        
        
        
    }
    
    //    func doPostDataWithImage(parameters: [String:String], method: String, image: UIImage?, success:@escaping SuccessBlock, fail: @escaping FailureBlock) {
    //
    //        self.postMethodWithParamsAndImage(parameters: parameters, forMethod: self.urlString(subUrl: method), image: image, success: success, fail: fail)
    //    }
    
//    private func postMethodWithParamsAndImage(parameters: [String:String], forMethod: String, image: UIImage?, success:@escaping SuccessBlock, fail:@escaping FailureBlock){
//
//        let manager = Alamofire.SessionManager.default
//        manager.session.configuration.timeoutIntervalForRequest = 30
//        var headers: HTTPHeaders?
//
//        if UserDefaults.standard.object(forKey: "ApiToken") != nil {
//            headers = ["ApiToken":UserDefaults.standard.object(forKey: "ApiToken") as! String]
//        } else {
//            headers = [:]
//        }
//
//        manager.upload(
//            multipartFormData: { multipartFormData in
//                print(parameters)
//                print(image as Any)
//                if image != nil {
//
//                    var imgData = (image?.jpeg(.high))!
//
//                    print(imgData.count)
//
//                    multipartFormData.append(imgData, withName: "signature_file", fileName: "signature_file.png", mimeType: "signature_file/png")
//
//                }
//                if !(parameters.isEmpty) {
//                    for (key, value) in parameters {
//                        print("key: \(key) -> val: \(value)")
//                        if let dic = value as? Dictionary<String,AnyObject>{
//                            print(key)
//                            print(value)
//                            do {
//                                let jsonData = try JSONSerialization.data(withJSONObject: dic, options: [])
//                                let str = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
//                                //                                multipartFormData.append(jsonData, withName: key)
//                                multipartFormData.append(str.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
//                            } catch {
//                                print(error.localizedDescription)
//                            }
//
//                        }else{
//                            multipartFormData.append(value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
//                        }
//
//                    }
//                }
//                print(multipartFormData)
//        },
//            to: forMethod,  method: .post, headers: headers, encodingCompletion: { encodingResult in
//                switch encodingResult {
//                case .success(let upload, _, _):
//                    upload.responseJSON { response in
//
//                        success(response.result.value as AnyObject)
//                    }
//                case .failure(let encodingError):
//
//                    fail(encodingError as AnyObject)
//                }
//        })
//
//
//
//
//    }
    /******************* END OF POST Method with PARAMS and IMAGE **********************/
    
}
