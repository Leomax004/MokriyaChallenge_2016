

#import <UIKit/UIKit.h>
#import "XYPieChart.h"

@interface ResultViewController : UIViewController <XYPieChartDelegate, XYPieChartDataSource>
@property (weak, nonatomic) IBOutlet XYPieChart *resultPieChart;
@property (strong, nonatomic) IBOutlet XYPieChart *pieChartLeft;
@property (strong, nonatomic) IBOutlet UILabel *percentageLabel;
@property (strong, nonatomic) IBOutlet UILabel *selectedSliceLabel;
@property (strong, nonatomic) IBOutlet UITextField *numOfSlices;
@property (strong, nonatomic) IBOutlet UISegmentedControl *indexOfSlices;
@property (strong, nonatomic) IBOutlet UIButton *downArrow;
@property(nonatomic, strong) NSMutableArray *slices;
@property(nonatomic, strong) NSArray *sliceColors;


@property (weak, nonatomic) IBOutlet UILabel *intialRatingPlayer1;

@property (weak, nonatomic) IBOutlet UILabel *afterPlayer1;

@property (weak, nonatomic) IBOutlet UILabel *initialRatingPlayer2;

- (IBAction)backButton:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *afterPlayer2;
@property(nonatomic,strong)NSMutableArray *idArray;

@end
