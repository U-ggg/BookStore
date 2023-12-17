//
//  AddBookCell.swift
//  BookStore
//
//  Created by sidzhe on 16.12.2023.
//

import UIKit
import Kingfisher

final class AddBookCell: UICollectionViewCell {
    
    //MARK: - Properties
    var addListCallBack: (() -> Void)?
    static let id = "AddBookCellId"
    
    //MARK: - UI Elements
    private let bookImage = UIImageView()
    private let button = UIButton()
    private let genre = UILabel(font: .systemFont(ofSize: 10), textColor: .white)
    private let bookName = UILabel(font: .boldSystemFont(ofSize: 15), textColor: .white)
    private let author = UILabel(font: .boldSystemFont(ofSize: 10), textColor: .white)
    private lazy var stackView = UIStackView(.vertical, 5, .fill, .equalSpacing, [genre, bookName, author])
    
    //MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupConst()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubViews(bookImage, button, stackView)
        
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.circle"), for: .selected)
        button.tintColor = .white
        contentView.backgroundColor = .black
        button.addTarget(self, action: #selector(deleteButtonAction), for: .touchUpInside)
    }
    
    private func setupConst() {
        NSLayoutConstraint.activate([
            
            bookImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            bookImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bookImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bookImage.heightAnchor.constraint(equalToConstant: 142),
            bookImage.widthAnchor.constraint(equalToConstant: 95),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            stackView.leadingAnchor.constraint(equalTo: bookImage.trailingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -43),
            
            button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -9),
            button.heightAnchor.constraint(equalToConstant: 20),
            button.widthAnchor.constraint(equalTo: button.heightAnchor)
        ])
    }
    
    func config(book: Book, state: Bool) {
        self.genre.text = book.iaCollection?.first
        self.bookName.text = book.title
        self.author.text = book.authorName?.first
        self.bookImage.kf.setImage(with: book.urlImage)
        button.isSelected = state 
    }
    
    @objc private func deleteButtonAction(_ sender: UIButton) {
        addListCallBack?()
        sender.isSelected.toggle()
    }
}
