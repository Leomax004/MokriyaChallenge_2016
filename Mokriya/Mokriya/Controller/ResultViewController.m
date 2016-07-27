

#import "ResultViewController.h"
#import <QuartzCore/QuartzCore.h>
 #import "BattlePageViewController.h"

#define K 32

@interface ResultViewController ()
{
    int i;
}
@property(nonatomic,strong)NSString *player1Rating;
@property(nonatomic,strong)NSString *player2Rating;
@property(nonatomic,strong)NSString *status;
@property(nonatomic,retain)NSMutableArray *array;
@end

@implementation ResultViewController
@synthesize resultPieChart=_resultPieChart;
@synthesize slices = _slices;
@synthesize sliceColors = _sliceColors;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]]];
    self.player1Rating = [NSString stringWithFormat:@"%@",[self.idArray objectAtIndex:0]];
    
    self.player2Rating = [NSString stringWithFormat:@"%@",[self.idArray objectAtIndex:1]];
    
    self.status = [[NSString alloc]init];
    self.array = [[NSMutableArray alloc]init];
    
     i = rand()%10+1;
   
    
    if(i==2 || i==4 ||i==6||i==8)
    {
        //player1 win
        self.status = @"player1";
        [self getPlayerRating:self.player1Rating rating:self.player2Rating];
        
        
    }
    else if(i==1 || i==3 ||i==5||i==7)
    {
        //player2 win
        self.status = @"player2";
        [self getPlayerRating:self.player1Rating rating:self.player2Rating];
        
    }
    else
    {
        //match draw
        self.status = @"draw";
        [self getPlayerRating:self.player1Rating rating:self.player2Rating];
        
        
    }
    
    self.slices = [NSMutableArray arrayWithCapacity:10];
    

    [self.resultPieChart setDataSource:self];
    [self.resultPieChart setStartPieAngle:M_PI_2];
    [self.resultPieChart setAnimationSpeed:1.0];
    [self.resultPieChart setLabelFont:[UIFont fontWithName:@"DBLCDTempBlack" size:24]];
    [self.resultPieChart setLabelRadius:80];
    [self.resultPieChart setShowPercentage:NO];
    
    
    [self.resultPieChart setPieRadius:150];
  
    
    CGFloat xcenter = self.resultPieChart.frame.size.width/2;
    
    CGFloat ycenter = self.resultPieChart.frame.size.height/2;
    
    [self.resultPieChart setPieCenter:CGPointMake(xcenter, ycenter)];
    
    [self.resultPieChart setUserInteractionEnabled:NO];
   
    [self.resultPieChart setLabelShadowColor:[UIColor blackColor]];
    
    self.sliceColors =[NSArray arrayWithObjects:
                       [UIColor yellowColor],
                       [UIColor blueColor],
                       [UIColor orangeColor],
                       [UIColor greenColor],
                       nil];
    

     self.downArrow.transform = CGAffineTransformMakeRotation(M_PI);
}


-(void)getPlayerRating:(NSString *)player1 rating:(NSString *)player2
{
    NSInteger intPlayer1 = [player1 intValue];
    
    NSInteger intPlayer2 = [player2 intValue];
    
    NSInteger R1 = 10*intPlayer1/400;
    
    NSInteger R2 = 10*intPlayer2/400;
    
    NSInteger E1 = R1 / (R1 + R2);
    
    NSInteger E2 = R2 / (R1 + R2);
    
   
    
    if([self.status isEqualToString:@"player1"])
    {
        NSInteger changedPlayer1Rating = R1 + K *(1 - E1);
        
        NSInteger changedPlayer2Rating = R2 + K *(0 - E2);
        
        [self drawChart:intPlayer1 player2:intPlayer2 current:changedPlayer1Rating player2:changedPlayer2Rating];
        
    }
    else if([self.status isEqualToString:@"player2"])
    {
        NSInteger changedPlayer1Rating = R1 + K *(0 - E1);
        
        NSInteger changedPlayer2Rating = R2 + K *(1 - E2);
        
        [self drawChart:intPlayer1 player2:intPlayer2 current:changedPlayer1Rating player2:changedPlayer2Rating];
        
    }
    else
    {
        NSInteger changedPlayer1Rating = R1 + K *(0.5 - E1);
        
        NSInteger changedPlayer2Rating = R2 + K *(0.5 - E2);
        
        [self drawChart:intPlayer1 player2:intPlayer2 current:changedPlayer1Rating player2:changedPlayer2Rating];
        
    }
    
    
}


