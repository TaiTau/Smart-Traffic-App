//
//  VideoTableViewCell.swift
//  English
//
//  Created by TaiTau on 03/01/2024.
//

import UIKit
protocol VideoCellDelegate {
    func didChoose(cell: VideoTableViewCell, phone:String)
}
class VideoTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCreator: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    var delegate: VideoCellDelegate?
    var idVideo :String?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    func setUp(user:VideoModel){
        lblName.text = user.NAME
        lblCreator.text = user.USER_NAME
        idVideo = user.VIDEO_ID
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss 'GMT'"

        // Convert the string to a Date object
        if let date = inputDateFormatter.date(from: user.DATE ?? "") {
            // Date formatter for formatting the date into the desired format
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = "dd/MM/yyyy - HH:mm:ss"

            // Convert the date to the desired string format
            let formattedDateString = outputDateFormatter.string(from: date)
            lblDate.text = formattedDateString
        } else {
            print("Unable to parse the date string")
        }
       
    }
    
    @IBAction func actionDeleta(_ sender: Any) {
        self.delegate?.didChoose(cell: self, phone: idVideo ?? "")
    }
}
