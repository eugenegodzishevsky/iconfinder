//
//  ImageTableViewCell.swift
//  iconfinder
//
//  Created by Vermut xxx on 05.08.2024.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    static let reuseID = "ImageTableViewCell"
    
    var id: Int?
    var tapButton: ((Int) -> Void)?
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()
    
    lazy var sizeLabel: UILabel = {
        let sizeLabel = UILabel()
        sizeLabel.translatesAutoresizingMaskIntoConstraints = false
        sizeLabel.numberOfLines = 0
        return sizeLabel
    }()
    
    lazy var tagsLabel: UILabel = {
        let tagsLabel = UILabel()
        tagsLabel.translatesAutoresizingMaskIntoConstraints = false
        tagsLabel.numberOfLines = 0
        return tagsLabel
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .red
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var iconID: Int?
    private var isSaved: Bool = false // Track the state of the button
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(iconImageView)
        contentView.addSubview(favoriteButton)
        contentView.addSubview(sizeLabel)
        contentView.addSubview(tagsLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            iconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: 200),
            
            sizeLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 8),
            sizeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            sizeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            tagsLabel.topAnchor.constraint(equalTo: sizeLabel.bottomAnchor, constant: 8),
            tagsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            tagsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            favoriteButton.topAnchor.constraint(equalTo: tagsLabel.bottomAnchor, constant: 8),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            favoriteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            favoriteButton.widthAnchor.constraint(equalToConstant: 44),
            favoriteButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func configure(icon: IconModel, isSaved: Bool) {
        iconID = icon.icon_id
        self.isSaved = isSaved
        
        if let urlString = icon.raster_sizes.last?.formats.last?.preview_url {
            ImageLoaderManager.shared.loadImage(from: urlString) { [weak self] image in
                DispatchQueue.main.async {
                    self?.iconImageView.image = image
                }
            }
        }
        updateFavoriteButton()
    }
    
    @objc private func saveButtonTapped() {
        guard let iconID = iconID else { return }
        isSaved.toggle()
        updateFavoriteButton()
        tapButton?(iconID)
    }
    
    @objc private func imageTapped() {
        guard let image = iconImageView.image else { return }
        if iconID != nil {
            PhotoLibraryManager.shared.writeToPhotoAlbum(image: image)
        }
    }
    
    private func updateFavoriteButton() {
        let imageName = isSaved ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    func getImage() -> UIImage? {
        return iconImageView.image
    }
    
    func setColorButton(isSaved: Bool) {
        self.isSaved = isSaved
        updateFavoriteButton()
    }
}
