//
//  TweetMensionTableViewController.swift
//  Smashtag
//
//  Created by Tatiana Kornilova on 7/17/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit

class TweetMensionTableViewController: TweetTableViewController {

    
    @IBAction func toRootViewController(sender: UIBarButtonItem) {
        navigationController?.popToRootViewControllerAnimated(true)
    }
}
