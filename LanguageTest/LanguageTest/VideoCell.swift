//
//  VideoCell.swift
//  LanguageTest
//
//  Created by PSD on 2022/11/22.
//

import UIKit

class VideoCell: UITableViewCell {
    
    lazy var videoView:UIImageView = {
        let videoView = UIImageView()
        videoView.tag = 20001
        videoView.backgroundColor = .red
        return videoView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(videoView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.videoView.frame = self.contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
