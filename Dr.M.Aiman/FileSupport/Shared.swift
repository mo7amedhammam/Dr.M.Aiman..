//
//  Shared.swift
//  Pina
//
//  Created by Mohamed Salman on 3/2/21.
//

import Foundation

final class Shared {
    static let shared = Shared()
    var lang : String!
    var MobileNumber = ""

    
    var CourseID        = 0
    var PlayListID      = 0
    var IsCoursePayed   = -1 // if 0 course is payed else -1 is not payed
    var IsPlaylistPayed = -1 // if 0 playlist is payed else -1 is not payed
    var Links = [String]() // add reference links
    var CourseName = ""
    var PlayListName = ""
    var CoursePrice = 0.0
    var PlayListPrice = 0.0
    var cheeckQuize = false // if false no quize else yes quize
    var FawryId = ""
    var UniversityID : String?
    var IsVimeo : Bool!
    var Response : String!
    var IsYoutube : Bool!
    var FaceDetect = false
    var PaymentUrl = ""
    
    var PostLive = 0     // go from post = 0     go from live = 1 
    
}
