//
//  AppDelegate.swift
//  JsonToTableView
//
//  Created by anilkumar thatha. venkatachalapathy on 29/09/16.
//  Copyright © 2016 Anil T V. All rights reserved.
//

import Cocoa
import Foundation

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    var dataTask: URLSessionDataTask?
    let defaultSession = Foundation.URLSession(configuration:URLSessionConfiguration.default)
    @IBOutlet weak var urlTextField: NSTextField?
    var windowControllerArray : NSMutableArray = []
    var jsonData: NSMutableArray = []
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func showAlert(_ msgText: String, _ infoText: String = ""){
        let alert = NSAlert()
        alert.messageText = msgText
        alert.informativeText = infoText
        alert.alertStyle = NSInformationalAlertStyle
        alert.addButton(withTitle: "OK")
        alert.beginSheetModal(for: self.window, completionHandler: { (modalResponse) in
            if(modalResponse == NSAlertFirstButtonReturn){
                
            }
        })
    }
    
    @IBAction func loadData (_sender:NSButton) {
        let urlTextFieldString = self.urlTextField?.stringValue
        if urlTextFieldString == "" || urlTextFieldString == nil {
            self.showAlert("Enter Valid URL", "Enter URL")
        } else {
            if let url : URL = URL(string: urlTextFieldString!) {
            self.fetchFromURL(url: url)
            } else {
                self.showAlert("Enter Valid URL", "Enter URL")
            }
        }
    }
    
    @IBAction func sample1(_sender:NSButton) {
        self.fetchFromURL(url: URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=Anil")!)
    }
    
    @IBAction func sample2(_sender:NSButton) {
        self.fetchFromURL(url: URL(string: "http://time.jsontest.com")!)
    }
    
    @IBAction func sample3(_sender:NSButton) {
        self.fetchFromURL(url: URL(string: "https://jsonplaceholder.typicode.com/posts")!)
    }
    
    func openTable(withData : NSMutableArray ){
        let windowController = dynamicTableVIew(windowNibName: "dynamicTableView")
        self.windowControllerArray.add(windowController)
        windowController.tableDataArray = withData
        windowController.showWindow(self)
    }
    
    func fetchFromURL(url: URL) {
        let dataArray : NSMutableArray = []
        if dataTask != nil {
            dataTask?.cancel()
        }
        var urlHasData : Bool = false
        dataTask = defaultSession.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.showAlert(error.localizedDescription, "Try Again with Valid URL")
                }
            } else if let httpresponse = response as? HTTPURLResponse?{
                if httpresponse?.statusCode == 200 {
                    urlHasData = true
                }
            } else if (response as URLResponse?) != nil {
                urlHasData = true
            }
            
            if urlHasData{
                    do{
                        if let data = data, let response = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [String:AnyObject] {
                            let key = response.keys
                            if let array : AnyObject = response[key.first!]{
                                if array is [AnyObject] {
                                    for dict in array as! [AnyObject] {
                                        if let dict = dict as? [String : AnyObject] {
                                            dataArray.add(dict)
                                        }
                                    }
                                } else {
                                    dataArray.add(response)
                                }
                            }
                            DispatchQueue.main.async {
                                self.openTable(withData: dataArray)
                            }
                        } else {
                            if let data = data, let response = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [AnyObject] {
                                if let array = response as AnyObject?{
                                    if array is [AnyObject] {
                                        for (_, value) in response.enumerated(){
                                            dataArray.add(value)
                                        }
                                    }
                                    print(response)
                                    DispatchQueue.main.async {
                                        self.openTable(withData: dataArray)
                                    }
                                } else {
                                    print("Failed to parse JSON")
                                    DispatchQueue.main.async {
                                        self.showAlert("Failed to parse JSON", "Try Again with Valid URL")
                                    }
                                }
                            } else {
                                print("Failed to parse JSON")
                                DispatchQueue.main.async {
                                     self.showAlert("Failed to parse JSON", "Try Again with Valid URL")
                                }
                            }
                        }
                        
                    }catch let error as NSError {
                        DispatchQueue.main.async {
                            self.showAlert(error.localizedDescription, "Try Again with Valid URL")
                        }
                    }
            }
        })
        dataTask?.resume()
    }
}

