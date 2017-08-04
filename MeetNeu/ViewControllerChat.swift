//
//  ViewControllerChat.swift
//  MeetNeu
//
//  Created by Abraham Soto on 27/07/17.
//  Copyright © 2017 Abraham. All rights reserved.
//

import UIKit
import PubNub

class ViewControllerChat: UIViewController,UITableViewDelegate,UITableViewDataSource,PNObjectEventListener {
    @IBOutlet weak var tablaChat: UITableView!
    var client : PubNub! = PubNub()
    var config : PNConfiguration = PNConfiguration()
    var idEvento = ""
    var idSubevento = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        tablaChat.tableFooterView = UIView()
        //client.addListener(self)
        //client.subscribeToChannels(["chat-\(idEvento)-\(idSubevento)"], withPresence: false)
        config = PNConfiguration(publishKey: "pub-c-802945bc-d196-4f74-a912-7cfe7509fee6", subscribeKey: "sub-c-d8e85e92-5087-11e7-b7ac-02ee2ddab7fe")
        config.stripMobilePayload = false
        client = PubNub.clientWithConfiguration(config)
        
        client.addListener(self)
        client.subscribeToChannels(["chat-\(idEvento)-\(idSubevento)"], withPresence: false)
        
        //print("chat-\(idEvento)-\(idSubevento)")
        //client.subscribeToChannels(["chat-\(idEvento)-\(idSubevento)"], withPresence: false)
        //client.addListener(self)
        //client.publish("Swift+PubNub!", toChannel: "chat-\(idEvento)-\(idSubevento)", compressed: false, withCompletion: nil)
        self.client.publish("Hello from the PubNub Swift SDK Real time test", toChannel: "chat-\(idEvento)-\(idSubevento)", compressed: false, withCompletion: { (status) in
                                
            if !status.isError {
                print("Se mando el mensaje to channel: ")
                                    // Message successfully published to specified channel.
            }else{
                print("No se mano")
                                    /**
                                     Handle message publish error. Check 'category' property to find
                                     out possible reason because of which request did fail.
                                     Review 'errorData' property (which has PNErrorData data type) of status
                                     object to get additional information about issue.
                                     
                                     Request can be resent using: status.retry()
                                     */
            }
        })
        
        self.client.historyForChannel("history_channel", withCompletion: { (result, status) in
            
            if status == nil {
                print(result?.data.messages)
                /**
                 Handle downloaded history using:
                 result.data.start - oldest message time stamp in response
                 result.data.end - newest message time stamp in response
                 result.data.messages - list of messages
                 */
            }
            else {
                
                /**
                 Handle message history download error. Check 'category' property
                 to find out possible reason because of which request did fail.
                 Review 'errorData' property (which has PNErrorData data type) of status
                 object to get additional information about issue.
                 
                 Request can be resent using: status.retry()
                 */
            }
        })
        
        // Do any additional setup after loading the view.
    }
    
    func client(client: PubNub, didReceiveStatus status: PNStatus) {
        
        if status.operation == .subscribeOperation && status.category == .PNConnectedCategory {
            client.publish(["foo": "bar"], toChannel: "chat-\(idEvento)-\(idSubevento)",
                           withCompletion: { (publishStatus) in
                            
                            if !publishStatus.isError {
                                print("Published!")
                            }
                            else {
                                print("Publish did fail with error: \(status.isError.description)")
                            }
            })
        }
    }
    
    func client(client: PubNub!, didReceiveMessage message: PNMessageResult!) {
        print(message.data.message ?? "HAKUNA")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressCross(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
