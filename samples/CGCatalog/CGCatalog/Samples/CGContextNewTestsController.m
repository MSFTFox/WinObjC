//******************************************************************************
//
// Copyright (c) 2016 Microsoft Corporation. All rights reserved.
//
// This code is licensed under the MIT License (MIT).
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
//******************************************************************************

#import "CGContextNewTestsController.h"

#import "CGContextSampleRow.h"
#import "CGPathAddCurveToPointView.h"
#import "CGPathAddElipseView.h"
#import "CGPathAddLineToPointView.h"
#import "CGPathAddPathView.h"
#import "CGPathAddQuadCurveToPointView.h"
#import "CGPathAddRectView.h"
#import "CGPathApplyView.h"
#import "CGPathCloseSubpathView.h"
#import "CGPathContainsPointView.h"
#import "CGPathGetBoundingBoxView.h"

@interface CGContextNewTestsController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray<CGContextSampleRow*>* samples;
@property (retain) UITextField* redColor;
@property (retain) UITextField* greenColor;
@property (retain) UITextField* blueColor;
@property (retain) UITextField* alphaColor;

@property (assign) CGColorRef lineColor;
@property (assign) CGFloat lineWidth;

@end

@implementation CGContextNewTestsController

- (NSArray*)samples {
    if (!_samples) {
        _samples = @[
            [CGContextSampleRow row:@"CGPathAddCurveToPoint" class:[CGPathAddCurveToPointView class]],
            [CGContextSampleRow row:@"CGPathAddEllipse" class:[CGPathAddElipseView class]],
            [CGContextSampleRow row:@"CGPathAddLineToPoint" class:[CGPathAddLineToPointView class]],
            [CGContextSampleRow row:@"CGPathAddPath" class:[CGPathAddPathView class]],
            [CGContextSampleRow row:@"CGPathAddQuadCurveToPoint" class:[CGPathAddQuadCurveToPointView class]],
            [CGContextSampleRow row:@"CGPathAddRect" class:[CGPathAddRectView class]],
            [CGContextSampleRow row:@"CGPathApply" class:[CGPathApplyView class]],
            [CGContextSampleRow row:@"CGPathCloseSubpath" class:[CGPathCloseSubpathView class]],
            [CGContextSampleRow row:@"CGPathContainsPoint" class:[CGPathContainsPointView class]],
            [CGContextSampleRow row:@"CGPathGetBoundingBox" class:[CGPathGetBoundingBoxView class]],
        ];
    }
    return _samples;
}

- (NSString*)title {
    return @"New Samples";
}

- (void)createLineWidthFromText:(UITextField*)sender {
    NSCharacterSet* notNumericOrDeci = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
    if ([sender.text rangeOfCharacterFromSet:notNumericOrDeci].location == NSNotFound) {
        NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        CGFloat lineValue = [formatter numberFromString:sender.text].floatValue;

        if (lineValue < 0) {
            lineValue = 0;
        }

        self.lineWidth = lineValue;
    }
}

- (void)createNewColorFromTextBoxes {
    NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    CGFloat redValue = [formatter numberFromString:self.redColor.text].floatValue;

    if (redValue < 0 || redValue > 1) {
        return;
    }

    CGFloat greenValue = [formatter numberFromString:self.greenColor.text].floatValue;

    if (greenValue < 0 || greenValue > 1) {
        return;
    }

    CGFloat blueValue = [formatter numberFromString:self.blueColor.text].floatValue;

    if (blueValue < 0 || blueValue > 1) {
        return;
    }

    CGFloat alphaValue = [formatter numberFromString:self.alphaColor.text].floatValue;

    if (alphaValue < 0 || alphaValue > 1) {
        return;
    }

    CGColorRelease(self.lineColor);
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGFloat colorComponents[4];
    colorComponents[0] = redValue;
    colorComponents[1] = greenValue;
    colorComponents[2] = blueValue;
    colorComponents[3] = alphaValue;
    self.lineColor = CGColorCreate(colorspace, colorComponents);
    CGColorSpaceRelease(colorspace);
}

- (void)colorTextBoxCallBack:(UITextField*)sender {
    NSCharacterSet* notNumericOrDeci = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
    if ([sender.text rangeOfCharacterFromSet:notNumericOrDeci].location == NSNotFound) {
        [self createNewColorFromTextBoxes];
    }
}

- (void)loadView {
    [super loadView];
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();

    [self.view setBackgroundColor:[UIColor clearColor]];

    UILabel* lineWidthText = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 100, 40)];
    [lineWidthText setBackgroundColor:[UIColor whiteColor]];
    [lineWidthText setText:@"LineWidth:"];
    [self.view addSubview:lineWidthText];

    UITextField* cgLineWidthInput = [[UITextField alloc] initWithFrame:CGRectMake(82, 60, 50, 40)];
    [cgLineWidthInput setBackgroundColor:[UIColor whiteColor]];
    [cgLineWidthInput setText:@"2.0"];
    [cgLineWidthInput addTarget:self action:@selector(createLineWidthFromText:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:cgLineWidthInput];

    UILabel* lineColorText = [[UILabel alloc] initWithFrame:CGRectMake(122, 60, 100, 40)];
    [lineColorText setBackgroundColor:[UIColor whiteColor]];
    [lineColorText setText:@"R/G/B/A:"];
    [self.view addSubview:lineColorText];

    self.redColor = [[UITextField alloc] initWithFrame:CGRectMake(200, 60, 50, 40)];
    [self.redColor setBackgroundColor:[UIColor whiteColor]];
    [self.redColor setText:@"1.0"];
    [self.redColor addTarget:self action:@selector(colorTextBoxCallBack:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.redColor];

    self.greenColor = [[UITextField alloc] initWithFrame:CGRectMake(230, 60, 50, 40)];
    [self.greenColor setBackgroundColor:[UIColor whiteColor]];
    [self.greenColor setText:@"1.0"];
    [self.greenColor addTarget:self action:@selector(colorTextBoxCallBack:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.greenColor];

    self.blueColor = [[UITextField alloc] initWithFrame:CGRectMake(260, 60, 50, 40)];
    [self.blueColor setBackgroundColor:[UIColor whiteColor]];
    [self.blueColor setText:@"1.0"];
    [self.blueColor addTarget:self action:@selector(colorTextBoxCallBack:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.blueColor];

    self.alphaColor = [[UITextField alloc] initWithFrame:CGRectMake(290, 60, 50, 40)];
    [self.alphaColor setBackgroundColor:[UIColor whiteColor]];
    [self.alphaColor setText:@"1.0"];
    [self.alphaColor addTarget:self action:@selector(colorTextBoxCallBack:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.alphaColor];

    [self createNewColorFromTextBoxes];
    self.lineWidth = 2.0;

    UITableView* tableView = [[UITableView alloc] init];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    CGRect viewBounds = self.view.bounds;

    CGRect newTableBounds = CGRectMake(0, 100, viewBounds.origin.x + viewBounds.size.width, viewBounds.origin.y + viewBounds.size.height);
    [tableView setFrame:newTableBounds];
    [self.view addSubview:tableView];
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    [self.navigationController
        pushViewController:[[self.samples[indexPath.row].class alloc] initWithLineWidth:self.lineWidth LineColor:self.lineColor]
                  animated:YES];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.samples count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    NSString* reuseIdentifier = @"reuseIdentifier";

    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }

    [cell.textLabel setText:self.samples[indexPath.row].name];

    return cell;
}

- (void)dealloc {
    CGColorRelease(self.lineColor);
}

@end
