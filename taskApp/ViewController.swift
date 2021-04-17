//
//  ViewController.swift
//  taskApp
//
//  Created by 田尾　早和美 on 2021/04/17.
//

import UIKit
import RealmSwift

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var search: UISearchBar!

    let realm = try! Realm()
    
    //taskを入れる配列を作成
    var taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: true)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        search.delegate = self
        // Do any additional setup after loading the view.
    }
    //検索
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            view.endEditing(true)
        guard let searchText = search.text else{return}
        let result = realm.objects(Task.self).filter("category CONTAINS '\(searchText)'")
        let count = result.count
        if (count == 0){
            taskArray = realm.objects(Task.self)
        }
        else{
            taskArray = result
        }
        tableView.reloadData()
    }
   
    // segue で画面遷移する時に呼ばれる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let inputViewController:InputViewController = segue.destination as! InputViewController
        //編集するとき、新規に作成するとき
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
    //検索


    
    // データの数（＝セルの数）を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    // 各セルの内容を返すメソッド

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
    // 各セルを選択した時に実行されるメソッド
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

