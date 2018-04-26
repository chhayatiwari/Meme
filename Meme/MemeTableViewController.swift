//
//  MemeTableViewController.swift
//  Meme
//
//  Created by Chhaya Tiwari on 4/8/18.
//  Copyright © 2018 ChhayaTiwari. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {

    
    var memes: [Meme]!  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        tableView!.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell", for: indexPath) as! MemeTableViewCell
        let mm = self.memes[(indexPath as NSIndexPath).row]
      
        cell.imageT?.image = mm.meme
        cell.labelView?.text = mm.toptext
        return cell
    }
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.memes = self.memes[(indexPath as NSIndexPath).row]
        detailController.index = indexPath
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 120.0;//Choose your custom row height
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
              (UIApplication.shared.delegate as! AppDelegate).memes.remove(at: (indexPath ).row)
            tableView.reloadData()
        }
    }
}
