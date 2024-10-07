//
//  EventsViewController.swift
//  Glenroe-Ballyorgan
//
//  Created by Liya Wang on 2024/9/12.
//

import UIKit

class EventsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var events = [Event]()
    var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure layout for UICollectionView
           let layout = UICollectionViewFlowLayout()
           layout.itemSize = CGSize(width: self.view.frame.width - 40, height: 255)
           layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        // Adjust spacing between items and sections
//                layout.minimumInteritemSpacing = 10 // Horizontal spacing between cells
                //layout.minimumLineSpacing = 10      // Vertical spacing between cells

           collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
           collectionView.delegate = self
           collectionView.dataSource = self
           collectionView.register(EventCell.self, forCellWithReuseIdentifier: "EventCell")
           self.view.addSubview(collectionView)
           
           // Adjust content inset for the collection view to make space for the label
           let labelHeight: CGFloat = 30
           collectionView.contentInset = UIEdgeInsets(top: labelHeight + 20, left: 0, bottom: 0, right: 0)
//
//        // Add a background view for the header
//        let headerBackgroundView = UIView()
//        headerBackgroundView.backgroundColor = UIColor.white // Set your desired color
//        headerBackgroundView.translatesAutoresizingMaskIntoConstraints = false
//        
//        self.view.addSubview(headerBackgroundView)
        
        // Add a label at the top
        let headerLabel = UILabel()
        headerLabel.text = "Recent Events"
        headerLabel.font = UIFont(name: "AvenirNext-Bold", size: 24)
        headerLabel.textColor = UIColor(red: 2/255, green: 48/255, blue: 71/255, alpha: 1.0)
        headerLabel.textAlignment = .left
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(headerLabel)
           
           // Set up constraints
//        NSLayoutConstraint.activate([
//               headerBackgroundView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
//               headerBackgroundView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
//               headerBackgroundView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
//               headerBackgroundView.heightAnchor.constraint(equalToConstant: 60) // Adjust height as needed
//           ])
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            headerLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20), // Use leadingAnchor for left alignment
            headerLabel.heightAnchor.constraint(equalToConstant: labelHeight)
        ])

           
        // Fetch events from Firebase
        EventManager().fetchEvents { events in
            DispatchQueue.main.async {
                self.events = events
                self.collectionView.reloadData()
            }
        }
    }

    // UICollectionView DataSource methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCell", for: indexPath) as! EventCell
        let event = events[indexPath.row]
        cell.configure(with: event)
        return cell
    }

    // Navigate to WebView on event click
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedEvent = events[indexPath.row]
        performSegue(withIdentifier: "showWebView", sender: selectedEvent)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWebView" {
            if let webVC = segue.destination as? EventsWebViewController,
               let event = sender as? Event {
                // Pass the URL to the web view controller
                webVC.url = URL(string: event.eventURL)
            }
        }
    }

    
}


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


