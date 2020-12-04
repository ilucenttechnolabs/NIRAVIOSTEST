//
//  DatabaseManager.swift
//  Localdatabase
//
//  Created by Bhavik Darji on 09/08/2019.
//  Copyright © 2019 Bhavik Darji. All rights reserved.
//

import Foundation
var shareInstance = DatabaseManager()
class DatabaseManager :NSObject {
    
    var database:FMDatabase? = nil
    
    
    class func getInstance()-> DatabaseManager{
        
        if shareInstance.database == nil {
            
            shareInstance.database = FMDatabase(path: Util.getPath("mydiaryapp.db"))
        }
        
        return shareInstance
    }
    
    
   //MARK:- ----  Notes Functions-----
    
    func saveData(_ ModalInfo:DiaryDetailModal) -> Bool {
        
        shareInstance.database?.open()
        
     //   let isSort = shareInstance.database?.executeUpdate("select MAX(sort)+1 as sort from Notes", withArgumentsIn: [0])
        
        let isSave = shareInstance.database?.executeUpdate("INSERT INTO mydiary (id,title,content,date) VALUES (?,?,?,?)", withArgumentsIn: [ModalInfo.id,ModalInfo.title,ModalInfo.content,ModalInfo.date])
        
        shareInstance.database?.close()
        
        return isSave!
    }
    
    func updatevalue(_ updatemodal:DiaryDetailModal)  -> NSMutableArray
    {
        shareInstance.database?.open()

        //@"select rowid,* from cart_tbl"

        let resultSet:FMResultSet! = shareInstance.database?.executeQuery("UPDATE mydiary SET id = ?,title = ?,content = ?,date = ? WHERE id = ?", withArgumentsIn: [updatemodal.id,updatemodal.title,updatemodal.content,updatemodal.date, updatemodal.id])

        let iteminfo:NSMutableArray = NSMutableArray()

        if (resultSet != nil)
        {
            while resultSet.next()
            {
                let items: DiaryDetailModal = DiaryDetailModal(id: resultSet.string(forColumn: "id")!, title: resultSet.string(forColumn: "title")!, content: resultSet.string(forColumn: "content")!, date: resultSet.string(forColumn: "date")!)
                iteminfo.add(items)
            }
            print(iteminfo)
        }

        shareInstance.database?.close()
        return iteminfo
    }
    
    
    func deleteNotevalue(_ id:Int)
    {
        shareInstance.database?.open()
        
        //@"select rowid,* from cart_tbl"
        
        
        let resultSet:FMResultSet! = shareInstance.database?.executeQuery("DELETE FROM mydiary WHERE id = ?", withArgumentsIn: [id])
        
        if (resultSet != nil)
        {
            
            while resultSet.next()
            {
                let items: MydiaryModal = MydiaryModal(id: resultSet.string(forColumn: "id")!, title: resultSet.string(forColumn: "title")!, content: resultSet.string(forColumn: "content")!, date: resultSet.string(forColumn: "date")!)
            }
        }
        
        shareInstance.database?.close()
    }
    
    func getNotesdata() -> [MydiaryModal]
    {
        shareInstance.database?.open()
        
        
        let resultSet:FMResultSet! = shareInstance.database?.executeQuery("SELECT * FROM mydiary", withArgumentsIn: [0])
        
        var iteminfo:[MydiaryModal] = []
        
        if (resultSet != nil)
        {
            
            while resultSet.next()
            {
                let items: MydiaryModal = MydiaryModal(id: resultSet.string(forColumn: "id")!, title: resultSet.string(forColumn: "title")!, content: resultSet.string(forColumn: "content")!, date: resultSet.string(forColumn: "date")!)

                iteminfo.append(items)
            }
        }
        
        shareInstance.database?.close()
        
        return iteminfo
    }
}
