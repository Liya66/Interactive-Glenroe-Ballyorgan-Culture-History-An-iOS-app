//
//  EventCell.swift
//  Glenroe-Ballyorgan
//
//  Created by Liya Wang on 2024/9/17.
//
import UIKit

class EventCell: UICollectionViewCell {
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let dateLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        //set the background color
    //  backgroundColor = UIColor.lightGray

        // Configure image view
        imageView.contentMode = .scaleAspectFill
        contentView.addSubview(imageView)
        imageView.layer.cornerRadius = 8 // corner radius
        imageView.layer.masksToBounds = true //  the corners should be clipped to the rounded shape

        // Configure title
        titleLabel.font = UIFont(name: "AvenirNext-Bold", size: 16)
        contentView.addSubview(titleLabel)
        
        // Configure description
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(descriptionLabel)
        
        // Configure date
        dateLabel.font = UIFont.italicSystemFont(ofSize: 12)
        contentView.addSubview(dateLabel)
        
        // Set up layout constraints
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 150),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with event: Event) {
        titleLabel.text = event.title
        descriptionLabel.text = event.description
        dateLabel.text = event.date
        
        // Load image from URL
        if let url = URL(string: event.imageURL) {
            imageView.load(url: url)
        }
    }
}

// Extension to load images
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
