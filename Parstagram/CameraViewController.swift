//
//  CameraViewController.swift
//  Parstagram
//
//  Created by Brayam Corral on 2/24/21.
// loginSegue

import UIKit
import AlamofireImage
import Parse

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentField: UITextField!
    
    @IBAction func onSubmit(_ sender: Any) {
        
        // parse creates schema based on these attributes
        // creates table
        let post = PFObject(className: "Posts")
        
        // if attribute doesnt exist, creates attributes with data
        post["caption"] = commentField.text
        post["author"] = PFUser.current()!
        
        let imageData = imageView.image!.pngData()
        
        // makes new table
        let file = PFFileObject(data: imageData!)
        
        post["image"] = file
        
        post.saveInBackground { (success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
                print("saved!")
            } else {
                print("error!")
            }
        }
        
        
    }
    
    @IBAction func onCameraButton(_ sender: Any) {
        
        print("Clicked on feed pic")
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
        
        imageView.image = scaledImage
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
