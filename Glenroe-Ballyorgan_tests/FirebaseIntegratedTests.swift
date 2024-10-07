//
//  FirebaseIntegratedTests.swift
//  Glenroe-Ballyorgan_tests
//
//  Created by Liya Wang on 2024/10/3.
//

import XCTest
import Firebase
import FirebaseDatabase
@testable import Glenroe_Ballyorgan

class FirebaseIntegrationTests: XCTestCase {
    
    var viewController: ContentDetailsViewController!
    var ref: DatabaseReference!
    var commentsTableView: UITableView! = nil

    
    override func setUpWithError() throws {
        super.setUp()
        
        // Initialize Firebase for testing
//        FirebaseApp.configure()

        // Create a reference to Firebase Realtime Database
        ref = Database.database().reference()
        
        // Initialize the view controller for testing
        viewController = ContentDetailsViewController()
        viewController.contentItem = ContentItem(id: "testContentID", title: "Test Title", description: "Test Description", imageURL: "testImage.png", category: "History")
        
        // Manually initialize the comment UI components
               viewController.commentTextView = UITextView()
               viewController.submitButton = UIButton()
               viewController.commentsTableView = UITableView() // Now works since it's var

               viewController.loadViewIfNeeded()  // Trigger viewDidLoad
    }
    
    override func tearDownWithError() throws {
        // Clean up after test
        ref = nil
        viewController = nil
        super.tearDown()
    }
    
    // Test fetching comments from Firebase
    func testFetchCommentsFromFirebase() throws {
        let expectation = self.expectation(description: "Comments should be fetched from Firebase")
        
        // Set up mock comment data in Firebase
        let commentData: [String: Any] = [
            "userID": "testUserID",
            "userName": "Test User",
            "commentText": "This is a test comment",
            "timestamp": Date().timeIntervalSince1970
        ]
        let contentID = "testContentID"
        let commentsRef = ref.child("comments").child(contentID)
        commentsRef.childByAutoId().setValue(commentData)
        
        // Fetch comments from Firebase
        viewController.fetchComments()
        
        // Wait a bit to ensure Firebase call completes
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            XCTAssertFalse(self.viewController.comments.isEmpty, "Comments should not be empty after fetching")
            XCTAssertEqual(self.viewController.comments[0], "Test User: This is a test comment", "Comment should be correctly fetched from Firebase")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }

    // Test submitting a comment to Firebase
    func testSubmitCommentToFirebase() throws {
        let expectation = self.expectation(description: "Comment should be submitted to Firebase")

        // Simulate the user entering a comment
        viewController.commentTextView.text = "This is a new comment"
        
        // Simulate the submit button press
        viewController.submitComment()
        
        // Check if the comment was added to Firebase
        ref.child("comments").child("testContentID").observeSingleEvent(of: .value) { snapshot in
            var foundComment = false
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let data = childSnapshot.value as? [String: Any],
                   let commentText = data["commentText"] as? String,
                   commentText == "This is a new comment" {
                    foundComment = true
                }
            }
            XCTAssertTrue(foundComment, "The comment should have been added to Firebase")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    // Test real-time updates for comments
    func testRealTimeUpdatesForComments() throws {
        let expectation = self.expectation(description: "Real-time comment updates should work")

        // Add initial comment
        let commentData: [String: Any] = [
            "userID": "testUserID",
            "userName": "Test User",
            "commentText": "Initial comment",
            "timestamp": Date().timeIntervalSince1970
        ]
        ref.child("comments").child("testContentID").childByAutoId().setValue(commentData)
        
        // Observe real-time updates
        viewController.fetchComments()

        // Simulate adding a new comment
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let newCommentData: [String: Any] = [
                "userID": "testUserID2",
                "userName": "User 2",
                "commentText": "Real-time comment",
                "timestamp": Date().timeIntervalSince1970
            ]
            self.ref.child("comments").child("testContentID").childByAutoId().setValue(newCommentData)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            XCTAssertEqual(self.viewController.comments.last, "User 2: Real-time comment", "Real-time updates should be reflected in the UI")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 6.0, handler: nil)
    }
}
