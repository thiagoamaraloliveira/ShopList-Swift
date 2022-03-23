//
//  ListItensTableViewCell.swift
//  shoplistv1
//
//  Created by Aluno18 on 20/03/22.
//  Copyright © 2022 Aluno18. All rights reserved.
//

import UIKit

class ListItensTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var itemListLabel: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var itemTotalLabel: UILabel!
    @IBOutlet weak var priceLabelText: UILabel!
    
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
     
    }
 
    		
   
    
   
    
}


