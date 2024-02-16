//
//  PhotosCollectionViewController.swift
//  ExampleApp
//
//  Created by Alvin He on 23/2/2023.
//

import AsyncDataLoader
import UIKit

class PhotosCollectionViewController: UICollectionViewController {
    private let asyncDataLoader: AsyncDataLoaderProtocol

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(
        asyncDataLoader: AsyncDataLoaderProtocol,
        collectionViewLayout layout: UICollectionViewLayout
    ) {
        self.asyncDataLoader = asyncDataLoader
        super.init(collectionViewLayout: layout)
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reusedIdentifier)
        navigationItem.title = "UIKit Demo"
        navigationItem.backButtonTitle = "UIKit"
    }

    // DataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 300
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView
            .dequeueReusableCell(
                withReuseIdentifier: PhotoCell.reusedIdentifier,
                for: indexPath
            ) as? PhotoCell else { return UICollectionViewCell() }

        cell.loadImage(
            "https://picsum.photos/id/\(indexPath.row)/\(Int(cell.bounds.width*2))/\(Int(cell.bounds.height*2))",
            asyncDataLoader: asyncDataLoader
        )

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoViewController = PhotoViewController(
            asyncDataLoader: asyncDataLoader,
            index: indexPath.row
        )
        navigationController?.pushViewController(photoViewController, animated: true)
    }
}

extension PhotosCollectionViewController {
    static var collectionViewLayout: UICollectionViewCompositionalLayout = {
        let fraction: CGFloat = 1 / 3

        // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(fraction),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)

        // Group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(fraction)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
        return UICollectionViewCompositionalLayout(section: section)
    }()
}
