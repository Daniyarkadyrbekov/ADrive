//
//  DistanceTableControllerTableViewController.swift
//  ADrive
//
//  Created by Данияр Кадырбеков on 02.11.17.
//  Copyright © 2017 Данияр Кадырбеков. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire

class DistanceTableControllerTableViewController: UITableViewController {
    
    let profileAvatar = ["TestImage1","TestImage2","TestImage3"]
    var marker = [GMSMarker]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userState = UserStateModel()
        if let token = userState.token {
            //Get to auth to check is token valid
            let headers: HTTPHeaders = [
                "token": token
            ]
            print(token)
            Alamofire.request("https://warm-castle-66534.herokuapp.com/push",method: .post, headers: headers)
                .responseJSON { response in
                    print(response)
            }
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return marker.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DistanceCell", for: indexPath)

        cell.textLabel?.text = marker[indexPath.row].title
        cell.detailTextLabel?.text = "Detail about user"
        cell.imageView?.image = UIImage(named: profileAvatar[generateRandomNumber()])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "по удаленности"
    }
    
    
    func generateRandomNumber() -> Int {
        return Int(arc4random_uniform(3))
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
