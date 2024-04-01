//
//  FunctionTableViewCell.swift
//  English
//
//  Created by TaiTau on 30/12/2023.
//

import UIKit

class FunctionTableViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var funcName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    
    func setUp(imgName:String, funcName:String){
       // img.image = UIImage(data: imgName)
        img.image = UIImage(systemName: imgName)
        self.funcName.text = funcName
    }
    
    func setUpUI(){
        self.layer.cornerRadius = 10
        self.backgroundColor = UIColor.white
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.bounds.size.height / 4;
        self.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
