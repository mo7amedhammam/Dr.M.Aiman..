//
//  UniversitiesModel.swift
//  Dr.M.Aiman
//
//  Created by Muhamed Hammam on 22/06/2021.
//

import Foundation
//MARK:---------------- UniversitiesModel

class UniversitiesModel : NSObject {
    
    var Id             = 0
    var Image          = ""
    var OrderNumber   = 0
    var Title          = ""
    var Courses        = [coursesModel]()

    init(
        Id          : Int,
        Image       : String,
        OrderNumber : Int,
        Title       : String ,
        Courses    : [coursesModel]
        ) {
        self.Id = Id
        self.Image = Image
        self.OrderNumber = OrderNumber
        self.Title = Title
        self.Courses = Courses
    }
}
//MARK:---------------- CoursesModel
class coursesModel : NSObject{
    var Id                  = 0
    var Title               = ""
    var PaymentUrl          = ""
    var Image                = ""
    var Created              = ""
    var Price                = 0
    var DoctorName           = ""
    var Description          = ""
    var TotalPlayLists      = 0
    var Fk_univeristy        = 0
    var Order               = 0
    var University          = ""
    var IsAvailable         = true
    
    init(
        Id                   : Int,
        Title                : String,
        PaymentUrl           : String,
        Image                : String,
        Created              : String,
        Price                : Int,
        DoctorName           : String ,
        Description    : String,
        TotalPlayLists       : Int ,
        Fk_univeristy         : Int ,
        Order                : Int,
        University           : String,
        IsAvailable          : Bool
    ) {
        self.Id=Id
        self.Title=Title
        self.PaymentUrl=PaymentUrl
        self.Image=Image
        self.Created=Created
        self.Price=Price
        self.DoctorName=DoctorName
        self.Description=Description
        self.TotalPlayLists=TotalPlayLists
        self.Fk_univeristy=Fk_univeristy
        self.Order=Order
        self.University=University
        self.IsAvailable=IsAvailable
    }
}
