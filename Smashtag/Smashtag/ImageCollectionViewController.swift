//
//  ImageCollectionViewController.swift
//  Smashtag
//
//  Created by Tatiana Kornilova on 7/12/15.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import UIKit
import Twitter

public struct TweetMedia: CustomStringConvertible
{
    var tweet: Twitter.Tweet
    var media: MediaItem
    
    public var description: String { return "\(tweet): \(media)" }
}

class ImageCollectionViewController: UICollectionViewController {

    
    var tweets: [[Tweet]] = [] {
        didSet {
            images = tweets.flatMap({$0})
                .map { tweet in
                    tweet.media.map { TweetMedia(tweet: tweet, media: $0) }}.flatMap({$0})
        }
    }
    
    private var images = [TweetMedia]()
    
    
    private var cache = NSCache()
    
    private struct Constants {
        static let CellReuseIdentifier = "Image Cell"
        static let SegueIdentifier = "Show Tweet"
        static let MinImageCellWidth: CGFloat = 60

    }
    
    var scale: CGFloat = 1 {
        didSet {
            collectionView?.collectionViewLayout.invalidateLayout()
        }
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.addGestureRecognizer(UIPinchGestureRecognizer(target: self,
                          action: #selector(ImageCollectionViewController.zoom(_:))))
        
       installsStandardGestureForInteractiveMovement = true

    }
    
    func zoom(gesture: UIPinchGestureRecognizer) {
        if gesture.state == .Changed {
            scale *= gesture.scale
            gesture.scale = 1.0
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            return images.count
    }
    
    override func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
                Constants.CellReuseIdentifier, forIndexPath: indexPath) as!  ImageCollectionViewCell
            
            cell.cache = cache
            cell.tweetMedia = images[indexPath.row]
            return cell
    }
    
    override func collectionView(collectionView: UICollectionView,
                  canMoveItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func collectionView(collectionView: UICollectionView,
                  moveItemAtIndexPath sourceIndexPath: NSIndexPath,
                           toIndexPath destinationIndexPath: NSIndexPath) {
        
        let temp = images[destinationIndexPath.row]
        images[destinationIndexPath.row] = images[sourceIndexPath.row]
        images[sourceIndexPath.row] = temp
        collectionView.collectionViewLayout.invalidateLayout()
    }

    
    // MARK: UICollectionViewDelegateFlowLayout
    
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
            let ratio = CGFloat(images[indexPath.row].media.aspectRatio)
            let maxCellWidth = collectionView.bounds.size.width
            let sizeSetting =  (collectionViewLayout as! UICollectionViewFlowLayout).itemSize
        
            var size = CGSize(width: sizeSetting.width * scale, height: sizeSetting.height * scale)
            if ratio > 1 {
                size.height /= ratio
            } else {
                size.width *= ratio
            }
            if size.width > maxCellWidth {
                size.width = maxCellWidth
                size.height = size.width / ratio
            }else if size.width < Constants.MinImageCellWidth {
                size.width = Constants.MinImageCellWidth
                size.height = size.width / ratio
        }
      
            return size
    }
    
    // MARK: - Navigation
    
    @IBAction private func toRootViewController(sender: UIBarButtonItem) {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.SegueIdentifier {
            if let ttvc = segue.destinationViewController as? TweetTableViewController {
                if let cell = sender as? ImageCollectionViewCell,
                    let tweetMedia = cell.tweetMedia {
                    ttvc.tweets = [[tweetMedia.tweet]]
                }
            }
        }
    }

 }
