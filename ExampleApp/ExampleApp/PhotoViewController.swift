//
//  PhotoViewController.swift
//  
//
//  Created by Alvin He on 10/4/2023.
//

import AsyncDataLoader
import UIKit

class PhotoViewController: UIViewController {

    private let asyncDataLoader: AsyncDataLoaderProtocol
    private let index: Int
    private var imageURL: String {
//        "https://simpl.info/bigimage/bigImage.jpg"
        "https://picsum.photos/id/\(index)/\(Int(view.bounds.width) * 5)/\(Int(view.bounds.height) * 5)"
    }
    private var imageLoadingTask: Task<Void, Error>?

    private lazy var progressIndicator: UIProgressView = {
        let indicator = UIProgressView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.leftAnchor.constraint(equalTo: view.leftAnchor),
            indicator.rightAnchor.constraint(equalTo: view.rightAnchor),
            indicator.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
        return indicator
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        return imageView
    }()

    init(
        asyncDataLoader: AsyncDataLoaderProtocol,
        index: Int
    ) {
        self.asyncDataLoader = asyncDataLoader
        self.index = index
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.title = "#\(index)"
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        imageLoadingTask?.cancel()
        imageLoadingTask = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        imageLoadingTask = loadImageData()
    }

    private func loadImageData() -> Task<Void, Error> {
        return Task { [asyncDataLoader, imageURL, progressIndicator, imageView] in
            do {
                let stream = try await asyncDataLoader.download(from: imageURL)
                for try await status in stream {
                    switch status {
                    case let .inProgress(progress):
                        progressIndicator.isHidden = false
                        progressIndicator.setProgress(Float(progress), animated: true)
                        print(".setProgress(\(progress))")
                    case let .finished(data):
                        progressIndicator.isHidden = true
                        imageView.image = UIImage(data: data)
                    }
                }
            } catch {
                print(error)
            }
        }
    }
}
