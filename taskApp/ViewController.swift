//
//  ViewController.swift
//  taskApp
//
//  Created by 田尾　早和美 on 2021/04/17.
//

import UIKit
import RealmSwift

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    let realm = try! Realm()
    var taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: true)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let inputViewController:InputViewController = segue.destination as! InputViewController

        if segue.identifier == "cellSegue" {
            let indexPath = self.tableView.indexPathForSelectedRow
            inputViewController.task = taskArray[indexPath!.row]
            } else {
            let task = Task()

            let allTasks = realm.objects(Task.self)
            if allTasks.count != 0 {
                task.id = allTasks.max(ofProperty: "id")! + 1
            }

            inputViewController.task = task
        }
    }
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          tableView.reloadData()
      }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let task = taskArray[indexPath.row]
                cell.textLabel?.text = task.title

        let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm"

        let dateString:String = formatter.string(from: task.date)
            cell.detailTextLabel?.text = dateString
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cellSegue",sender: nil)
    }
    // セルが削除が可能なことを伝えるメソッド
    func tableView(_ tableview:UITableView,editingStyleForRowAt indexPath: IndexPath)-> UITableViewCell.EditingStyle{
        return .delete
    }
    // Delete ボタンが押された時に呼ばれるメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
                    // データベースから削除する
                    try! realm.write {
                        self.realm.delete(self.taskArray[indexPath.row])
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
        
    }
}

