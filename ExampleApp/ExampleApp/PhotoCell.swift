//
//  ViewController.swift
//  ExampleApp
//
//  Created by Alvin He on 23/2/2023.
//

import UIKit

protocol DismissibleCell {
    func dismiss()
}

class PhotoCell: UICollectionViewCell, DismissibleCell {

    static let reusedIdentifier = "ExampleApp.PhotoCell"

    private let imageView = UIImageView()

    private var task: Task<Void, Error>?

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .gray
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = self.bounds
    }

    func dismiss() {
        self.task?.cancel()
        self.task = nil
        self.imageView.image = nil
    }

    func loadImage(_ url: String) {
        self.task = Task {

        }
    }
}
