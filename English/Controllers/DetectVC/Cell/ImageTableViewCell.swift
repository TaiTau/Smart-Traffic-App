//
//  ImageTableViewCell.swift
//  English
//
//  Created by TaiTau on 01/01/2024.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    @IBOutlet weak var imgXe: UIImageView!
    @IBOutlet weak var IDxe: UILabel!
    @IBOutlet weak var bienSo: UILabel!
    @IBOutlet weak var lbLoi: UILabel!
    @IBOutlet weak var lbLoaiXe: UILabel!
    @IBOutlet weak var lbThoiGian: UILabel!
    @IBOutlet weak var lbMauXe: UILabel!
    @IBOutlet weak var imgBienXo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        config()
        imgXe.layer.cornerRadius = 10
        imgXe.clipsToBounds = true
        imgBienXo.layer.cornerRadius = 6
        imgBienXo.clipsToBounds = true
        self.imgXe.layer.masksToBounds = true;
        self.imgBienXo.layer.masksToBounds = true;
        
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(cam:ImageModel, index:IndexPath){
        bienSo.text = cam.TEXT_BIENSO
        if(Int(cam.LOAI_XE) == 2){
            lbLoaiXe.text = "Ô tô"
        }else{
            lbLoaiXe.text = "Xe máy"
        }
        if(cam.MAU_XE == "Dark Jungle Green"){
            lbMauXe.text =  "Dark Green"
        }else{
            lbMauXe.text =  cam.MAU_XE
        }
        lbThoiGian.text =  "20/01/2024"
        let urlxe = cam.URL_XE.replacingOccurrences(of: "./", with: "")
        let urlbs = cam.URL_BIENSO.replacingOccurrences(of: "./", with: "")

        imgXe.load(urlString:NetworkConstants.shared.serverAddress + urlxe)
        imgBienXo.load(urlString:"\(NetworkConstants.shared.serverAddress)\( urlbs)")
        IDxe.text = "Thông tin: \(cam.ID_PT)"
    }
    
    func config(){
        
    }
    
}
