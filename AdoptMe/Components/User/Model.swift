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
    var UID : String
    var address : String
    var dateOfBirth : Date
    var email : String
    var fullname : String
    var gender : Bool
    var password : String
    var phone : String
    var token : String
    var username : String
}

func getUserByID(ID : String) -> MyUser {
    var result = [MyUser]()
    
    db.collection("users").whereField("UID", isEqualTo: ID).limit(to: 1)
        .getDocuments{ (querySnapshot, error) in
            if let error = error {
                print(error)
            } else {
                if querySnapshot!.documents.count == 1 {
                    let documents = querySnapshot!.documents
                    result = documents.compactMap { (QueryDocumentSnapshot) -> MyUser? in
                      return try? QueryDocumentSnapshot.data(as: MyUser.self)
                    }
                    
                }
            }
    }
    
    return result[0]
}
