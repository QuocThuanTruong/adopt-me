//
//  UserViewController.swift
//  AdoptMe
//
//  Created by Quoc Thuan Truong on 12/8/20.
//

import UIKit
import Firebase

class UserViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func turnOnFirstLauch(_ sender: Any) {
        Core.shared.setIsFirstLauchApp()
    }
    
    @IBAction func logOutAct(_ sender: Any) {
        let token = Core.shared.getToken()
        Core.shared.setToken("")
        
        let userCollection = Firestore.firestore().collection("users")

        userCollection.whereField("token", isEqualTo: token).limit(to: 1)
            .getDocuments{(querySnapshot, error) in
                if let error = error {
                    print(error)
                } else {
                    if querySnapshot!.documents.count == 1 {
                        let data = querySnapshot?.documents[0].data()
                        
                        userCollection.document(data?["UID"] as! String).updateData(["token": ""])
                    }
                }
            }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
