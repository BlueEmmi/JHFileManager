//
//  VideoControlView.swift
//  HoneyChat
//
//  Created by PSD on 2022/11/21.
//

import UIKit

class VideoControlView: UIView,ZFPlayerMediaControl{
    var player: ZFPlayerController?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCoverImgView(imgUrl:String){
        //    [self.player.currentPlayerManager.view.coverImageView setImageUrl:cover placeholderImage:placeholderImage];

//        self.player?.currentPlayerManager.view.coverImageView
    }
    
    func videoPlayer(_ videoPlayer: ZFPlayerController, loadStateChanged state: ZFPlayerLoadState) {
        if state == .playable || state == .playthroughOK{
            self.player?.currentPlayerManager.view.isHidden = false
        }else{
            self.player?.currentPlayerManager.view.isHidden = true
        }
    }
    
    func gestureSingleTapped(_ gestureControl: ZFPlayerGestureControl) {
        
        if self.player?.currentPlayerManager.isPlaying == true{
            print("正在播放")
        }else{
            print("没有播放")
        }
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}


