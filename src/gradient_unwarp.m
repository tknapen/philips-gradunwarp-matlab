function [out, nii_displacement] = gradient_unwarp(nii_file, config_name, warp_flag, op_dir)
% gradient_unwarp
%
% inputs:
%   nii: nii file
%   config_name: gradient configuration
%   warp_flag: default is false. take unwarped image and return warped version.
%   op_dir: output directory for temporary files
% outputs:
%   out: unwarped image structure
%   nii_displacement: displacement field, in FSL convention

    if nargin < 2 | isempty(config_name)
        config_name = 'GCT_WA_MRL';
    end

    if nargin < 3 | isempty(warp_flag)
        warp_flag = false;
    end

    if nargin < 4 | isempty(op_dir)
        op_dir = tempdir;
    end

    [input_dir,name,ext] = fileparts(nii_file);
    nii = nii_tool('load', nii_file);
    name = name(1:end-4);
    ext = '.nii.gz';

    % our headers do not contain the right srow information
    mri = MRIread(nii_file)
    nii.hdr.srow_x = mri.vox2ras0(1,:);
    nii.hdr.srow_y = mri.vox2ras0(2,:);
    nii.hdr.srow_z = mri.vox2ras0(3,:);

    temp_datadir = op_dir;
    [~,~,~] = mkdir(temp_datadir);

    % temp_infile = fullfile(temp_datadir, strcat(name, ext));
    temp_warpfile = fullfile(temp_datadir, strcat(name, '_warp', ext));
    temp_outfile = fullfile(temp_datadir, strcat(name, '_gnlunwarped', ext));

    % nii_tool('save', nii, temp_infile);

    nii_displacement = calc_unwarp_displacement(nii, config_name);

    if warp_flag
        nii_displacement.img = -nii_displacement.img;
    end

    nii_tool('save', nii_displacement, temp_warpfile)

    % cmd = ['applywarp -i ' nii_file ' -r ' nii_file ' -o ' temp_outfile ' -w ' temp_warpfile ' --interp=spline -v'];
    % system(cmd);

    % out = nii_tool('load', temp_outfile);
    out = nii;

    % NO cleanup
    % rmdir(temp_datadir, 's');

