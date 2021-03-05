//
//  FeedViewController.swift
//  Parstagram
//
//  Created by Brayam Corral on 2/24/21.
//

import UIKit
import Parse
import AlamofireImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var posts = [PFObject]()
    var refreshControl: UIRefreshControl!
    var numberOfPosts: Int! = 1
    
    // Moves user to original screen
    @IBAction func onLogOut(_ sender: Any) {
        PFUser.logOut()
        let main = UIStoryboard(name: "Main", bundle: nil)
        // LoginViewController identifier of first screen
        let LoginViewContoller = main.instantiateViewController(identifier: "LoginViewController")
        let delegate = self.view.window?.windowScene?.delegate as! SceneDelegate
        delegate.window?.rootViewController = LoginViewContoller
    }
    
    
    func loadPosts(){
        let query = PFQuery(className: "Posts")
        query.order(byDescending: "createdAt")
        query.includeKeys(["author", "comments", "comments.author"])
        
        query.limit = numberOfPosts
        
        query.findObjectsInBackground{ (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
            }
        }
    }
    func loadMorePosts(){
        let query = PFQuery(className: "Posts")
        query.order(byDescending: "createdAt")
        // fetch author, comments, and author of each comment
        query.includeKeys(["author", "comments", "comments.author"])
        
        numberOfPosts = numberOfPosts + 1;
        query.limit = numberOfPosts
        
        query.findObjectsInBackground{ (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func onRefresh() {
        
        loadPosts()
        print("REFRESHED")
        // remove spinning refresh symbol
        self.refreshControl.endRefreshing()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        // Add Refresh Control
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadPosts()
    }
    
    // happens when user scrolls and is about to reach end
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt IndexPath: IndexPath) {
        if IndexPath.row + 1 == posts.count{
            loadMorePosts()
        }
    }
    
    // Add rows in each table row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let post = posts[section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        // comments + picture?
        return comments.count + 1
    }
    // Add rows in each table row
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        if indexPath.row == 0 {

            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
            
            let user = post["author"] as! PFUser
            cell.usernameLabel.text = user.username
            
            cell.captionLabel.text = post["caption"] as! String
            
            let imageFile = post["image"] as! PFFileObject
            let urlString = imageFile.url!
            let url = URL(string: urlString)!
            
            cell.photoView.af_setImage(withURL: url)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
            
            let comment = comments[indexPath.row - 1]
            cell.commentLabel.text = comment["text"] as? String
            
            let user = comment["author"] as! PFUser
            cell.nameLabel.text = user.username
            
            return cell
        }
    }
    
    // this runs when a row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        
        let comment = PFObject(className: "Comments")
        comment["text"] = "This is a random comment"
        comment["posts"] = post
        comment["author"] = PFUser.current()!
        
        post.add(comment, forKey: "comments")
        
        post.saveInBackground { (success, error) in
            if success {
                print("Comment Saved")
            } else {
                print("Comment did not save")
            }
        }
    }
}
