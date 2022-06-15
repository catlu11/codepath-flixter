//
//  MovieViewController.m
//  Flixter
//
//  Created by Catherine Lu on 6/15/22.
//

#import "MovieViewController.h"
#import "CellTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface MovieViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *myArray;

@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 200;
    
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=99c35d01f55c02ab3de5e8b1c7d5b6c8"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

//               NSLog(@"%@", dataDictionary);// log an object with the %@ formatter.
               
               // TODO: Get the array of movies
               NSArray *movieArray = dataDictionary[@"results"];
               
               // TODO: Store the movies in a property to use elsewhere
               self.myArray = movieArray;
//               NSLog(@"%@", self.myArray);// log an object with the %@ formatter.
               
               // TODO: Reload your table view data
               [self.tableView reloadData];
           }
       }];
    [task resume];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell" forIndexPath:indexPath];

    cell.synopsisLabel.text = self.myArray[indexPath.row][@"overview"];
    cell.titleLabel.text = self.myArray[indexPath.row][@"original_title"];
    
    NSString *baseURL = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURL = self.myArray[indexPath.row][@"poster_path"];
    NSString *stringURL = [baseURL stringByAppendingString:posterURL];
    NSURL *imageURL = [NSURL URLWithString:stringURL];
    
    [cell.imageView setImageWithURL:imageURL];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.myArray.count;
}

@end
