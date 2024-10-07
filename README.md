# philips-gradunwarp-matlab

Matlab implementation of Philips gradient nonlinearity correction

Angus Lau (angus.lau@sri.utoronto.ca)

Please let me know if you see any bugs, thanks!

## install

### Dependencies:
* FSL (for applywarp): https://fsl.fmrib.ox.ac.uk/fsl/fslwiki
* matlab nii reader: https://github.com/xiangruili/dicm2nii

### matlab
* add `src` to path

## usage

```matlab

addpath(genpath('/tank/tkn219/projects/dicm2nii/'))
addpath(genpath('/tank/tkn219/projects/philips-gradunwarp-matlab/src'))
addpath(genpath('/tank/shared/software/freesurfer'))

bids_dir = '/tank/shared/2024/visual/AOT/bids/aotfull_final/'
op_dir = '/tank/shared/2024/visual/AOT/derivatives/aot_prep/grad_nlin'


for i = 1:4
    sub = sprintf('sub-%03d', i);
    for j = 1:11
        ses = sprintf('ses-%02d', j);
        run_str = 'run-01';
        filename_distorted = fullfile(bids_dir, sub, ses, 'func', [sub, '_', ses, '_task-AOT_rec-nordic_', run_str, '_part-mag_bold.nii.gz']);

        op_dir_ses = fullfile(op_dir, sub, ses, 'func')
        mkdir(op_dir_ses);
        try
            nii_unwarped = gradient_unwarp(filename_distorted, 'SPINOZA_7T', false, op_dir_ses);
        end
    end
    ses = 'ses-pRF';
    run_str = 'run-01';
    filename_distorted = fullfile(bids_dir, sub, ses, 'func', [sub, '_', ses, '_task-pRF_rec-nordic_', run_str, '_part-mag_bold.nii.gz']);

    op_dir_ses = fullfile(op_dir, sub, ses, 'func')
    mkdir(op_dir_ses);
    try
        nii_unwarped = gradient_unwarp(filename_distorted, 'SPINOZA_7T', false, op_dir_ses);
    end
end

```

after this, one would convert the FSL warpfield to an ITK displacement field to be used in ANTS:

 ```bash
wb_command -convert-warpfield -from-fnirt sub-001_ses-01_task-AOT_rec-nordic_run-01_part-mag_bold_warp.nii.gz sub-001_ses-01_task-AOT_rec-nordic_run-01_part-mag_bold.nii.gz -to-itk sub-001_ses-01_task-AOT_rec-nordic_run-01_part-mag_bold_warp-itk.nii.gz
 ```

and, perhaps, apply it:

 ```bash
antsApplyTransforms -d 4 -n LanczosWindowedSinc -i sub-001_ses-01_task-AOT_rec-nordic_run-01_part-mag_bold.nii.gz -t sub-001_ses-01_task-AOT_rec-nordic_run-01_part-mag_bold_warp-itk.nii.gz -r sub-001_ses-01_task-AOT_rec-nordic_run-01_part-mag_bold.nii.gz -o sub-001_ses-01_task-AOT_rec-nordic_run-01_part-mag_bold_itk-unwarped.nii.gz
 ```


## Notes:

The gradient spherical harmonic coefficients are taken from the Philips file `methpdf/src/mpghw_gr.res`. An example is shown for the MR-Linac gradient called `GCT_WA_MRL`. For a different scanner, find the appropriate gradient set and update the parameters in `src/config/gradient_config.m`. Alternatively, the coefficients can be extracted from the header of the raw data file.
