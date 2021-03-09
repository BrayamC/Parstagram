//
//  ProfileTabViewController.swift
//  Parstagram
//
//  Created by Brayam Corral on 3/7/21.
//
// @ios-help Ive been trying to get an image from the parse database but I cant seem to get it to work. The image is in the "User" table in a column called "profilePicture"

import UIKit
import AlamofireImage
import Parse

class ProfileTabViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var submitUIButton: UIButton!
    @IBOutlet weak var updatedProfilePictureImageView: UIImageView!
    
    // This works
    @IBAction func temp(_ sender: Any) {
        
        if let currentUser = PFUser.current(){
            let imageFile = currentUser["profilePicture"] as! PFFileObject
            print(imageFile)
            let urlString = imageFile.url // CRASHES, image is nil
            let url = URL(string: urlString!)!
            updatedProfilePictureImageView.af_setImage(withURL: url)
         }
         
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //updatePicture()
    }
    
    // Update profile Picture -- Crashes here
    @IBAction func onSubmit(_ sender: Any) {
        // Get image from image view and store into a Parse object
        let imageData = profileImageView.image!.pngData()
        let file = PFFileObject(data: imageData!)
        // Update profile Picture in database
        if let currentUser = PFUser.current(){
            currentUser["profilePicture"] = file
            //set other fields the same way....
            currentUser.saveInBackground()
        }

        /*
        // CRASHES HERE
        if let currentUser = PFUser.current(){
            let imageFile = currentUser["profilePicture"] as! PFFileObject
            print(imageFile)
            let urlString = imageFile.url // CRASHES, image is nil
            let url = URL(string: urlString!)!
            updatedProfilePictureImageView.af_setImage(withURL: url)
         }
 */

    }
    
    var image = [PFObject]()
    
    func updatePicture(){
        if let currentUser = PFUser.current(){
            let imageFile = currentUser["profilePicture"] as! PFFileObject
            print(imageFile)
            let urlString = imageFile.url // CRASHES, image is nil
            let url = URL(string: urlString!)!
            updatedProfilePictureImageView.af_setImage(withURL: url)
         }
    }
    
    
    @IBAction func onCameraButton(_ sender: Any) {
        
        print("Clicked on profile pic tap gesture")
        // launch camera
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        // Use camera if possible, else use library
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af.imageAspectScaled(toFit: size)
        
        profileImageView.image = scaledImage
        
        dismiss(animated: true, completion: nil)
    }

}
