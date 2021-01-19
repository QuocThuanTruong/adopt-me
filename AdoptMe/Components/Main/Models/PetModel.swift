//
//  PetModel.swift
//  AdoptMe
//
//  Created by lnt on 1/19/21.
//

import Foundation
import FirebaseFirestoreSwift

struct Pet : Identifiable, Codable {
    @DocumentID var id : String?
    var user_id : String
    var pet_id : String
    var name : String
    var age : Int
    var address : String
    var description : String
    var avatar : String
    var gender : Bool
    var type : Int
    var images : [String]
    var posted_date : Date
    var is_active : Int
}