-(void)drawChart:(NSInteger)previousplayer1 player2:(NSInteger)previousplayer2 current:(NSInteger)player1Rating player2:(NSInteger)player2Rating
{
   
    NSString *string1 = [NSString stringWithFormat:@"%ld",previousplayer1];
    NSString *string2 = [NSString stringWithFormat:@"%ld",previousplayer2];
    NSString *string3 = [NSString stringWithFormat:@"%ld",player1Rating];
    NSString *string4 = [NSString stringWithFormat:@"%ld",player2Rating];
    
    [self.array addObject:string1];
    [self.array addObject:string2];
    [self.array addObject:string3];
    [self.array addObject:string4];
    
    //Rating Points of player 1 prior to match.
    //Rating Points of player 1 after to match.
    //Rating Points lost by player 1 after to match
    //Rating Points won by player 1 after to match
    

    
    if([self.status isEqualToString:@"player1"])
    {
        self.intialRatingPlayer1.text = @"Rating Points of player 1 prior to match";
        self.initialRatingPlayer2.text = @"Rating Points of player 2 prior to match";
        self.afterPlayer1.text = @"Rating Points won by player 1 after match";
        self.afterPlayer2.text = @"Rating Points lost by player 2 after match";
    }
    else if([self.status isEqualToString:@"player2"])
    {
        self.intialRatingPlayer1.text = @"Rating Points of player 1 prior to match";
        self.initialRatingPlayer2.text = @"Rating Points of player 2 prior to match";
        self.afterPlayer1.text = @"Rating Points won by player 2 after match";
        self.afterPlayer2.text = @"Rating Points lost by player 1 after match";
    }
    else
    {
        self.intialRatingPlayer1.text = @"Rating Points of player 1 prior to match";
        self.initialRatingPlayer2.text = @"Rating Points of player 2 prior to match";
        self.afterPlayer1.text = @"Rating Points of player 1 after match draw";
        self.afterPlayer2.text = @"Rating Points of player 2 after match draw";
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setPieChartLeft:nil];
  //  [self setPieChartRight:nil];
    [self setPercentageLabel:nil];
    [self setSelectedSliceLabel:nil];
    [self setIndexOfSlices:nil];
    [self setNumOfSlices:nil];
    [self setDownArrow:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    i = rand()%10+1;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.resultPieChart reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return [self.array count];
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [[self.array objectAtIndex:index] intValue];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    return [self.sliceColors objectAtIndex:(index % self.sliceColors.count)];
}

#pragma mark - XYPieChart Delegate
- (void)pieChart:(XYPieChart *)pieChart willSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"will select slice at index %lu",(unsigned long)index);
}
- (void)pieChart:(XYPieChart *)pieChart willDeselectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"will deselect slice at index %lu",(unsigned long)index);
}
- (void)pieChart:(XYPieChart *)pieChart didDeselectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did deselect slice at index %lu",(unsigned long)index);
}
- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did select slice at index %lu",(unsigned long)index);
    self.selectedSliceLabel.text = [NSString stringWithFormat:@"$%@",[self.slices objectAtIndex:index]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backButton:(id)sender {
    
    BattlePageViewController *battleView = [[BattlePageViewController alloc]init];
    
    [self presentViewController:battleView animated:YES completion:nil];
  
}
@end
