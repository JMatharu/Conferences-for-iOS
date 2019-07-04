//
//  TalkViewCell.swift
//  Conferences
//
//  Created by Zagahr on 26/03/2019.
//  Copyright © 2019 Timon Blask. All rights reserved.
//

import UIKit

class TalkViewCell: UITableViewCell {
    private weak var imageDownloadOperation: Operation?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureView()
        setUpTheming()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var colorContainer: UIView = {
        let v = UIView()
        v.width(0.7)

        return v
    }()

    private lazy var thumbnailImageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFit

        return v
    }()

    private lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.font = .medium
        l.lineBreakMode = .byTruncatingTail
        l.numberOfLines = 1

        return l
    }()

    private lazy var subtitleLabel: UILabel = {
        let l = UILabel()
        l.font = .small
        l.lineBreakMode = .byTruncatingTail

        return l
    }()

    private lazy var descriptionLabel: UILabel = {
        let l = UILabel()
        l.font = .small
        l.textColor = .tertiaryText
        l.lineBreakMode = .byTruncatingTail

        return l
    }()

    private lazy var textStackView: UIStackView = {
        let v = UIStackView(arrangedSubviews: [self.titleLabel, self.subtitleLabel, self.descriptionLabel])

        v.axis = .vertical
        v.alignment = .top
        //v.distribution = UIStackView.Distribution.fill
        v.spacing = 1

        return v
    }()

    private func configureView() {
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.clear
        selectedBackgroundView = bgColorView

        contentView.addSubview(colorContainer)
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(textStackView)

        colorContainer.leading(to: contentView, offset: 15)
        colorContainer.topToSuperview()
        colorContainer.bottomToSuperview()

        thumbnailImageView.width(100)
        thumbnailImageView.top(to: contentView, offset: 6)
        thumbnailImageView.bottom(to: contentView, offset: -6)
        thumbnailImageView.leadingToTrailing(of: colorContainer, offset: 10)

        textStackView.top(to: thumbnailImageView)
        textStackView.leadingToTrailing(of: thumbnailImageView, offset: 10)
        textStackView.trailing(to: contentView, offset: -10)
    }

    func configureView(with model: ListRepresentable) {
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
        descriptionLabel.text = model.detail
        colorContainer.backgroundColor = UIColor().hexStringToUIColor(hex: model.color ?? "")
        thumbnailImageView.image = UIImage(named: "placeholder")

        guard let imageUrl = URL(string: model.image ?? "") else { return }

        self.imageDownloadOperation?.cancel()
        self.imageDownloadOperation = ImageDownloadCenter.shared.downloadImage(from: imageUrl, thumbnailHeight: 150) { [weak self] url, _, thumb in
            guard url == imageUrl, thumb != nil else { return }

            self?.thumbnailImageView.image = thumb
        }
    }
}

extension TalkViewCell: Themed {
    func applyTheme(_ theme: AppTheme) {
        titleLabel.textColor = theme.textColor
        subtitleLabel.textColor = theme.secondaryTextColor
        backgroundColor = theme.backgroundColor
        selectedBackgroundView?.backgroundColor = theme.secondaryBackgroundColor
    }
}
