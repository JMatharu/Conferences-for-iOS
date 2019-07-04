//
//  HomeSectionCell.swift
//  Conferences
//
//  Created by Zagahr on 22/05/2019.
//  Copyright © 2019 Timon Blask. All rights reserved.
//

import UIKit

final class HomeSectionCell: UICollectionViewCell {
    private weak var imageDownloadOperation: Operation?
    class var identifier: String { return "HomeSectionCell" }

    private let imageView = UIImageView()
    private let titleLabel = UILabel(frame:.zero)
    private let subtitleLabel = UILabel(frame:.zero)
    private let stackView = StackView()
    var viewModel: HomeSectionCell.Model?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpTheming()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureView() {
        backgroundColor = .clear

        titleLabel.textAlignment = .left
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.font = UIFont.medium

        subtitleLabel.textColor = UIColor.lightGray
        subtitleLabel.textAlignment = .left
        subtitleLabel.lineBreakMode = .byTruncatingTail
        subtitleLabel.font = UIFont.small

        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "placeholder")
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.95, alpha:1.0)

        stackView.addArrangedSubview(view: titleLabel)
        stackView.addArrangedSubview(view: subtitleLabel)

        contentView.addSubview(imageView)
        contentView.addSubview(stackView)

        contentView.clipsToBounds = true
    }

    func configureConstraints(size: HomeSection.Size) {
        switch size {
        case .s:
            imageView.height(80)
            imageView.width(80)
            imageView.topToSuperview()
            imageView.centerXToSuperview()

            stackView.edgesToSuperview(excluding: [.top], insets: .init(), usingSafeArea: true)
            stackView.topToBottom(of: imageView, offset: 10)
        case .m:
            imageView.edgesToSuperview(excluding: [.bottom], insets: .init(), usingSafeArea: true)
            stackView.edgesToSuperview(excluding: [.top], insets: .init(), usingSafeArea: true)
            stackView.topToBottom(of: imageView, offset: 10)
        case .l:
            imageView.edgesToSuperview()
            stackView.edgesToSuperview(excluding: [.top], insets: .init(), usingSafeArea: true)
            contentView.layer.cornerRadius = 10
         }
    }

    func configure(withViewModel viewModel: Model) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle

        configureView()
        configureConstraints(size: viewModel.size)

        switch viewModel.size {
        case .s:
            titleLabel.textAlignment = .center
            imageView.layer.cornerRadius = 40
            subtitleLabel.textAlignment = .center
        case .m:
            break;
        case .l:
            titleLabel.font = .large
            subtitleLabel.font = .small
            stackView.addBackgroundColor(.black)
            titleLabel.textColor = .white
            subtitleLabel.textColor = .lightGray
        }

        guard let imageUrl = viewModel.imageURL else { return }

        self.imageDownloadOperation?.cancel()
        self.imageDownloadOperation = ImageDownloadCenter.shared.downloadImage(from: imageUrl, thumbnailHeight: 100) { [weak self] url, _, thumb in
            guard thumb != nil else { return }
            self?.imageView.image = thumb
        }
    }

    struct Model {
        fileprivate let title: String?
        fileprivate let subtitle: String?
        fileprivate let size: HomeSection.Size
        fileprivate var imageURL: URL?

        init(item: ListRepresentable, section: HomeSection) {
            self.size = section.size

            if size == .l {
                self.title = section.title
                self.subtitle = section.subtitle
                self.imageURL = URL(string: section.imageUrl ?? "")
            } else {
                self.title = item.title
                self.subtitle = item.subtitle
                self.imageURL = URL(string: item.image ?? "")
            }
        }
    }
}

extension HomeSectionCell: Themed {
    func applyTheme(_ theme: AppTheme) {
        if self.viewModel?.size != .l {
            titleLabel.textColor = theme.textColor
            subtitleLabel.textColor = theme.secondaryTextColor
        } else {
            titleLabel.textColor = .white
            subtitleLabel.textColor = .lightGray
        }

        imageView.layer.borderColor = theme.secondaryBackgroundColor.cgColor
    }
}
