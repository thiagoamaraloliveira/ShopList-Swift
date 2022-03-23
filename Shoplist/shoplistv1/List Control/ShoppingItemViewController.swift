//
//  ShoppingItemViewController.swift
//  shoplistv1
//
//  Created by Aluno18 on 12/03/22.
//  Copyright © 2022 Aluno18. All rights reserved.
//
import UIKit
import FirebaseDatabase
private let database = Database.database().reference()

class ShoppingItemViewController: UIViewController ,UITableViewDataSource , UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalItensLabel: UILabel!
    @IBOutlet weak var totalDoneLabel: UILabel!
    @IBOutlet weak var totalUndoneLabel: UILabel!

    
    @IBOutlet weak var priceLabel: UIButton!
    var listTitle = ""
    var listId = ""
    var listItens : [Item] = []
    var priceTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = listTitle.uppercased()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        getList()
        updateTotalLabels()
        navigationControllerConfig()
        navigationControllerButtonsConfig()
    }
        
    //MARK: Config Navigation Controller
    func navigationControllerConfig(){
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 3.0
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.5
        self.navigationController?.navigationBar.layer.masksToBounds = false
    }
    
    //MARK: Config Buttons Navigation Controller
    func navigationControllerButtonsConfig(){
        let buttonGoImage = UIImage(systemName: "plus.circle.fill")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: buttonGoImage, style: .plain, target: self, action: #selector(goAddItens))
        self.navigationItem.rightBarButtonItem?.tintColor = .white
              
        let buttonBackImage = UIImage(systemName: "lessthan")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: buttonBackImage, style:.plain, target: self,action: #selector(goBackAllLists))
        self.navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    //MARK: Navigation Actions
      @objc func goAddItens(sender: UIBarButtonItem) {
          updateList(listId)
          let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "Add_Itens") as! AddListItensViewController
          nextVC.listId = listId
          nextVC.listItens = listItens
          nextVC.listTitle = listTitle
          self.navigationController?.pushViewController(nextVC, animated: true)
      }
      
       @objc func goBackAllLists(sender: UIBarButtonItem) {
          updateList(listId)
          let rootVC = self.storyboard?.instantiateViewController(withIdentifier: "list_vc") as! AllListsViewController
          self.navigationController?.pushViewController(rootVC, animated: true)
      }
    
     //MARK: TableView DataSource
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Action on click cell
        
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as! ListItensTableViewCell
        
        var item = listItens[indexPath.row]
        item.isDone = !item.isDone
        listItens.remove(at: indexPath.row )
        listItens.insert(item, at: indexPath.row)

        cell.checkImage.image = item.isDone == true ? UIImage(systemName:"checkmark.circle.fill") : UIImage(systemName:"circle")
        cell.itemListLabel.textColor = item.isDone == true ? .gray : .black
        
      
        updateTotalLabels()
        tableView.reloadData()
       }
       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // Number of rows
            return listItens.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          // Format cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)  as! ListItensTableViewCell
            let list = listItens[indexPath.row]
            cell.itemListLabel.text = list.name
            cell.checkImage.image = list.isDone == true ? UIImage(systemName:"checkmark.circle.fill") : UIImage(systemName:"circle")
            cell.itemListLabel.textColor = list.isDone == true ? .gray : .black
            cell.itemTotalLabel.text = String(list.total)
               
            return cell
    }
    
     //MARK: Helper Functions Service
       func getList(){
          let ref = database.child("ShoppingList").child("1234").child(listId).child("ShoppingItem")
           ref.observe(DataEventType.value, with: {(snapshot) in
               if snapshot.childrenCount > 0 {
                   self.listItens = []
                   //update list
                   for list in snapshot.children.allObjects as![DataSnapshot] {
                       let listObject = list.value as? [String: AnyObject]
                       let name = listObject?["name"]
                       let isMarked = listObject?["isMarked"]
                       let isDone = listObject?["isDone"]
                       let total = listObject?["total"]
                       let price = listObject?["price"]
                     
                       if name == nil || isMarked == nil || isDone == nil || total == nil || price == nil  {
                           return
                       }
                       let list = Item(
                           name: name as! String ,
                           isMarked: isMarked as! Bool,
                           isDone: isDone as! Bool,
                           total: total as! Int,
                           price: price as! Float
                       )
                       self.listItens.append(list)
                   }
               }
            self.tableView.reloadData()
            self.updateTotalLabels()
           })
       }
    
    func updateTotalLabels(){
        var totalItems = 0
        for i in listItens {
            totalItems = totalItems + i.total
        }
        
        self.totalItensLabel.text = String(totalItems)
        let isdoneTotalValue = listItens.filter({ (item) -> Bool in return item.isDone == true })
        totalDoneLabel.text = String(isdoneTotalValue.count)
        totalUndoneLabel.text = String (listItens.count - isdoneTotalValue.count)
    }
    
    func updateList (_ listaId: String) -> Void {
        let ref = database.child("ShoppingList").child("1234").child(listaId).child("ShoppingItem")
        var updateList: [NSDictionary] = []
        for list in listItens {
            updateList.append(list.dictionaryFromItem(item: list))
        }
        ref.setValue(updateList)
        self.tableView.reloadData()
    }
    
    
    //MARK: Cell Content Function Actions
    @IBAction func minButtonCell(_ sender: UIButton) {
      let point = sender.convert(CGPoint.zero, to: tableView)
      guard let indexPath = tableView.indexPathForRow(at: point) else { return }
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)  as! ListItensTableViewCell
        
      var item = listItens[indexPath.row]
    
      
        if item.total >= 2 {
            item.total = item.total - 1
        }else{
            item.total = 1
        }
      
        listItens.remove(at: indexPath.row )
        listItens.insert(item, at: indexPath.row)
        
        cell.itemTotalLabel.text = String(item.total)
        cell.priceLabelText.text = String(item.price)
        
        updateTotalLabels()
        self.tableView.reloadData()
    }
    
    @IBAction func addButtonCell(_ sender: UIButton) {
      let point = sender.convert(CGPoint.zero, to: tableView)
      guard let indexPath = tableView.indexPathForRow(at: point) else { return }
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)  as! ListItensTableViewCell
        
      var item = listItens[indexPath.row]
      item.total = item.total + 1
    
      listItens.remove(at: indexPath.row )
      listItens.insert(item, at: indexPath.row)
        
      cell.itemTotalLabel.text = String(item.total)
        
      updateTotalLabels()
      self.tableView.reloadData()
    }
    
    
}
