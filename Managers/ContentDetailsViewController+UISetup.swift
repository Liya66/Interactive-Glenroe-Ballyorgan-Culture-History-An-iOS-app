//
//  ContentDetailsViewController+UISetup.swift
//  Glenroe-Ballyorgan
//
//  Created by Liya Wang on 2024/9/28.
//

import Foundation
import UIKit

extension ContentDetailsViewController {
    // Setup the scroll view
    func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // Set up content view inside the scroll view
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
       
        
        NSLayoutConstraint.activate([
            // Constrain the contentView to the scrollView
                   contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                   contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                   contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                   contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                   contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor) // Match contentView width to scrollView width
            
        ])
    }
    
    // Setup the content (title, image, and description)
    func setupContent() {
        // Title Label
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "AvenirNext-Bold", size: 24)
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)
        
        
        // comment Label
        commentLabel = UILabel()
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        commentLabel.textAlignment = .left
        commentLabel.font = UIFont(name: "AvenirNext-Book", size: 14)
        commentLabel.textColor = .systemGray
        commentLabel.text = "Recent comments (log in to comment)"
        titleLabel.numberOfLines = 0
        contentView.addSubview(commentLabel)
        
        // Image View
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView)
        
        // Description Text Field
        descriptionTextField = UITextView()
        descriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextField.isScrollEnabled = false // Let UIScrollView handle scrolling
        descriptionTextField.font = UIFont(name: "AvenirNext-Medium", size: 16)
        descriptionTextField.isEditable = false
        contentView.addSubview(descriptionTextField)
        
        // Comment Text View
            commentTextView = UITextView()
            commentTextView.translatesAutoresizingMaskIntoConstraints = false
        commentTextView.layer.borderWidth = 0.5
            commentTextView.layer.borderColor = UIColor.gray.cgColor
            commentTextView.font = UIFont.systemFont(ofSize: 12)
          
            contentView.addSubview(commentTextView)

            // Submit Comment Button
            submitButton = UIButton(type: .system)
            submitButton.translatesAutoresizingMaskIntoConstraints = false
            submitButton.setTitle("Send", for: .normal)
        contentView.addSubview(submitButton)
        
        
        let sumbitImage = UIImage(systemName: "paperplane")
        submitButton.setImage(sumbitImage, for: .normal)
        submitButton.tintColor = .white
            submitButton.backgroundColor = UIColor(red: 2/255, green: 48/255, blue: 71/255, alpha: 1.0)
            submitButton.setTitleColor(.white, for: .normal)
            submitButton.layer.cornerRadius = 5
            submitButton.addTarget(self, action: #selector(submitComment), for: .touchUpInside)
        
            contentView.addSubview(submitButton)
        
        
        // hide comment section at first
        commentTextView.isHidden = true
        submitButton.isHidden = true

        
        
        // Create Comment Button
        commentControlButton = UIButton(type: .system)
        commentControlButton.translatesAutoresizingMaskIntoConstraints = false
        let commentImage = UIImage(systemName: "text.bubble.rtl")
        commentControlButton.setImage(commentImage, for: .normal)
        commentControlButton.tintColor = UIColor(red: 2/255, green: 48/255, blue: 71/255, alpha: 1.0)
        commentControlButton.layer.cornerRadius = 5

        //Add the button to the content view
        // Add target action
        commentControlButton.addTarget(self, action: #selector(toggleCommentSection), for: .touchUpInside)
        contentView.addSubview(commentControlButton)


   
        // Share Button
        shareButton = UIButton(type: .system)
        shareButton.translatesAutoresizingMaskIntoConstraints = false

         // Share button: Set title and image
        let shareImage = UIImage(systemName: "arrowshape.turn.up.forward.fill")
        shareButton.setImage(shareImage, for: .normal)

        // share button: layout of image
        shareButton.imageView?.contentMode = .scaleAspectFit
        shareButton.tintColor = UIColor(red: 2/255, green: 48/255, blue: 71/255, alpha: 1.0)
      
        shareButton.setTitleColor(.white, for: .normal)
        shareButton.layer.cornerRadius = 5

        // Add target action
        shareButton.addTarget(self, action: #selector(shareContent), for: .touchUpInside)
        contentView.addSubview(shareButton)
    }
    func setupCommentsTableView() {
          commentsTableView.translatesAutoresizingMaskIntoConstraints = false
          commentsTableView.dataSource = self
          commentsTableView.delegate = self
        
          // Register a basic UITableViewCell for the comments
          commentsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "CommentCell")
        //
        if comments.count == 0 {
            let noCommentsLabel = UILabel()
            noCommentsLabel.text = "waiting for more comments..."
            noCommentsLabel.textAlignment = .center
            noCommentsLabel.textColor = .gray // Optional, adjust as needed
            noCommentsLabel.font = UIFont.systemFont(ofSize: 15) //
            noCommentsLabel.backgroundColor = UIColor(red: 90/255, green: 90/255, blue: 90/255, alpha: 0.1)
            
            commentsTableView.backgroundView = noCommentsLabel
        } else {
            commentsTableView.backgroundView = nil
        }

          
          // Add the commentsTableView to the content view
          contentView.addSubview(commentsTableView)
      }
    
    // Constraints for the content view (including new comments section)
    func setupConstraints() {
        // Apply constraints
        NSLayoutConstraint.activate([
            // Title Label Constraints
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Image View Constraints
            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 270),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.85),
            
            // DescriptionTF Constraints
            descriptionTextField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            descriptionTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            // Comment Button Constraints
                commentControlButton.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 20),
                commentControlButton.trailingAnchor.constraint(equalTo: shareButton.leadingAnchor, constant: -10), // Place it to the left of the share button
                commentControlButton.heightAnchor.constraint(equalToConstant: 35),
                commentControlButton.widthAnchor.constraint(equalToConstant: 50),

                //  share button constraints
                shareButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                shareButton.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 20),
            shareButton.heightAnchor.constraint(equalToConstant: 35),
            
            
            // Comment Label Constraints
                commentLabel.topAnchor.constraint(equalTo: shareButton.bottomAnchor, constant: 10), // Space below buttons
                commentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20), // Left align with content view
                commentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20), // Optional trailing constraint for safety

                // Comments TableView Constraints
                commentsTableView.topAnchor.constraint(equalTo: commentLabel.bottomAnchor, constant: 10), // Space below label
                commentsTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                commentsTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            commentsTableView.heightAnchor.constraint(equalToConstant: 180), // Adjust the height according to the expected number of comments

            // Comment Text View Constraints
            commentTextView.topAnchor.constraint(equalTo: commentsTableView.bottomAnchor, constant: 20),
            commentTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            commentTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            commentTextView.heightAnchor.constraint(equalToConstant: 100),

            // Submit Button Constraints
            submitButton.topAnchor.constraint(equalTo: commentTextView.bottomAnchor, constant: 20),
            submitButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            submitButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            submitButton.heightAnchor.constraint(equalToConstant: 50),
            submitButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
           
          
        ])
    }

}
