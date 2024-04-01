//
//  ListUserTableViewCell.swift
//  English
//
//  Created by TaiTau on 31/12/2023.
//

import UIKit
protocol FarmerCellDelegate {
    func didChoose(cell: ListUserTableViewCell, phone:String)
}
class ListUserTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    var delegate: FarmerCellDelegate?
    var mobiphone:String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.clipsToBounds = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        lblPhone.isUserInteractionEnabled = true
        lblPhone.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped() {
        self.delegate?.didChoose(cell: self, phone: mobiphone)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp(user:UserModel,index:IndexPath){
        lblName.text = user.NAME
        lblPhone.text = user.PHONE
        mobiphone = user.PHONE
        lblEmail.text = user.EMAIL
        lblAddress.text = user.ADDRESS
        imgAvatar.contentMode = .scaleAspectFill
        if(user.URL_AVATAR != nil){
            let url = "\(NetworkConstants.shared.serverAddress)\(user.URL_AVATAR!)"
            imgAvatar.load(urlString:url)
        }else{
            imgAvatar.image = UIImage(systemName: "person.circle")
        }
        self.imgAvatar.layer.cornerRadius = 13
        self.imgAvatar.contentMode = .scaleAspectFill
        self.imgAvatar.layer.masksToBounds = true
    }
    
}
