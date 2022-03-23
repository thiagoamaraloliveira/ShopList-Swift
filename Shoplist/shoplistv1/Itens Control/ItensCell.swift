//
//  ItensCell.swift
//  shoplistv1
//
//  Created by Aluno18 on 20/03/22.
//  Copyright © 2022 Aluno18. All rights reserved.
//

import UIKit

class ItensCell: UITableViewCell {

    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var itemLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

struct  Item {
    var name: String
    var isMarked: Bool
    var isDone: Bool
    var total: Int
    var price: Float
    
    func dictionaryFromItem(item: Item) -> NSDictionary {
        return NSDictionary(objects: [item.name,item.isMarked,item.isDone,item.total,item.price], forKeys: ["name" as NSCopying, "isMarked" as NSCopying,"isDone" as NSCopying,"total" as NSCopying,"price" as NSCopying])
    }
    
}
