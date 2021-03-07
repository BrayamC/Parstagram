//
//  ProfileTabViewController.swift
//  Parstagram
//
//  Created by Brayam Corral on 3/7/21.
//

import UIKit
import AlamofireImage
import Parse

class ProfileTabViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var submitUIButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func onSubmit(_ sender: Any) {
        submitUIButton.backgroundColor = UIColor.red
        
        // Edit current user in table "User"
        let post = PFObject(className: "User")
        post["author"] = PFUser.current()!
        
        // Get image from image view and store into a Parse object
        let imageData = profileImageView.image!.pngData()
        let file = PFFileObject(data: imageData!)
        
        // Store picture into database
        post["profilePicture"] = file
        
        // Try to store in database
        post.saveInBackground { (success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
                print("Profile picture updated")
            } else {
                print("Could not update picture")
            }
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
        let scaledImage = image.af_imageAspectScaled(toFit: size)
        
        profileImageView.image = scaledImage
        
        dismiss(animated: true, completion: nil)
    }

}
