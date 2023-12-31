//
//  LayoutController.swift
//  CompositionalLayout
//
//  Created by macbook on 04.12.2023.
//


import UIKit

final class HomeViewController: UIViewController {
    
    //MARK: - Properties
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    private let image = UIImage(named: "book")!
    private let searchController = UISearchController(searchResultsController: nil)
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let waitLabel = UILabel(font: .systemFont(ofSize: 30), textColor: .label)
    private var waitLabelcenterYConstraint: NSLayoutConstraint!
    private var animator = UIViewPropertyAnimator()
    var presenter: HomePresenterProtocol!
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        configureActivityIndicator()
        configureCollectionView()
        configureDataSource()
        setupSearchController()
        
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateWithData()
        
    }
    
    //MARK: - SearchBar setup
    private func setupSearchController() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Happy Reading!"
        searchController.automaticallyShowsCancelButton = false
        navigationItem.searchController = searchController
    }
    
    //MARK: - CollectionViewConfig
    private func configureCollectionView() {
        view.backgroundColor = .white
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    //MARK: - ActivityIndicator & WaitLabel
    private func configureActivityIndicator() {
             activityIndicator.translatesAutoresizingMaskIntoConstraints = false
             view.addSubview(activityIndicator)

             NSLayoutConstraint.activate([
                 activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                 activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
             ])
             view.layoutIfNeeded()
             activityIndicator.startAnimating()
             activityIndicator.hidesWhenStopped = true
             activityIndicator.color = .label
         }
    
    //MARK: - Layout
    private func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
            
            let section: NSCollectionLayoutSection
            
            switch sectionKind {
            case .time:
                // Создаем секцию для временных интервалов (This Week, This Month, This Year)
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .absolute(50))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                // Добавляем заголовок к секции
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                header.pinToVisibleBounds = false
                header.zIndex = 2
                
                section.boundarySupplementaryItems = [header]
                return section
                
            case .topBooks:
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(175), heightDimension: .absolute(230))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .estimated(220))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                
                return section
                
            case .recentBooks:
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(175), heightDimension: .absolute(230))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .estimated(220))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                header.pinToVisibleBounds = false
                header.zIndex = 2
                section.boundarySupplementaryItems = [header]
                
                return section
            }
        }
    }
    
    //MARK: - Registration Methods
    private func registerTime() -> UICollectionView.CellRegistration<TimeCell, TimeModel> {
        return UICollectionView.CellRegistration<TimeCell, TimeModel> { (cell, indexPath, timeModel) in
            cell.config(with: timeModel)
        }
    }
    
    private func registerBook() -> UICollectionView.CellRegistration<BookCell, Work> {
        return UICollectionView.CellRegistration<BookCell, Work> { (cell, indexPath, bookModel) in
            cell.config(book: bookModel)
        }
    }
    
    private func registerTopHeader() -> UICollectionView.SupplementaryRegistration<SectionHeader> {
        return UICollectionView.SupplementaryRegistration<SectionHeader>(elementKind: UICollectionView.elementKindSectionHeader) { header, _, indexPath in
            header.titleLabel.text = "Top Books"
            header.isUserInteractionEnabled = true
            header.button.tag = indexPath.section
            header.button.addTarget(self, action: #selector(self.seeMoreTopBooksAction(_:)), for: .touchUpInside)
        }
    }
    
    private func registerRecentHeader() -> UICollectionView.SupplementaryRegistration<SectionHeader> {
        return UICollectionView.SupplementaryRegistration<SectionHeader>(elementKind: UICollectionView.elementKindSectionHeader) { header, _, indexPath in
            header.titleLabel.text = "Recent Books"
            header.isUserInteractionEnabled = true
            header.button.tag = indexPath.section
            header.button.addTarget(self, action: #selector(self.seeMoreTopBooksAction(_:)), for: .touchUpInside)

        }
    }
    //MARK: - Action for See More button
    @objc private func seeMoreTopBooksAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        switch sender.tag {
        case 0: // Для секции Top Books
            if sender.isSelected {
                sender.setTitle("Hide", for: .normal)
                UIView.animate(withDuration: 0.5) {
                    let newLayout = self.createVerticalLayout() // Вертикальный макет для Top Books
                    self.collectionView.setCollectionViewLayout(newLayout, animated: true)
                }
            } else {
                UIView.animate(withDuration: 0.5) {
                    sender.setTitle("See More", for: .normal)
                    let newLayout = self.createLayout() // Обычный макет
                    self.collectionView.setCollectionViewLayout(newLayout, animated: true)
                }
            }
        case 2: // Для секции Recent Books
            if sender.isSelected {
                sender.setTitle("Hide", for: .normal)
                UIView.animate(withDuration: 0.5) {
                    let newLayout = self.createVerticalRecent() // Вертикальный макет для Recent Books
                    self.collectionView.setCollectionViewLayout(newLayout, animated: true)
                }
            } else {
                UIView.animate(withDuration: 0.5) {
                    sender.setTitle("See More", for: .normal)
                    let newLayout = self.createLayout() // Обычный макет
                    self.collectionView.setCollectionViewLayout(newLayout, animated: true)
                }
            }
        default:
            break
        }
    }
    
    //MARK: - DataSource
    private func configureDataSource() {
        // Регистрация для TimeCell
        let timeCellRegistration = registerTime()
        
        // Регистрация для BookCell
        let bookCellRegistration = registerBook()
        
        // Регистрация для Top Books Header
        let topBooksHeader = registerTopHeader()
        
        // Регистрация для Recent Books Header
        let recentBooksHeader = registerRecentHeader()
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            // Определяем тип ячейки на основе секции
            switch Section(rawValue: indexPath.section)! {
            case .time:
                return collectionView.dequeueConfiguredReusableCell(using: timeCellRegistration, for: indexPath, item: item.time!)
            case .topBooks, .recentBooks:
                // Oбе секции используют BookModel
                return collectionView.dequeueConfiguredReusableCell(using: bookCellRegistration, for: indexPath, item: item.work)
            }
        }
        
        // Настройка заголовков секций
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            if kind == UICollectionView.elementKindSectionHeader {
                if let sectionKind = Section(rawValue: indexPath.section) {
                    switch sectionKind {
                    case .time:
                        return collectionView.dequeueConfiguredReusableSupplementary(using: topBooksHeader, for: indexPath)
                    case .topBooks:
                        return nil
                    case .recentBooks:
                        return collectionView.dequeueConfiguredReusableSupplementary(using: recentBooksHeader, for: indexPath)
                    }
                }
            }
            return nil
        }
    }
}


