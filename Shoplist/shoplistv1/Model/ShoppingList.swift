//
//  ShoppingList.swift
//  shoplistv1
//
//  Created by Aluno18 on 12/03/22.
//  Copyright © 2022 Aluno18. All rights reserved.
//

import Foundation
import FirebaseDatabase
private let database = Database.database().reference()

class ShoppingList{
    
    let name: String
    var totalPrice: Float
    var totalITems: Int
    var id: String
    var ownerId: String
    var itens: String

    init(_name: String, _totalPrice: Float = 0, _totalITems: Int = 0,
         _id: String = "",_ownerId: String = "1234" , _itens: String = "0") {
        name = _name
        totalPrice = _totalPrice
        totalITems = _totalITems
        id = _id
        ownerId = _ownerId
        itens = _itens
    }
    
   func dictionaryFromItem(item: ShoppingList) -> NSDictionary {
        return NSDictionary(
            objects: [
                item.name,item.totalPrice,item.totalITems,item.id,item.ownerId,item.itens
            ],forKeys: [
                "name" as NSCopying, "totalPrice" as NSCopying, "totalItems" as NSCopying,
                "shoppingListId" as NSCopying,  "ownerID" as NSCopying, "shoppingItem" as NSCopying
            ]
        )
    }
    
    //Save on FireBase
    func saveItemInBackground(list:ShoppingList) -> String {
        let ref = database.child("ShoppingList").child("1234").childByAutoId()
        list.id = ref.key ?? ""
        
        let updateList = dictionaryFromItem(item:list)
        ref.setValue(updateList)
       
        return list.id
    }
    
    //Delete FireBase
    func deleteItemInBackground(list:ShoppingList) {       
        let ref = database.child("ShoppingList").child("1234").child(list.id)
        ref.removeValue()
    }
}
