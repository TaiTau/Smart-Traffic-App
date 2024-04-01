//
//  ListCameraTableViewCell.swift
//  English
//
//  Created by TaiTau on 30/12/2023.
//

import UIKit

class ListCameraTableViewCell: UITableViewCell {
    @IBOutlet weak var lblAdress: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
    
    func setUp(cam: CameraModelAPI){
        lblName.text = cam.NAME
        lblAdress.text = cam.ADDRESS
    }
    
    func setUpUI(){
        self.layer.cornerRadius = 10
        self.backgroundColor = UIColor.white
        self.layer.borderColor = UIColor.black.cgColor
        self.clipsToBounds = true
    }
    
    
    
    
}