//MARK: - SearchBar Delegate
extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //        presenter.didTextChange(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchText = searchBar.text else { return }
        let vc = Builder.createSearchVC(with: searchText)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}


//MARK: - HomeViewProtocol
extension HomeViewController: HomeViewProtocol {
    func setupLabel() {
        view.addSubViews(waitLabel)
        waitLabel.text = "Ожидайте"
        waitLabelcenterYConstraint = waitLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 30)
        NSLayoutConstraint.activate([
            waitLabelcenterYConstraint,
            waitLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func animatig(_ start: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            start ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
            if start {
                self.downAndUpLabel()
            } else {
                self.animator.stopAnimation(true)
                self.animator.finishAnimation(at: .current)
                self.waitLabel.isHidden = true
            }
        }
    }
    
    //MARK: - LabelAnimation
    private func downAndUpLabel() {
        self.animator = UIViewPropertyAnimator(duration: 2.0, curve: .linear, animations: {
            UIView.animateKeyframes(withDuration: 2.0, delay: 0) {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                    self.waitLabelcenterYConstraint.constant = 70
                    self.view.layoutIfNeeded()
                }
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                    self.waitLabelcenterYConstraint.constant = 30
                    self.view.layoutIfNeeded()
                }
            }
            self.animator.addCompletion { position in
                if position == .end {
                    self.downAndUpLabel()
                }
            }
        })
        self.animator.startAnimation()
    }
    
    func update() {
        updateWithData()
    }
    
    //MARK: - SnapShot
    func updateWithData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        snapshot.appendSections([.time, .topBooks, .recentBooks])
        let timeItems = presenter.times.map { Item(time: $0) }
        guard let topBookItems = presenter.topBooks?.compactMap({ Item(work: $0)}),
              let recentBookItems = CoreDataManager.shared.getBook()?.compactMap({ Item(work: $0)}) else { return }
        snapshot.appendItems(timeItems, toSection: .time)
        snapshot.appendItems(topBookItems, toSection: .topBooks)
        snapshot.appendItems(recentBookItems, toSection: .recentBooks)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

