//
//  DiaryDetailVC.swift
//  Diary App
//
//  Created by Bhavik Darji on 04/12/20.
//

import UIKit

class DiaryDetailVC: UIViewController {

    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var txtContent: UITextView!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var lblDiaryTitle: UILabel!
    
    var Title = ""
    var content = ""
    var id = ""
    var date = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        btnSave.layer.cornerRadius = 5.0
        let text = NSMutableAttributedString(string: "SAVE", attributes: [NSAttributedString.Key.kern: 2])
        btnSave.setAttributedTitle(text, for: .normal)
        
        txtTitle.text = Title
        txtContent.text = content
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - IBAction
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSaveClick(_ sender: UIButton) {
        
        if txtTitle.text! != "" && txtContent.text! != ""
        {
            let modalinfo = DiaryDetailModal(id: id, title: txtTitle.text!, content: txtContent.text!, date: date)
            print(modalinfo)
            let update = DatabaseManager.getInstance().updatevalue(modalinfo)
            print(update)
            self.navigationController?.popViewController(animated: true)
        }
        else
        {
            showAlert(title: "Warning!!", message: "Please fill allthe detail.")
        }
    }
}
extension UIViewController {
    func showAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
