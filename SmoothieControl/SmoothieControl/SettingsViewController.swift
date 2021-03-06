//
//  SettingsViewController.swift
//  SmoothieControl
//
//  Created by quillford on 2/16/15.
//  Copyright (c) 2015 quillford. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var ipField: UITextField!
    var userDefaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var restoreIP = userDefaults.stringForKey("ip")
        if (restoreIP != nil){
            var ip = userDefaults.stringForKey("ip")!
            ipField.text = "\(ip)"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func setIP(sender: AnyObject) {
        var ipAddress: String = ipField.text
        userDefaults.setObject(ipAddress, forKey: "ip")
        
        //dismiss keyboard
        self.view.endEditing(true)
    }
    
    @IBAction func testConnection(sender: AnyObject) {
        userDefaults.setObject(ipField.text, forKey: "ip")
        
        if let ipAddress: AnyObject = userDefaults.objectForKey("ip") {
            var ip = userDefaults.stringForKey("ip")!
            
            var command = "M501\n:"
            println("ip:\(ip)\ncommand:\n\(command)")
            
            //send POST request with command
            var request = NSMutableURLRequest(URL: NSURL(string: "http://\(ip)/command")!)
            request.HTTPMethod = "POST"
            
            var requestBodyData: NSData = (command as NSString).dataUsingEncoding(NSUTF8StringEncoding)!
            
            request.addValue((String(countElements(command))), forHTTPHeaderField: "Content-Length")
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.HTTPBody = requestBodyData
            
            var connection = NSURLConnection(request: request, delegate: self, startImmediately: true)
            
            println("sending POST request")
            
            connection?.start()
        }else {
            let alert = UIAlertView()
            alert.title = "Set IP address"
            alert.message = "An IP address must be set so SmoothieControl knows where to send your command."
            alert.addButtonWithTitle("Ok")
            alert.show()
        }
        //dimsiss keyboard
        self.view.endEditing(true)
    }
    
    func connection(didReceiveResponse: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        
        let httpResponse = response as? NSHTTPURLResponse
        
        let alert = UIAlertView()
        alert.addButtonWithTitle("Ok")
        
        if httpResponse?.statusCode == 200{
            println("Connection Test: Success")
            
            alert.title = "Success!"
            alert.message = "SmoothieControl was able to connect to your Smoothieboard."
        }else {
            alert.title = "Unsuccessful"
            alert.message = "SmoothieControl was not able to connect to your Smoothieboard."
        }
        alert.show()
    }
    
    func connection(connection: NSURLConnection!, didFailWithError error: NSError!) {
        let alert = UIAlertView()
        alert.title = "Unsuccessful"
        alert.message = "SmoothieControl was not able to connect to your Smoothieboard."
        alert.addButtonWithTitle("Ok")
        alert.show()
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
}
