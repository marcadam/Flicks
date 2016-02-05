# Flicks Notes

### Basic App Structure

Tab -> Nav -> (Table || Collection) -> Detail


### Models
Movie - make this an optional array in the VC, i.e., [Movies]?

### Views
- Add 'Views' group to file navigator.

### Tables
- prepareForReuse ??

### Misc
- Use standard TableView with associated VC instead of the pre-packaged TableViewController. This allows us to easily toggle between table and collection views. Just load both and toggle which is hidden.
- May need to clean and build to get Xcode to recognize new pod files.

### Extras
- [ ] adding a placeholder image with this method of AFNetworking:

    cell.posterImageView.setImageWithURL(url: NSURL, placeholderImage: UIImage?)

- [x] Make long movie titles wrap in detail view

### Done
- Decreased NSURLSession request timeout to 10 seconds for demo purpose

Poster image sizes:
    - 92 x 138, 92 x 131, 92 x 140, 92 x 138 [53 x 80]
    - 342 x 513
    - 500 x 750
    - 780 x 1170

