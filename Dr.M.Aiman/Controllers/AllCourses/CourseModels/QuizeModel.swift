//
//  QuizeModel.swift
//  Mideo
//
//  Created by mac on 7/13/20.
//  Copyright © 2020 IT PLUS. All rights reserved.
//

import Foundation

class QuestionsModel : NSObject {
    var Image   = ""
    var Title   = ""
    var Answers = [AnswersModel]()
    var Id      = 0
    
    init(Image : String , Title : String , Answers : [AnswersModel] , Id : Int ) {
        self.Image   = Image
        self.Title   = Title
        self.Answers = Answers
        self.Id      = Id
    }
    
}

class AnswersModel : NSObject {
    var IsTrue = 0
    var Id     = 0
    var Title  = ""
    
    init(IsTrue : Int , Id : Int , Title : String ) {
        self.IsTrue   = IsTrue
        self.Id       = Id
        self.Title    = Title
        
    }
    
    
}

class ResultModel : NSObject {
    var IsTrue = 0
    var Id     = 0
    var Title  = ""
    var Question = ""
    
    init(IsTrue : Int , Id : Int , Title : String , Question : String ) {
        self.IsTrue   = IsTrue
        self.Id       = Id
        self.Title    = Title
        self.Question = Question
        
    }
    
    
}
