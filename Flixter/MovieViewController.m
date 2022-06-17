//
//  MovieViewController.m
//  Flixter
//
//  Created by Catherine Lu on 6/15/22.
//

#import "MovieViewController.h"
#import "CellTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"

@interface MovieViewController () <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *movieListView;
@property (nonatomic, strong) NSArray *movieArray;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIAlertController *alert;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Table setup
    self.movieListView.dataSource = self;
    self.movieListView.rowHeight = 200;
    
    // Refresh setup
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.movieListView insertSubview:self.refreshControl atIndex:0];
    
    // Alert setup
    self.alert = [UIAlertController alertControllerWithTitle:@"Cannot Get Movies"
        message:@"The Internet connection appears to be offline."
        preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* refreshAction = [UIAlertAction actionWithTitle:@"Try again"
        style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * action) {
            [self fetchMovieData];
    }];
    [self.alert addAction:refreshAction];
    
    // API call
    [self fetchMovieData];
}

- (void)fetchMovieData {
    [self.activityIndicator startAnimating];
    
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=99c35d01f55c02ab3de5e8b1c7d5b6c8"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
       if (error != nil) {
           [self presentViewController:self.alert animated:YES completion:nil];
       }
       else {
           NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

           self.movieArray = dataDictionary[@"results"];

           [self.movieListView reloadData];
           
           [self.activityIndicator stopAnimating];
           [self.refreshControl endRefreshing];
       }
   }];
    [task resume];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSDictionary *dataToPass = self.movieArray[self.movieListView.indexPathForSelectedRow.row];
    DetailsViewController *detailVC = [segue destinationViewController];
    detailVC.detailsDict = dataToPass;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell" forIndexPath:indexPath];

    cell.synopsisLabel.text = self.movieArray[indexPath.row][@"overview"];
    cell.titleLabel.text = self.movieArray[indexPath.row][@"original_title"];
    
    NSString *baseSmallURL = @"https://image.tmdb.org/t/p/w45";
    NSString *baseBigURL = @"https://image.tmdb.org/t/p/original";
    NSString *posterURL = self.movieArray[indexPath.row][@"poster_path"];
    NSString *smallURL = [baseSmallURL stringByAppendingString:posterURL];
    NSString *bigURL = [baseBigURL stringByAppendingString:posterURL];
    NSURL *imageSmallURL = [NSURL URLWithString:smallURL];
    NSURL *imageBigURL = [NSURL URLWithString:bigURL];
    
    NSURLRequest *requestSmall = [NSURLRequest requestWithURL:imageSmallURL];
    NSURLRequest *requestBig = [NSURLRequest requestWithURL:imageBigURL];
    [cell.posterImage setImageWithURLRequest:requestSmall placeholderImage:nil success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *smallImage) {
         if (imageResponse) {
             cell.posterImage.alpha = 0.0;
             cell.posterImage.image = smallImage;
             
             [UIView animateWithDuration:0.3 animations:^{
                 cell.posterImage.alpha = 1.0;
             } completion:^(BOOL finished) {
                 [cell.posterImage setImageWithURLRequest:requestBig placeholderImage:smallImage
                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage * largeImage) {
                             cell.posterImage.image = largeImage;
                        }
                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                            NSLog(@"Failed to retrieve larger image.");
                        }];
            }];
         }
         else {
             cell.posterImage.image = smallImage;
         }
     }
     failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
        NSLog(@"Failed to retrieve image.");
     }];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.movieArray.count;
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [self fetchMovieData];
}

@end
