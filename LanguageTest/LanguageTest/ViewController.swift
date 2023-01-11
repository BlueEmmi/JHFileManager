//
//  ViewController.swift
//  LanguageTest
//
//  Created by PSD on 2022/11/15.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        PSSFSClient.configProvider(self)

        self.view.backgroundColor = .yellow
        let testLb = UILabel(frame: CGRect(x: 100, y: 100, width: 280, height: 50))
        testLb.backgroundColor = .red
        testLb.textColor = .black
        self.view.addSubview(testLb)
//        NSString *path = [[NSBundle mainBundle]pathForResource:language ofType:@"lproj"];
//        self.bundle = [NSBundle bundleWithPath:path];
        let path = Bundle.main.path(forResource: "es", ofType: "lproj")!
        let bundle = Bundle(path: path)!
//        
//        print("文件路径====\(bundle)")
//
//        
//        testLb.text = bundle.localizedString(forKey: "test", value: "", table: "Localizable")
        testLb.text = NSLocalizedString("test",tableName: "Localizable",bundle: bundle, comment: "")
        
        let testBtn = UIButton.init(type: .custom)
        testBtn.setTitle("测试", for: .normal)
        testBtn.backgroundColor = .red
        
        testBtn.frame = CGRect(x: 10, y: 200, width: 100, height: 50)
        self.view.addSubview(testBtn)
        
        testBtn.addTarget(self, action: #selector(testAction(_:)), for: .touchUpInside)
    }
    
    
 
    
    @objc func testAction(_ btn:UIButton){
        print("我点击了")
        testConnectClient()
    }
    
    
    func testConnectClient(){
//        let target = PSSFSTarget.init(zone: "psd-live", host: "121.43.13.195", port: 19944)
//        PSSFSClient.shared().addImConfig(target)
    }


}
/*
extension ViewController: PSSFSProvider{
    func isSignedInApp() -> Bool {
        return true
    }
    
    func userId() -> String {
        return "200000066"
    }
    
    func userToken() -> String {
        return "udl3c3tjWJPHu7VkkDEYWtvot/+VzghGfntEkP/yErbf0IHf7O56es3ZkVUFCwIMDnS6pUnrYvHJmMV+0lNVdRU30VqVnVCF3D/cPC4a9Q8="
    }
    
    func uuid() -> String {
        return UUID().uuidString
    }
    
    func buildVersion() -> String {
        return "66630"
    }
    
    func deviceName() -> String {
        return "iPhone 14"
    }
    
    func serverTime() -> Int64 {
        return Int64(NSDate().timeIntervalSince1970 * 1000)
    }
    
    func shouldKeepAlive() -> Bool {
        return true
    }
    /// 若连接失败, 是否继续 重连,
    /// 比如, 后台且队列无request || 断网 || 没登录 等 不需要重连
    func shouldContinueToReconnect(with target: PSSFSTarget) -> Bool {
        return false
    }
    
    func canLogout(with target: PSSFSTarget) -> Bool {
        return false
    }
    /// IM连接成功
    func sfsTarget(_ target: PSSFSTarget, connectionWithOriginal params: [String : Any]?) {
        print("链接成功???")
    }
    
 
    func sfsTarget(_ target: PSSFSTarget, connectionFailed reason: PSSFSConnectionFailedCode, original params: [String : Any]?) {
        print("链接失败")
    }
    
    
    
    func sfsTarget(_ target: PSSFSTarget, loginWithConnected isConnected: Bool, original params: [String : Any]?) {
        print("IM登录成功???")
    }

    
    func sfsTarget(_ target: PSSFSTarget, loginFailed error: PSSFSLoginFailedCode, reason: String, original params: [String : Any]?) {
        print("IM登录失败???")
    }
    /// 重试大于3次失败后的一个事件
    func sfsTargetHandleFailureRetryFailed(_ target: PSSFSTarget) {
        print("登录大于三次失败")
    }
    
    // 创建房间成功 暂未用到
    func sfsTarget(_ target: PSSFSTarget, createdRoom room: [String : Any]?, error: String?) {
        
    }
    //房间删除时 暂未用到
    func sfsTarget(_ target: PSSFSTarget, removedRoom room: [String : Any]) {
        
    }
    /// 自己进入房间 比如: 自己进入直播间 或 自己开播进入直播间
    func sfsTarget(_ target: PSSFSTarget, selfEnterRoom room: [String : Any]?, error: String?) {
        
    }
    /// 有用户加入房间 比如: 观众B进入直播间
    func sfsTarget(_ target: PSSFSTarget, enterRoom room: [String : Any], ofUser user: [String : Any]) {
        
    }
    /// 有用户离开房间 比如: 观众B离开直播间
    func sfsTarget(_ target: PSSFSTarget, exitRoom room: [String : Any], ofUser user: [String : Any]) {
        
    }
    /// 房间有信息变更 比如: 直播间观众变化, 金币变化等
    func sfsTarget(_ target: PSSFSTarget, roomVariable room: [String : Any], update changes: [Any]) {
        
    }
    /// 房间内用户有信息变更 比如: 直播间观众变化, 金币变化等
    func sfsTarget(_ target: PSSFSTarget, userVariable user: [String : Any], update changes: [Any]) {
        
    }
    // 收到新消息
    func sfsTarget(_ target: PSSFSTarget, receiveMessage message: [String : Any], command: String, kind: PSSFSMessageKind, sender: [String : Any]?, original params: [String : Any]) {
        
    }
    
    func sfsTarget(_ target: PSSFSTarget, receiveResponse response: [String : Any], isSuccess: Bool, original params: [String : Any]) {
        
    }
    
    func sfsTarget(_ target: PSSFSTarget, receiveExtension data: [String : Any], command: String, original params: [String : Any]) {
        
    }
    
    
}*/

