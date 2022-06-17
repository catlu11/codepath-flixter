//
//  GridViewController.m
//  Flixter
//
//  Created by Catherine Lu on 6/16/22.
//

#import "GridViewController.h"
#import "MovieCollectionCell.h"
#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface GridViewController () <UICollectionViewDataSource, UISearchBarDelegate>
    @property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
    @property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
    @property (strong, nonatomic) NSArray *posterData;
    @property (strong, nonatomic) NSArray *filteredPosterData;
@end

@implementation GridViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.collectionView.dataSource = self;
    self.searchBar.delegate = self;
    
    // API call
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=99c35d01f55c02ab3de5e8b1c7d5b6c8"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
       if (error != nil) {
           NSLog(@"%@", [error localizedDescription]);
       }
       else {
           NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

           NSArray *movieArray = dataDictionary[@"results"];
           self.posterData = movieArray;
           self.filteredPosterData = self.posterData;
           
           [self.collectionView reloadData];
       }
   }];
    [task resume];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSDictionary *dataToPass = self.filteredPosterData[self.collectionView.indexPathsForSelectedItems[0].item];
    DetailsViewController *detailVC = [segue destinationViewController];
    detailVC.detailsDict = dataToPass;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MovieCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionCell" forIndexPath:indexPath];
    
    NSString *baseSmallURL = @"https://image.tmdb.org/t/p/w45";
    NSString *baseBigURL = @"https://image.tmdb.org/t/p/original";
    NSString *posterURL = self.filteredPosterData[indexPath.row][@"poster_path"];
    NSString *smallURL = [baseSmallURL stringByAppendingString:posterURL];
    NSString *bigURL = [baseBigURL stringByAppendingString:posterURL];
    NSURL *imageSmallURL = [NSURL URLWithString:smallURL];
    NSURL *imageBigURL = [NSURL URLWithString:bigURL];
    
    NSURLRequest *requestSmall = [NSURLRequest requestWithURL:imageSmallURL];
    NSURLRequest *requestBig = [NSURLRequest requestWithURL:imageBigURL];

    [cell.movieImageView setImageWithURLRequest:requestSmall placeholderImage:nil success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *smallImage) {
         if (imageResponse) {
             cell.movieImageView.alpha = 0.0;
             cell.movieImageView.image = smallImage;
             
             [UIView animateWithDuration:0.3 animations:^{
                 cell.movieImageView.alpha = 1.0;
             } completion:^(BOOL finished) {
                 // The AFNetworking ImageView Category only allows one request to be sent at a time
                 // per ImageView. This code must be in the completion block.
                 [cell.movieImageView setImageWithURLRequest:requestBig placeholderImage:smallImage
                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage * largeImage) {
                             cell.movieImageView.image = largeImage;
                        }
                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                            NSLog(@"Failed to retrieve larger image.");
                        }];
            }];
         }
         else {
             cell.movieImageView.image = smallImage;
         }
     }
     failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
        NSLog(@"Failed to retrieve image.");
     }];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.filteredPosterData.count;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    self.filteredPosterData = self.posterData;
    [self.collectionView reloadData];
    [self.searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary *bindings) {
            NSString *title = evaluatedObject[@"original_title"];
            return [title rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound;
        }];
        self.filteredPosterData = [self.posterData filteredArrayUsingPredicate:predicate];
    }
    else {
        self.filteredPosterData = self.posterData;
    }
    [self.collectionView reloadData];
}

@end
