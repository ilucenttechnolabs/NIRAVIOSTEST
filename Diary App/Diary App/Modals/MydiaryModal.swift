//
//  MydiaryModal.swift
//  Diary App
//
//  Created by Bhavik Darji on 04/12/20.
//

import Foundation
import ObjectMapper

class MydiaryModal
{
    var id = ""
    var title = ""
    var content = ""
    var date = ""
    
    init(id:String,title:String, content:String, date:String){
        
        self.id = id
        self.title = title
        self.content = content
        self.date = date
    }
}

//class MydiaryModal: Mappable
//{
//    var id = ""
//    var title = ""
//    var content = ""
//    var date = ""
//    
//    required init?(map: Map){
//    }
//    
//    func mapping(map: Map) {
//        id <- map["id"]
//        title <- map["title"]
//        content <- map["content"]
//        date <- map["date"]
//
//    }
//}
