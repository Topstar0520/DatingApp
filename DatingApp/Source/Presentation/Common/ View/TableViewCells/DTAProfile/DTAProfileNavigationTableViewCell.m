//
//  DTAProfileNavigationTableViewCell.m
//  DatingApp
//
//  Created by VLADISLAV KIRIN on 8/11/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import "DTAProfileNavigationTableViewCell.h"

@interface DTAProfileNavigationTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *viewPageControl;
@property (weak, nonatomic) IBOutlet UIButton *buttonNextStep;
@property (weak, nonatomic) IBOutlet UIButton *buttonPreviousStep;

- (IBAction)actionNext:(id)sender;
- (IBAction)actionPrevious:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewPageControlWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintButtonNextStepWidth;

@end

@implementation DTAProfileNavigationTableViewCell

#pragma mark - Life Cycle

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.constraintViewPageControlWidth.constant /= scaleCoefficient;
    self.constraintButtonNextStepWidth.constant /= scaleCoefficient;
   
    [self.buttonNextStep.titleLabel setFont:[UIFont fontWithName:self.buttonNextStep.titleLabel.font.fontName size:self.buttonNextStep.titleLabel.font.pointSize / scaleCoefficient]];
    
    [self.buttonPreviousStep.titleLabel setFont:[UIFont fontWithName:self.buttonPreviousStep.titleLabel.font.fontName size:self.buttonPreviousStep.titleLabel.font.pointSize / scaleCoefficient]];
}

#pragma mark - Public

- (void)hideNextButton {
    self.buttonNextStep.hidden = YES;
}

- (void)configureCell; {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.constraintButtonNextStepWidth.constant *= scaleCoefficient;
    self.constraintViewPageControlWidth.constant *= scaleCoefficient;
    
    [self layoutIfNeeded];
    
    self.buttonNextStep.layer.borderWidth = 1;
    self.buttonNextStep.layer.borderColor = colorTin.CGColor;
    self.buttonNextStep.layer.cornerRadius = self.buttonNextStep.layer.frame.size.height /2;
  
    [self.buttonNextStep.titleLabel setFont:[UIFont fontWithName:self.buttonNextStep.titleLabel.font.fontName size:self.buttonNextStep.titleLabel.font.pointSize * scaleCoefficient]];
    
    self.buttonPreviousStep.layer.borderWidth = 1;
    self.buttonPreviousStep.layer.borderColor = colorTin.CGColor;
    self.buttonPreviousStep.layer.cornerRadius = self.buttonPreviousStep.layer.frame.size.height /2;
    
    [self.buttonPreviousStep.titleLabel setFont:[UIFont fontWithName:self.buttonPreviousStep.titleLabel.font.fontName size:self.buttonPreviousStep.titleLabel.font.pointSize * scaleCoefficient]];
}

#pragma mark - Private

- (IBAction)actionNext:(id)sender {
    if ([self.delegate respondsToSelector:@selector(toNextVC:)]) {
        [self.delegate toNextVC:self];
    }
}

- (IBAction)actionPrevious:(id)sender {
    if ([self.delegate respondsToSelector:@selector(toPreviousVC:)]) {
        [self.delegate toPreviousVC:self];
    }
}

#pragma mark -

@end
