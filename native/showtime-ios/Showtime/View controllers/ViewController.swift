/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit

let reuseId = "MovieCell"

class ViewController: UIViewController {
  
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textField: UITextField!

    @IBAction func pressedSearch() {
        textField.resignFirstResponder()
        search()
    }
    
    @IBAction func sortByTitle() {
        sortByPredicate("title")
    }
    
    @IBAction func sortByPrice() {
        sortByPredicate("price")
    }
    
    let movieService = MovieService()
  
    func search() {
        guard let priceText = textField.text, price = Double(priceText) else { return }
        
        movieService.loadMoviesWithLimit(price) { [weak self] movies in
            self?.movies = movies
        }

    }
    
    func sortByPredicate(predicate: String) {
        guard let priceText = textField.text, price = Double(priceText) else { return }

        movieService.loadMoviesWithLimit(price, sortOrder: predicate) { [weak self] movies in
            self?.movies = movies
        }
    }
    
    var movies: [Movie]? {
        didSet {
          NSOperationQueue.mainQueue().addOperationWithBlock {
            self.collectionView.reloadData()
          }
        }
    }
}

extension ViewController: UICollectionViewDataSource {
  
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return movies?.count ?? 0
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

    guard let
      currentMovie = movies?[indexPath.row],
      cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseId, forIndexPath: indexPath) as? MovieCell else {
        return UICollectionViewCell()
    }

    cell.movieCellData = MovieCellData(movieTitle: currentMovie.title, moviePrice: currentMovie.price, movieImageUrl: currentMovie.imageUrl)

    return cell
    }
}

extension ViewController: UITextFieldDelegate {
  
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
        search()
    }
}