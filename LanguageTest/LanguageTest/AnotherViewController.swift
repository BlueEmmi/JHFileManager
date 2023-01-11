//
//  AnotherViewController.swift
//  LanguageTest
//
//  Created by PSD on 2022/11/22.
//

import UIKit
import ObjectMapper
class AnotherViewController: UIViewController {
    var dataArr:Array<VideoModel> = [VideoModel]()

    lazy var tableView:UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.isPagingEnabled = true
        tableView.register(VideoCell.self, forCellReuseIdentifier: "VideoCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.scrollsToTop = false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.frame = self.view.bounds
        tableView.rowHeight = self.view.bounds.size.height
        
        return tableView
    }()
    
    lazy var controlView:VideoControlView = {
        let controlView = VideoControlView()
        return controlView
    }()
    
    
    
    lazy var player:ZFPlayerController = {
        let player = ZFPlayerController.player(with: tableView, playerManager: ZFAVPlayerManager(), containerViewTag: 20001)
        player.disableGestureTypes = [.pan,.pinch]
        player.allowOrentitaionRotation = false
        player.isWWANAutoPlay = true
        player.playerDisapperaPercent = 1.0
        player.playerDidToEnd = {[weak self] asset in
            print("播放完毕")
        }
        player.zf_scrollViewDidEndScrollingCallback = {[weak self] indexPath in
            self?.playVideoWithIndexPath(indexPath: indexPath)
        }
        player.playerReadyToPlay = {[weak self] (asset,assetUrl) in
            
        }
        
        return player
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var info = BookInfo()
//        info.id = 1688
//        info.title = "我的中国名字"
//        info.author = "史密斯_罗斯"
        
        let info = BookInfo.with{
            $0.id = 1999
            $0.title = "My English Name"
            $0.author = "Smith Rose"
        }
        let birthdayData:Data = try! info.serializedData()
        print("第一个data====\(birthdayData)")
        let decodedInfo = try! BookInfo(serializedData: birthdayData)
        print("第2个info====\(decodedInfo.author)")
        let jsonData: Data = try! info.jsonUTF8Data()
        print("第3个data====\(jsonData)")
        let receivedFromJSON = try! BookInfo(jsonUTF8Data: jsonData)
        print("第4个json====\(receivedFromJSON.title)")


        /*
        self.player.controlView = self.controlView
        // Do any additional setup after loading the view.
        self.view.addSubview(self.tableView)
        loadInfoDataRequest()*/
    }
    

    func loadInfoDataRequest() {
        let path = Bundle.main.path(forResource: "data", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        do{
            let data = try Data(contentsOf: url)
            let jsonData:Any = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
//            PPLog("json数据====\(jsonData)")
            let jsonDic = jsonData as! Dictionary<String,Any>
            let videoList = jsonDic["list"] as! Array<Dictionary<String,Any>>
//            let Arr = Mapper<NewsModel>().mapArray(JSONArray: testArr)

            let arr = Mapper<VideoModel>().mapArray(JSONArray: videoList)
            dataArr.append(contentsOf: arr)
//            for model in dataArr{
////                PPLog("======\(model.title)")
//            }
            self.tableView.reloadData()
            playVideoWithIndexPath(indexPath: IndexPath(row: 0, section: 0))
            
            
        }catch let error{
            print("读取本地数据出现错误!",error)
        }
    }
    
    func playVideoWithIndexPath(indexPath:IndexPath){
        let model = self.dataArr[indexPath.row]
        self.player.playTheIndexPath(indexPath, assetURL: URL(string: model.video_url)!)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension AnotherViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.bounds.size.height
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.zf_scrollViewDidScroll()
    }
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        scrollView.zf_scrollViewDidScrollToTop()
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollView.zf_scrollViewWillBeginDragging()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollView.zf_scrollViewDidEndDraggingWillDecelerate(decelerate)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollView.zf_scrollViewDidEndDecelerating()
    }
    
}


class VideoModel:Mappable{
    required init(map:Map) {
        
    }
    var nick_name:String = ""
    var head:String = ""
    var agree_num:Int = 0
    var share_num:Int = 0
    var post_num:Int = 0
    var title:String = ""
    var thumbnail_width:CGFloat = 0.0
    var thumbnail_height:CGFloat = 0.0
    var video_duration:CGFloat = 0.00
    var video_width:CGFloat = 0.0
    var video_height:CGFloat = 0.0
    var thumbnail_url:String = ""
    var video_url:String = ""
    
    func mapping(map: Map) {
        nick_name <- map["nick_name"]
        head <- map["head"]
        agree_num <- map["agree_num"]
        share_num <- map["share_num"]
        post_num <- map["post_num"]
        title <- map["title"]
        thumbnail_width <- map["thumbnail_width"]
        thumbnail_height <- map["thumbnail_height"]
        video_duration <- map["video_duration"]
        video_width <- map["video_width"]
        video_height <- map["video_height"]
        thumbnail_url <- map["thumbnail_url"]
        video_url <- map["video_url"]
    }
    
}
