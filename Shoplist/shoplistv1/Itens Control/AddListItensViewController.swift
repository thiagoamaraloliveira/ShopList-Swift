//
//  AddListItensViewController.swift
//  shoplistv1
//
//  Created by Aluno18 on 17/03/22.
//  Copyright © 2022 Aluno18. All rights reserved.
//
import UIKit
import FirebaseDatabase
private let database = Database.database().reference()

class AddListItensViewController: UIViewController, UITableViewDataSource , UITableViewDelegate{
   
    var itens = [
        Item(name: "abacaxi", isMarked: false, isDone: false, total: 1 , price: 0 ),
        Item(name: "maçã", isMarked: false , isDone: false, total: 1 , price: 0),
        Item(name: "pera", isMarked: false , isDone: false , total: 1 , price: 0),
        Item(name: "uva", isMarked: false , isDone: false , total: 1 , price: 0),
        Item(name: "morango", isMarked: false, isDone: false , total: 1 , price: 0),
        Item(name: "melancia", isMarked: false , isDone: false , total: 1 , price: 0),
    ]
    var listId = ""
    var listTitle = ""
    var filtedList : [Item] = []
    var listItens : [Item] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var itemNameTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Adicionar Itens"
        self.filtedList = itens
       
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        navigationControllerConfig()
        fieldImageConfig()
        updateListStatus()
        self.tableView.reloadData()
        
    }
   
    //MARK: Config Navigation Controller
    func navigationControllerConfig(){
        let buttonBackImage = UIImage(systemName: "lessthan")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: buttonBackImage, style:.plain, target: self,action: #selector(salveListItens))
        self.navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    //MARK: Config Navigation Controller
    func fieldImageConfig(){
       let leftImageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 10, height: 10))
        leftImageView.image = UIImage(systemName:"magnifyingglass")
        leftImageView.tintColor = .gray
        itemNameTextField.leftView = leftImageView
        itemNameTextField.leftViewMode = .always
    }
    
    //MARK: IBAction functions
    @IBAction func itensFilterChanged(_ sender: UITextField) {
        self.filtedList = itens
        print("fazer filtro!!!")
        let textSearchUpper = itemNameTextField.text?.uppercased()
        if itemNameTextField.text != "" {
            let filter = itens.filter({ (item) -> Bool in  return item.name.uppercased().starts(with: textSearchUpper!)})
            self.filtedList = filter
            //print("")
        }
        self.tableView.reloadData()
    }
    
    
    //MARK: TableView DataSource
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Action on click cell
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? ItensCell else {return }
        
        let index = itens.firstIndex(where: {$0.name == cell.itemLabel.text})
          if index != nil {
            var list = itens[index!]
            list.isMarked = !list.isMarked
            
            itens.remove(at: index!)
            itens.insert(list, at: index!)
            
            
            cell.checkImage.image = list.isMarked == true ? UIImage(systemName:"plus.circle.fill") : UIImage(systemName:"circle")
            cell.itemLabel.textColor = list.isMarked == true ? .gray : .black
       }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Number of rows
        return filtedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Format cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ItensCell
        let lista = itens[indexPath.row]
       
        cell.itemLabel.text = lista.name
        cell.checkImage.image = lista.isMarked == true ? UIImage(systemName:"plus.circle.fill") : UIImage(systemName:"circle")
        cell.itemLabel.textColor = lista.isMarked == true ? .gray : .black
        
        return cell
    }
    
   //MARK: Navigation Actions
   @objc private func salveListItens() {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "List_Edit") as! ShoppingItemViewController
        updateList(listId)
   
        nextVC.listId = listId
        nextVC.listTitle = self.listTitle;
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    //MARK: Helper Functions Service
    func updateList (_ listaId: String) -> Void {
       
        let ref = database.child("ShoppingList").child("1234").child(listaId).child("ShoppingItem")
        var updateList: [NSDictionary] = []       
        
        let filter = itens.filter({ (item) -> Bool in  return item.isMarked == true })
        if filter.count > 0 {
            for item in filter {
                let updateItem = item.dictionaryFromItem(item: item)
                updateList.append(updateItem)
            }
        }
        ref.setValue(updateList)
      }
    
   func updateListStatus(){
    for item in listItens {
        let index = itens.firstIndex(where: {$0.name == item.name})
        let item = Item(name: item.name, isMarked : true, isDone: item.isDone, total: item.total ,price: item.price)
        self.itens.remove(at: index!)
        self.itens.insert(item,at: index!)
    }
     self.tableView.reloadData()
    }    
}
