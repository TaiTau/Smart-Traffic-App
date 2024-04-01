//
//  MainViewTableViewCell.swift
//  English
//
//  Created by TaiTau on 07/04/2023.
//

import UIKit

class MainViewTableViewCell: UITableViewCell {

    public static let identifier = "MainViewTableViewCell";
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var lblKindKnowledge: UILabel!
//    func setupCell(viewModel: KindKnowledgeModel) {
//        self.lblKindKnowledge.text = viewModel.name
//        print("data", viewModel.name)
//    }
    
}
