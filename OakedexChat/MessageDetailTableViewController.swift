//
//  MessageDetailTableViewController.swift
//  OakedexChat
//
//  Created by Michael Mecham on 3/6/16.
//  Copyright © 2016 MichaelMecham. All rights reserved.
//

import UIKit

class MessageDetailTableViewController: UITableViewController, UITextFieldDelegate {
    
    var thread: Thread?
    var messages: [Message] = []
    
    @IBOutlet weak var messageTextField: UITextField!
    
    // MARK: - VC LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.shouldRasterize = true
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadMyTables", name: "messagesChanged", object: nil)
        self.navigationItem.title = "75"
        
        if let thread = thread {
            if let identifier = thread.identifier {
                ThreadController.observeMessageForThreadID(identifier, completion: { (message) -> Void in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        if let message = message {
                            self.messages = message.filter({$0.threadIdentifier == identifier})
                            self.tableView.reloadData()
                        }
                    })
                })
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Action Buttons
    
    @IBAction func sendButtonTapped(sender: AnyObject) {
            if let text = messageTextField.text, currentUser = UserController.sharedController.currentUser, thread = thread {
            ThreadController.createMessage(text, sender: currentUser, thread: thread, completion: { (message) -> Void in
                print(message?.text)
                self.messageTextField.text = ""
                self.navigationController?.title = "75"
            })
        }
    }
    
    @IBAction func reportbuttonTapped(sender: AnyObject) {
        let alertController = UIAlertController(title: "Report Content", message: "Would you like to report this content as inappropriate or objectionable content?", preferredStyle: .ActionSheet)
        let reportAction = UIAlertAction(title: "Report", style: .Default) { (tappedSon) -> Void in
            if let thread = self.thread {
              ThreadController.reportThread(thread)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(reportAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil) 
    }

    // MARK: - TextField Delegate Methods
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if range.length + range.location > messageTextField.text?.characters.count {
            return false
        }
        let newLength = (messageTextField.text!.characters.count + string.characters.count - range.length)
        if newLength <= 75 {
            if newLength >= 65 {
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.ashHatRed()]
            } else {
                self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.blackColor()]
            }
        self.navigationItem.title = "\(75 - newLength)"
            
        } else {
            self.navigationItem.title = "0"
        }
        
        return newLength <= 75
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if !messages.isEmpty {
            return messages.count
        } else {
            return 0
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("messageCell", forIndexPath: indexPath)
        //cell.textLabel?.text = "\(messages[indexPath.row].sender): \(messages[indexPath.row].text)"
        let message = messages[indexPath.row]
        var senderUserName: String = ""
        UserController.userForIdentifier(message.senderID) { (user) -> Void in
            if let user = user {
                senderUserName = user.username
                
                cell.textLabel?.text = "\(senderUserName): \(message.text)"
                cell.layer.cornerRadius = 8
                cell.contentView.layer.cornerRadius = 8
                cell.layer.borderColor = UIColor.blackColor().CGColor
                cell.layer.borderWidth = 2
                cell.layer.masksToBounds = true
            } else {
                cell.textLabel?.text = "Prof Oak: Oh, it looks like someone has fallen from the converation and can't get back up."
            }
        }
        return cell
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
