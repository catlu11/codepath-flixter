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

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *myArray;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Table setup
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 200;
    
    // Refresh setup
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
    
    // Activity indicator setup
    [self.activityIndicator startAnimating];
    
    // Alert setup
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Cannot Get Movies"
        message:@"The Internet connection appears to be offline."
        preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* refreshAction = [UIAlertAction actionWithTitle:@"Try again"
        style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * action) {
        [self viewDidLoad];
    }];

    [alert addAction:refreshAction];
    
    // API call
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=99c35d01f55c02ab3de5e8b1c7d5b6c8"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
       if (error != nil) {
           NSLog(@"%@", [error localizedDescription]);
           [self presentViewController:alert animated:YES completion:nil];
       }
       else {
           NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

           NSArray *movieArray = dataDictionary[@"results"];
           self.myArray = movieArray;
           [self.tableView reloadData];
           [self.activityIndicator stopAnimating];
       }
   }];
    [task resume];

}

- (void)fetchMovieData {
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSDictionary *dataToPass = self.myArray[self.tableView.indexPathForSelectedRow.row];
    DetailsViewController *detailVC = [segue destinationViewController];
    detailVC.detailsDict = dataToPass;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell" forIndexPath:indexPath];

    cell.synopsisLabel.text = self.myArray[indexPath.row][@"overview"];
    cell.titleLabel.text = self.myArray[indexPath.row][@"original_title"];
    
    NSString *baseURL = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURL = self.myArray[indexPath.row][@"poster_path"];
    NSString *stringURL = [baseURL stringByAppendingString:posterURL];
    NSURL *imageURL = [NSURL URLWithString:stringURL];
    
    [cell.posterImage setImageWithURL:imageURL];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.myArray.count;
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    // Create NSURL and NSURLRequest
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=99c35d01f55c02ab3de5e8b1c7d5b6c8"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];

    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                          delegate:nil
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    session.configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
   
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
       if (error != nil) {
           NSLog(@"%@", [error localizedDescription]);
       }
       else {
           NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
           NSArray *movieArray = dataDictionary[@"results"];
           self.myArray = movieArray;
       }

       // Reload the tableView now that there is new data
        [self.tableView reloadData];

       // Tell the refreshControl to stop spinning
        [refreshControl endRefreshing];

    }];

    [task resume];
}

@end
