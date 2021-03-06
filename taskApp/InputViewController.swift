//
//  InputViewController.swift
//  taskApp
//
//  Created by 田尾　早和美 on 2021/04/17.
//

import UIKit
import RealmSwift
class InputViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var categoryTextField: UITextField!

    let realm = try! Realm()
    var task: Task!
    override func viewDidLoad() {
        super.viewDidLoad()
        // 背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
                self.view.addGestureRecognizer(tapGesture)

        
                titleTextField.text = task.title
                contentsTextView.text = task.contents
                datePicker.date = task.date
                categoryTextField.text = task.category

        // Do any additional setup after loading the view.
    }

    override func viewWillDisappear(_ animated: Bool) {
            try! realm.write {
                self.task.title = self.titleTextField.text!
                self.task.contents = self.contentsTextView.text
                self.task.date = self.datePicker.date
                self.task.category = self.categoryTextField.text!
                self.realm.add(self.task, update: .modified)
            }

            super.viewWillDisappear(animated)
        }
    @objc func dismissKeyboard(){
            // キーボードを閉じる
            view.endEditing(true)
        }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
