//
//  ContentDetailsViewController.swift
//  Glenroe-Ballyorgan
//
//  Created by Liya Wang on 2024/8/9.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ContentDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var scrollView: UIScrollView!
    var contentView: UIView!
    var imageView: UIImageView!
    var titleLabel: UILabel!
    var descriptionTextField: UITextView!
    var commentTextView: UITextView!
    var submitButton: UIButton!
    var shareButton: UIButton!
    var commentControlButton: UIButton!
    var commentLabel: UILabel!
    var contentItem: ContentItem?
    // Create the UITableView to show user comments
    var commentsTableView = UITableView()
       
    var comments: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupScrollView()
        setupContent()
        // Set up the commentsTableView
        setupCommentsTableView()
       
        
        // Register for keyboard notifications
          NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
          NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
          
        // dissmiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tapGesture)

        // Populate the UI elements with the content item data
        if let contentItem = contentItem {
            titleLabel.text = contentItem.title
            descriptionTextField.text = contentItem.description
            // For image loading, assuming you load the image from a URL or local assets
            imageView.image = UIImage(named: contentItem.imageURL)
            
            setupConstraints()
        } else {
            print("ContentItem is nil")
        }
        
        fetchComments()
    }
        
    @objc func dismissKeyboard() {
        view.endEditing(true)  // dismiss the keyboard
    }
      
      // Implement required UITableView data source methods
    // Reload the table view after fetching comments
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath)
        cell.textLabel?.text = comments[indexPath.row]
        // Allow the textLabel to support multiple lines
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.font = UIFont.systemFont(ofSize: 12)
        return cell
    }

      // Set the height for each comment cell
      func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 60 // Adjust as per your need
      }
      
      
  
    // Action when submitting comment
    @objc func submitComment() {
        guard let user = Auth.auth().currentUser else {
            showAlert(message: "Please log in to comment")
            print("User not logged in")
            return
        }

        guard let contentID = contentItem?.id else {
            print("Content ID not found")
            return
        }

        // Fetch the comment from the commentTextView
        let commentText = commentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if commentText.isEmpty {
            print("Comment is empty")
            return
        }
        
        // Get a reference to Firebase Realtime Database
        let ref = Database.database().reference()

        // Create a unique comment ID
        let newCommentRef = ref.child("comments").child(contentID).childByAutoId()

        // Set the comment data
        let commentData: [String: Any] = [
            "userID": user.uid,
            "userName": user.displayName ?? "Anonymous",
            "commentText": commentText,
            "timestamp": Date().timeIntervalSince1970
        ]
        
        // Save the comment in Firebase Realtime Database
        newCommentRef.setValue(commentData) { error, _ in
            if let error = error {
                print("Error uploading comment: \(error.localizedDescription)")
            } else {
                print("Comment successfully uploaded!")
                self.commentTextView.text = "" // Clear the text input
                
                // Optionally fetch comments again to refresh the UI
                self.fetchComments()
            }
        }
    }
    //fetch
    func fetchComments() {
        guard let contentID = contentItem?.id else {
            print("Content ID not found")
            return
        }

        // Get a reference to the comments node for the current content ID
        let ref = Database.database().reference().child("comments").child(contentID)
        
        ref.observe(.value) { snapshot in
            // Clear the current comments array
            self.comments.removeAll()

            // Parse the snapshot data
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let data = snapshot.value as? [String: Any] {
                    
                    let userName = data["userName"] as? String ?? "Anonymous"
                    let commentText = data["commentText"] as? String ?? ""
                    
                    // Append the comment to the comments array
                    self.comments.append("\(userName): \(commentText)")
                }
            }
            
           
            // Reload the table view on the main thread
                   DispatchQueue.main.async {
                       self.commentsTableView.reloadData()
                   }
        }
    }

    
    // Share Action
    @objc func shareContent() {
        let textToShare = [contentItem?.description ?? "Check this out!"]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    //comment button toggling
    @objc func toggleCommentSection() {
        // Toggle visibility of the commentTextView and submitCommentButton
        let isHidden = commentTextView.isHidden
        commentTextView.isHidden = !isHidden
        submitButton.isHidden = !isHidden
        
        // Toggle the button image
        let newImageName = isHidden ? "text.bubble.fill.rtl" : "text.bubble.rtl"
        commentControlButton.setImage(UIImage(systemName: newImageName), for: .normal)
    }
// alert
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Oops!",
                                      message: message,
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("start fetching")
        fetchComments() // Fetch comments each time the view appears
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Deregister from keyboard notifications
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //to avoid covering text view!
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            let bottomInset = keyboardHeight - view.safeAreaInsets.bottom
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
            scrollView.scrollIndicatorInsets = scrollView.contentInset

            // Calculate the frame of commentTextView relative to the scrollView
            let commentTextViewFrame = commentTextView.convert(commentTextView.bounds, to: scrollView)
            
            // Calculate the visible area height
            let visibleHeight = scrollView.frame.height - keyboardHeight
            
            // If commentTextView's bottom is below the visible area, scroll to make it visible
            if commentTextViewFrame.maxY > visibleHeight {
                let offsetY = commentTextViewFrame.maxY - visibleHeight + 20 // Extra padding for better visibility
                scrollView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: true)
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
}
