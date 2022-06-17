//
//  CellTableViewCell.h
//  Flixter
//
//  Created by Catherine Lu on 6/15/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CellTableViewCell : UITableViewCell
    @property (weak, nonatomic) IBOutlet UIImageView *posterImage;
    @property (weak, nonatomic) IBOutlet UILabel *titleLabel;
    @property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@end

NS_ASSUME_NONNULL_END
