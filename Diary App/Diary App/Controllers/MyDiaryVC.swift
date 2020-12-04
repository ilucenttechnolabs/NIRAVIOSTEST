//
//  MyDiaryVC.swift
//  Diary App
//
//  Created by Bhavik Darji on 04/12/20.
//

import UIKit
import ObjectMapper
import SwiftyJSON

class MyDiaryVC: UIViewController {

    @IBOutlet weak var tableviewMydiarys: UITableView!
    
    var arrMydiary:[MydiaryModal] = []
    var Detaildata:DiaryDetailModal?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    override func viewWillAppear(_ animated: Bool) {
        
        arrMydiary = []
        arrMydiary = DatabaseManager.getInstance().getNotesdata()
        if arrMydiary.count > 0
        {
            tableviewMydiarys.reloadData()
        } else {
            
            API_GetGiftcardlist()
        }
    }
    
    @objc func btnEditClick(_ sender : UIButton) {
        
        let data = arrMydiary[sender.tag]
        let vc = self.storyboard?.instantiateViewController(identifier: "DiaryDetailVC") as! DiaryDetailVC
        vc.Title = data.title
        vc.content = data.content
        vc.id = data.id
        vc.date = data.date
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func btnDeleteClick(_ sender : UIButton) {
        
        let data = arrMydiary[sender.tag]
        DatabaseManager.getInstance().deleteNotevalue(Int(data.id)!)
        arrMydiary = []
        arrMydiary = DatabaseManager.getInstance().getNotesdata()
        if arrMydiary.count > 0
        {
            tableviewMydiarys.reloadData()
        } else {
            API_GetGiftcardlist()
        }
    }
}

// MARK:- tableView

extension MyDiaryVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMydiary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyDiaryCell", for: indexPath) as! MyDiaryCell
        
        let text = NSMutableAttributedString(string: "EDIT", attributes: [NSAttributedString.Key.kern: 2])
        cell.selectionStyle = .none
        cell.btnEdit.tag = indexPath.row
        cell.btnCancel.tag = indexPath.row
        cell.btnCancel.layer.cornerRadius = 13.0

        cell.btnEdit.setAttributedTitle(text, for: .normal)
        cell.btnEdit.addTarget(self, action: #selector(btnEditClick( _ :)), for: .touchUpInside)
        cell.btnCancel.addTarget(self, action: #selector(btnDeleteClick(_:)), for: .touchUpInside)
        cell.btnEdit.setTitleColor(UIColor(red: 0.267, green: 0.129, blue: 0.643, alpha: 1), for: .normal)
        cell.viewinformation.addShadow(offset: CGSize(width: 0, height: 5.0), color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.05), radius: 10.0, opacity: 1.0)
        
        cell.lblDiaryTitle.text = arrMydiary[indexPath.row].title
        cell.lblDiaryContent.text = arrMydiary[indexPath.row].content
        
        let data = dateformate_dd_MMM(key: arrMydiary[indexPath.row].date)
        let currentdate = Date()
        
        cell.lbldays.text = currentdate.offset(from: data)
        cell.lblTimeline.text = currentdate.offset(from: data)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension MyDiaryVC
{
    func API_GetGiftcardlist()
    {
        let param:[String: Any] = ["":""]
        
        API.api_AlamofirePostNew("https://private-ba0842-gary23.apiary-mock.com/notes", withparams: param, IsLoder: true, sucess: { (Response) in
            
            let arr  = JSON(Response.rawValue)

            for (_ ,subJson):(String, JSON) in arr {
                let content = subJson["content"].string
                let title = subJson["title"].string
                let id = subJson["id"].string!
                let date = subJson["date"].string
                
                let modalinfo = DiaryDetailModal(id: id, title: title!, content: content!, date: date!)
                print(modalinfo)
                let isSave = DatabaseManager.getInstance().saveData(modalinfo)
                
                if isSave == true
                {
                    
                }
                print(isSave)

                self.arrMydiary.append(MydiaryModal(id: id, title: title!, content: content!, date: date!))
            }
            self.tableviewMydiarys.reloadData()
            
        }, failure: {(_ error: Error?) -> Void in
            print ("error \(String(describing: error))")
        })
    }
}

// MARK:- Supporting functions

extension UIView {
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        
        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
}

public func dateformate_dd_MMM(key: String) -> Date {
    
    let date : String
    date = key //2019-09-06 15:29:08
    var str = date
    str = str.replacingOccurrences(of: ".303Z", with: "")
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // This formate is input formated .
    let formateDate = dateFormatter.date(from:str)!
    return formateDate
}
