clear all;
OpenBMI % Edit the variable BMI if necessary
global BMI; % check BMI directories

%% DATA LOAD MODULE
BMI.EEG_DIR=['C:\Users\Administrator\Desktop\BCI_Toolbox\git_OpenBMI\DemoData'];
file=fullfile(BMI.EEG_DIR, '\calibration_motorimageryVPkg');
[EEG.data, EEG.marker, EEG.info]=Load_EEG(file,{'device','brainVision';'fs', 100});
[EEG.marker, EEG.markerOrigin]=prep_defineClass(EEG.marker,{'1','left';'2','right';'3','foot';'4','rest'}); 
EEG.marker=prep_selectClass(EEG.marker,{'right', 'left'});


%% CROSS-VALIDATION MODULE
CV.prep={ % commoly applied to training and test data
    'prep_filter', {'frequency', [7 13]} %be applied to all data (before split)
    'prep_segmentation', {'interval', [750 3750]}
    };
CV.train={
    'func_csp', {'nPatterns','3'}
    'func_featureExtraction', {'logvar'}
    'classifier_trainClassifier', {'LDA'}
    };
CV.test={
    'func_projection',{}
    'func_featureExtraction',{'logvar'}
    'classifier_applyClassifier',{}
    };
% CV.perform={
%     'loss=cal_loss(out, label)'
%     }
CV.option={
'KFold','10'
};

[loss]=eval_crossValidation(EEG.data, CV); % input : eeg, or eeg_epo


