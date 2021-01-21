//
//  ForgotPasswordViewController.swift
//  AdoptMe
//
//  Created by Quoc Thuan Truong on 1/1/21.
//

import UIKit
import MaterialComponents

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var sendButton: MDCButton!
    @IBOutlet weak var phoneTextField: MDCOutlinedTextField!
    
    static let path = Bundle.main.path(forResource: "Config", ofType: "plist")
       static let config = NSDictionary(contentsOfFile: path!)
       private static let baseURLString = config!["serverURL"] as! String
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }
    
    func initView() {
        
    }
    

    @IBAction func sendAct(_ sender: Any) {
       sendVerificationCode("+84", "389294631")
    }
    
    func sendVerificationCode(_ countryCode: String, _ phoneNumber: String) {
            
            let parameters = [
                "via": "sms",
                "country_code": countryCode,
                "phone_number": phoneNumber
            ]
            
            let path = "start"
            let method = "POST"
            
        let urlPath = "\(ForgotPasswordViewController.baseURLString)/\(path)"
            var components = URLComponents(string: urlPath)!
        
            
            var queryItems = [URLQueryItem]()
            
            for (key, value) in parameters {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
            
            components.queryItems = queryItems
            
            let url = components.url!
        print(url)
            
            var request = URLRequest(url: url)
            request.httpMethod = method
            
            let session: URLSession = {
                let config = URLSessionConfiguration.default
                return URLSession(configuration: config)
            }()
            
            let task = session.dataTask(with: request) {
                (data, response, error) in
                if let data = data {
                    do {
                        let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                        
                        print(jsonSerialized!)
                    }  catch let error as NSError {
                        print(error.localizedDescription)
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
            task.resume()
        }
}
