//
//  DemoViewController.swift
//  ExampleApp
//
//  Created by Alvin He on 23/2/2023.
//

import AsyncDataLoader
import SwiftUI
import UIKit

class DemoViewController: UIViewController {
    private let asyncDataLoader = AsyncDataLoader(
        diskCacheManager: DiskCacheManager(fileMananger: FileManager.default),
        downloadManager: DownloadManager(
            downloadSessionFactory: DownloadSessionFactory(serverSession: URLSession.shared)
        ),
        inMemoryCacheMananger: InMemoryCacheManager(cache: .init()),
        serverSession: URLSession.shared
    )

    private lazy var uikitDemoButton: UIButton = {
        let button = UIButton(type: .system)
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20)
        ])
        button.setTitle("UIKit Demo", for: .normal)
        return button
    }()

    private lazy var swiftuiDemoButton: UIButton = {
        let button = UIButton(type: .system)
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20)
        ])
        button.setTitle("SwiftUI Demo", for: .normal)
        return button
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = "AsyncDataLoader Demo"
        navigationItem.backButtonTitle = "Demo"
        view.backgroundColor = .systemBackground
        uikitDemoButton.addTarget(
            self,
            action: #selector(onUIKitButton),
            for: .touchUpInside
        )
        swiftuiDemoButton.addTarget(
            self,
            action: #selector(onSwiftUIButton),
            for: .touchUpInside
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .trash,
            target: self,
            action: #selector(clearCache)
        )
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func onUIKitButton() {
        let viewController = PhotosCollectionViewController(
            asyncDataLoader: asyncDataLoader,
            collectionViewLayout: PhotosCollectionViewController.collectionViewLayout
        )
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    @objc private func onSwiftUIButton() {
        let viewController = UIHostingController(
            rootView: PhotosListView(asyncDataLoader: asyncDataLoader)
        )
        viewController.title = "SwiftUI Demo"
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    @objc private func clearCache() {
        Task {
            try await asyncDataLoader.clearCache()
        }
    }
}
