//
//  MapARViewController.swift
//  Glenroe-Ballyorgan
//
//  Created by Liya Wang on 2024/8/5.
//
import UIKit
import MapboxMaps

class AnnotationView: UIView {
    private let label = UILabel()
    private let closeButton = UIButton(type: .close)

    var title: String? {
        didSet {
            label.text = title
        }
    }

    var onClose: (() -> Void)?
    var onSelect: ((Bool) -> Void)?

    var selected: Bool = false {
        didSet {
            backgroundColor = selected ? .lightGray : .white
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 8
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1

        label.frame = CGRect(x: 10, y: 10, width: frame.width - 20, height: frame.height - 20)
        label.numberOfLines = 0
        addSubview(label)

        closeButton.frame = CGRect(x: frame.width - 30, y: 5, width: 25, height: 25)
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        addSubview(closeButton)
    }

    @objc private func closeTapped() {
        onClose?()
    }
}
