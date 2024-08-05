//
//  SecondViewController.swift
//  iconfinder
//
//  Created by Vermut xxx on 05.08.2024.
//

import UIKit

final class SecondViewController: UIViewController, SecondViewProtocol {
    
    var presenter: SecondPresenterProtocol!
    private lazy var customView = self.view as? SecondView
    
    override func loadView() {
        let customView = SecondView(frame: .zero)
        customView.tableViewDelegate = self
        customView.tableViewDataSource = self
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.loadData()
        let tableView = customView?.tableView
        tableView?.register(ImageTableViewCell.self, forCellReuseIdentifier: ImageTableViewCell.reuseID)
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.loadData()
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showSuccess(message: String) {
        let alert = UIAlertController(title: "Успех", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func reloadData() {
        customView?.reloadData()
    }
    private func configureCell(_ cell: ImageTableViewCell, with icon: IconModel, isSaved: Bool) {
        cell.configure(icon: icon, isSaved: true)
        if let rasterSize = icon.raster_sizes.last {
            cell.sizeLabel.text = "\(rasterSize.size_width)x\(rasterSize.size_height)"
            cell.tagsLabel.text = "Tags: \(icon.tags.prefix(10).joined(separator: ", "))"
        } else {
            cell.sizeLabel.text = "No format available"
            cell.tagsLabel.text = "No tags available"
        }
    }
}

// MARK: - UITableViewDataSource

extension SecondViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ImageTableViewCell.reuseID, for: indexPath) as? ImageTableViewCell,
              let model = presenter.itemFor(index: indexPath.row) else {
            return UITableViewCell()
        }
        
        configureCell(cell, with: model, isSaved: presenter.isIconSaved(id: model.icon_id))
        cell.tapButton = { [weak self] id in
            self?.presenter.deleteIcon(with: id)
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SecondViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
