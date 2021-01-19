//
//  Model.swift
//  AdoptMe
//
//  Created by lnt on 12/25/20.
//

import Foundation
import Firebase
import BCrypt
import FirebaseFirestoreSwift

let db = Firestore.firestore()

struct MyUser : Identifiable, Codable {
    @DocumentID var id : String?
    var UID : String = ""
    var address : String = ""
    var dateOfBirth : String = ""
    var email : String = ""
    var fullname : String = ""
    var gender : Bool = true
    var password : String = ""
    var phone : String = ""
    var token : String = ""
    var username : String = ""
    var avatar : String = ""
}

func getUserByID(ID : String) {
    var result = MyUser()
    
    db.collection("users").document(ID).getDocument { (document, error) in
        let data = document?.data()
        
        result.UID = data?["UID"] as! String
        result.address = data?["address"] as! String
        result.dateOfBirth = data?["dateOfBirth"] as! String
        result.email = data?["email"] as! String
        result.fullname = data?["fullname"] as! String
        result.gender = data?["gender"] as! Bool
        result.password = data?["password"] as! String
        result.phone = data?["phone"] as! String
        result.token = data?["token"] as! String
        result.username = data?["username"] as! String
        result.avatar = data?["avatar"] as! String

    }
    
   
}
