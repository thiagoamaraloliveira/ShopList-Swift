//
//  CreateListViewController.swift
//  shoplistv1
//
//  Created by Aluno18 on 13/03/22.
//  Copyright © 2022 Aluno18. All rights reserved.
//

import UIKit

class CreateListViewController: UIViewController {

    @IBOutlet weak var goBackButtonList: UIButton!
    @IBOutlet weak var createButtonList: UIButton!
    @IBOutlet weak var nameNewListTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationControllerConfig()
        configButtonsStyle()
    }
    
    //MARK: Buttons Config Style
    func configButtonsStyle(){
        goBackButtonList?.layer.cornerRadius = 12
        goBackButtonList?.layer.borderWidth = 1
        goBackButtonList?.layer.borderColor = UIColor.white.cgColor
        
        createButtonList?.layer.cornerRadius = 12
        createButtonList?.layer.borderWidth = 1
        
        let primary = UIColor(red: 103/255, green: 141/255, blue: 88/255, alpha: 1.0).cgColor
        createButtonList.layer.borderColor = primary
        
    }
    //MARK: Config Navigation Controller
    func navigationControllerConfig(){
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController!.navigationBar.isHidden = true
    }
    
    //MARK: IBAction Function
    @IBAction func goBackList(_ sender: UIButton) {
        self.navigationController!.navigationBar.isHidden = false;
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createListButton(_ sender: UIButton) {
        if nameNewListTextField.text != "" {
            self.createShoppingList()
        } else {
            myAlert("Erro!", "Campo Vazio")
        }
    }
    
    //MARK: Helper functions services
    func createShoppingList()  {
        // create new list
        let list = ShoppingList(_name: nameNewListTextField.text!)
        let listId = list.saveItemInBackground(list: list)
        
        self.navigationController!.navigationBar.isHidden = false;
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "List_Edit") as! ShoppingItemViewController
        nextVC.listTitle = self.nameNewListTextField.text ?? "";
        nextVC.listId = listId
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func myAlert(_ title: String,_ bodyMessage: String){
        let myAlert = UIAlertController(title: title, message: bodyMessage, preferredStyle: .alert)
         
         let okAction = UIAlertAction(title: "OK", style: .default)
         myAlert.addAction(okAction)
         
        present(myAlert,animated: true,completion: nil)
        
    }

}
