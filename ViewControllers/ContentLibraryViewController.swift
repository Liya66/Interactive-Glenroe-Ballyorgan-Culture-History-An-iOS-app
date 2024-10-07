//
//  ContentLibraryViewController.swift
//  Glenroe-Ballyorgan
//
//  Created by Liya Wang on 2024/8/3.
//

import UIKit

//  a model to represent each section
struct Section {
    var title: String
    var items: [ContentItem]
    var isExpanded: Bool
}

class ContentLibraryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
  var tableView: UITableView!
  var searchBar: UISearchBar!
   
var collectionView: UICollectionView!
    
    //make the screen scrollable
    let scrollView = UIScrollView()
    let contentView = UIView()
    let headerLabel = UILabel()
    
    
    
    // Replace the single contentItems array with a sections array
    var sections: [Section] = []
    var filteredSections: [Section] = []
    let carouselImages = ["History_image.png", "Churches_image.png", "Graveyards_image.png", "Local_Sites_image.png"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        setupContentView()
        setupHeaderLabel()
        setupSearchBar()
        setupCollectionView()
        setupTableView()
        //dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
         tapGesture.cancelsTouchesInView = false  // Allow other touch events (like table view cell taps)
         view.addGestureRecognizer(tapGesture)
        
        // Calculate the desired height (1.2 * screen height)
        let desiredHeight = UIScreen.main.bounds.height * 1.2

        // Set the height constraint for contentView
        contentView.heightAnchor.constraint(equalToConstant: desiredHeight).isActive = true
       
      
        

        
        // Fetch stories and group them into sections
        let contentItems = StoryManager.shared.fetchStories()
        
        // divide contentItems into sections
        let historyItems = contentItems.filter { $0.category == "History" }
        let churchesItems = contentItems.filter { $0.category == "Churches" }
        let graveyardsItems = contentItems.filter { $0.category == "Graveyards" }
        let localSitesItems = contentItems.filter { $0.category == "Local Sites" }
        let moreInfoItems = contentItems.filter { $0.category == "More Info" }
        
        sections = [
            Section(title: "History", items: historyItems, isExpanded: false),
            Section(title: "Churches", items: churchesItems, isExpanded: false),
            Section(title: "Graveyards", items: graveyardsItems, isExpanded: false),
            Section(title: "Local Sites", items: localSitesItems, isExpanded: false),
            Section(title: "More Info", items: moreInfoItems, isExpanded: false)
        ]
        
        filteredSections = sections
        
        // Set delegates
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
       
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)  //  dismiss the keyboard
    }
    private func setupHeaderLabel() {
        headerLabel.text = "Explore"
        headerLabel.font = UIFont(name: "AvenirNext-Bold", size: 24)
        headerLabel.textAlignment = .left
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(headerLabel) // Ensure added to contentView
        
        // Set constraints after adding to contentView
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            headerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            headerLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        headerLabel.textColor = UIColor(red: 2/255, green: 48/255, blue: 71/255, alpha: 1.0)
    }

    private func setupSearchBar() {
           searchBar = UISearchBar() // Initialize the searchBar
           searchBar.translatesAutoresizingMaskIntoConstraints = false
           contentView.addSubview(searchBar) // Add it to contentView
           searchBar.delegate = self // Set the delegate after initialization
           
           // Set up constraints for the searchBar
           NSLayoutConstraint.activate([
               searchBar.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 10),
               searchBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
               searchBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
               searchBar.heightAnchor.constraint(equalToConstant: 44) // Set height
           ])
       }
 
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 310, height: 206)
        layout.minimumLineSpacing = 10

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(collectionView)

        collectionView.register(ContentImagesViewCell.self, forCellWithReuseIdentifier: "CarouselCell")
        collectionView.backgroundColor = .clear

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 206)
        ])
    }

    private func setupTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor) // This is crucial
        ])

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }




    private func setupScrollView() {
            view.addSubview(scrollView)
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                scrollView.topAnchor.constraint(equalTo: view.topAnchor),
                scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        }
    
    private func setupContentView() {
            scrollView.addSubview(contentView)
            contentView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
            ])
        }

    // MARK: - UICollectionView DataSource and Delegate
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return carouselImages.count
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselCell", for: indexPath) as! ContentImagesViewCell
            cell.imageView.image = UIImage(named: carouselImages[indexPath.item])
            return cell
        }

        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            // Handle the tap and expand the relevant section in the table view
            expandSection(forIndex: indexPath.item)
        }
    
    func expandSection(forIndex index: Int) {
          for i in 0..<filteredSections.count {
              filteredSections[i].isExpanded = (i == index)
          }
          tableView.reloadData()
          // Scroll to the section
          let indexPath = IndexPath(row: NSNotFound, section: index)
          tableView.scrollToRow(at: indexPath, at: .top, animated: true)
      }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredSections[section].isExpanded ? filteredSections[section].items.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
        let item = filteredSections[indexPath.section].items[indexPath.row]
        cell.textLabel?.text = item.title
       
        
        // Set the text color for the cell's text label
        cell.textLabel?.textColor = UIColor(red: 2/255, green: 48/255, blue: 71/255, alpha: 1.0)
       
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        
        // Perform the segue with the identifier you set in the storyboard
        performSegue(withIdentifier: "showContentDetails", sender: self)
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UITableViewHeaderFooterView()
        headerView.textLabel?.text = filteredSections[section].title
        headerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleExpandCollapse)))
        headerView.tag = section
        return headerView
    }
    
    @objc func handleExpandCollapse(gestureRecognizer: UITapGestureRecognizer) {
        guard let section = gestureRecognizer.view?.tag else { return }
        filteredSections[section].isExpanded.toggle()
        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredSections = sections
        } else {
            filteredSections = sections.map { section in
                let filteredItems = section.items.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
                return Section(title: section.title, items: filteredItems, isExpanded: !filteredItems.isEmpty)
            }
        }
        tableView.reloadData()
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showContentDetails" {
            guard let detailVC = segue.destination as? ContentDetailsViewController,
                  let indexPath = tableView.indexPathForSelectedRow else {
                print("Failed to get indexPath or detailVC")
                return
            }
            
            print("Selected section: \(indexPath.section), row: \(indexPath.row)")

            // Get the selected ContentItem
            let selectedItem = filteredSections[indexPath.section].items[indexPath.row]
            
            // Debugging: Print the selected item
            print("Selected Item: \(selectedItem.title)")

            // Pass the selected ContentItem to the ContentDetailViewController
            detailVC.contentItem = selectedItem
        }
    }

    

}
