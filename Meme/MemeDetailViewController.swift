//
//  MemeDetailViewController.swift
//  Meme
//
//  Created by Chhaya Tiwari on 4/8/18.
//  Copyright © 2018 ChhayaTiwari. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    var memes: Meme!
    @IBOutlet weak var detailImage: UIImageView!
    var index: IndexPath = []
    //var tableView: MemeTableViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(edit))
    }
    @objc func edit() {
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let resultVC = storyboard.instantiateViewController(withIdentifier: "MemeEditor") as! MemeEditorViewController
        resultVC.memeToEdit = memes
        present(resultVC, animated: true, completion: nil)
        
        (UIApplication.shared.delegate as! AppDelegate).memes.remove(at: (index).row)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.detailImage!.image = memes.meme
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

    
}