//MARK: - UICollectionView Delegate
extension HomeViewController:  UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            presenter.didSelectItemAt(indexPath)
        } else if indexPath.section == 1 {
            guard let book = presenter.topBooks?[indexPath.row] else { return }
            let productViewController = Builder.createProductVC(book: book)
            navigationController?.pushViewController(productViewController, animated: true)
        } else {
            guard let book = CoreDataManager.shared.getBook()?[indexPath.row] else { return }
            let productViewController = Builder.createProductVC(book: book)
            navigationController?.pushViewController(productViewController, animated: true)
        }
    }
}


//MARK: - Методы для изменения секций
extension HomeViewController {
    //MARK: - Top Books
    private func createVerticalLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
            
            let section: NSCollectionLayoutSection
            
            switch sectionKind {
            case .time:
                // Создаем секцию для временных интервалов (This Week, This Month, This Year)
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .absolute(50))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                
                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                // Добавляем заголовок к секции
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                header.pinToVisibleBounds = false
                header.zIndex = 2
                
                section.boundarySupplementaryItems = [header]
                return section
                
            case .topBooks:
                
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(175), heightDimension: .absolute(230))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5)

                // 2. Создаем две вертикальные группы (колонки)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .estimated(100))
                let group1 = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                let group2 = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

                // 3. Создаем горизонтальную группу, которая содержит две вертикальные группы
                let horizontalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200))
                let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: horizontalGroupSize, subitems: [group1, group2])

                // 4. Создаем секцию с использованием горизонтальной группы
                let section = NSCollectionLayoutSection(group: horizontalGroup)

                return section
                
            case .recentBooks:
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(175), heightDimension: .absolute(230))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .estimated(220))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                
                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                header.pinToVisibleBounds = false
                header.zIndex = 2
                section.boundarySupplementaryItems = [header]
                
                return section
            }
        }
    }
    
    
   //MARK: - Recent Books
    private func createVerticalRecent() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
            
            let section: NSCollectionLayoutSection
            
            switch sectionKind {
            case .time:
                // Создаем секцию для временных интервалов (This Week, This Month, This Year)
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .absolute(50))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                // Добавляем заголовок к секции
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                header.pinToVisibleBounds = false
                header.zIndex = 2
                
                section.boundarySupplementaryItems = [header]
                return section
                
            case .topBooks:
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(175), heightDimension: .absolute(230))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .estimated(220))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                
                return section
                
            case .recentBooks:
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(175), heightDimension: .absolute(230))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5)

                // 2. Создаем две вертикальные группы (колонки)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .estimated(100))
                let group1 = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                let group2 = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

                // 3. Создаем горизонтальную группу, которая содержит две вертикальные группы
                let horizontalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200))
                let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: horizontalGroupSize, subitems: [group1, group2])

                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                header.pinToVisibleBounds = false
                header.zIndex = 2
                // 4. Создаем секцию с использованием горизонтальной группы
                let section = NSCollectionLayoutSection(group: horizontalGroup)
                section.boundarySupplementaryItems = [header]

                return section
            }
        }
    }
}
