

#import <UIKit/UIKit.h>

@interface BattlePageViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *userListTableView;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
- (IBAction)playButton:(id)sender;

@end
