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
    var user_id : String = ""
    var pet_id : String = ""
    var name : String = ""
    var age : Int = 0
    var address : String = ""
    var description : String = ""
    var avatar : String = ""
    var gender : Bool = true
    var type : Int = 0
    var images = [String]()
    var posted_date = Date()
    var is_active : Int = 1
}
