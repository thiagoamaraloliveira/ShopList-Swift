//
//  AllListsViewController.swift
//  shoplistv1
//
//  Created by Aluno18 on 12/03/22.
//  Copyright © 2022 Aluno18. All rights reserved.
//

import UIKit
import KRProgressHUD
import FirebaseDatabase
private let database = Database.database().reference()

class AllListsViewController: UIViewController, UITableViewDataSource , UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
   
    var nameTextField: UITextField!
    var allList = [ShoppingList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        getLists()
        self.tableView.reloadData()
        navigationControllerConfig()
    }
    
    //MARK: Config Navigation Controller
    func navigationControllerConfig(){
        
        //config shadow
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 3.0
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.5
        self.navigationController?.navigationBar.layer.masksToBounds = false
        
        //config navigation bar title format
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor .white ,
            NSAttributedString.Key.font: UIFont(name: "Futura-Bold", size:20)!
        ]
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    //MARK: TableView Configuration    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // Action on click cell
        tableView.deselectRow(at: indexPath, animated: true)
        let list = allList[indexPath.row]
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "List_Edit") as! ShoppingItemViewController
        nextVC.listTitle = list.name ;
        nextVC.listId = list.id
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Number of rows
        return allList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Format cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let list = allList[indexPath.row]
        cell.textLabel?.text = list.name
        cell.indentationLevel = 2;
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            // update no firebase
            let list = allList[indexPath.row]
            list.deleteItemInBackground(list: list)
            allList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
        
    //MARK: Helper functions services
    func getLists()   {
        let ref = database.child("ShoppingList").child("1234")
        ref.observe(DataEventType.value, with: {(snapshot) in
            if snapshot.childrenCount > 0 {
                // clear list
                self.allList = []
                
                //update list
                for list in snapshot.children.allObjects as![DataSnapshot] {
                    let listObject = list.value as? [String: AnyObject]
                    let name = listObject?["name"]
                    let totalPrice = listObject?["totalPrice"]
                    let totalItems = listObject?["totalItems"]
                    let id = listObject?["shoppingListId"]
                    let ownerId = listObject?["ownerID"]
                    if name == nil || totalPrice == nil || totalItems == nil || id == nil || ownerId == nil {
                        return
                    }
                    let list = ShoppingList(
                        _name: name as! String ,
                        _totalPrice: totalPrice as! Float,
                        _totalITems: totalItems as! Int,
                        _id: id as! String,
                        _ownerId: ownerId as! String
                    )
                    self.allList.append(list)
                }
            }
            self.tableView.reloadData()
        })
    }
}
