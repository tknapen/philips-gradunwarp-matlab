function config = gradient_config()
% gradient_config dictionary for spherical
% harmonic coefficient expansion of gradient sets

% mapping of variable names:
%          gx_ref_radius == PHW_geom_corr_gx_ref_radius
%          gy_ref_radius == PHW_geom_corr_gy_ref_radius
%          gz_ref_radius == PHW_geom_corr_gz_ref_radius
%          gx_field_c_coeffs == PHW_geom_corr_gx_field_c_coeffs
%          gy_field_s_coeffs == PHW_geom_corr_gy_field_s_coeffs
%          gz_field_c_coeffs == PHW_geom_corr_gz_field_c_coeffs

% The gz coefficients are a vector of length n.
% The gx and gy coefficients are a vector of length n*(n+1)/2.

config = struct();
config.GCT_WA_MRL = gradient_config_GCT_WA_MRL();
config.DEMO = gradient_config_DEMO();
config.SPINOZA_7T = gradient_config_SPINOZA_7T();
