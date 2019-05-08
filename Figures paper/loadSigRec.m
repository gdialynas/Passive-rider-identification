function x = loadSigRec(filename,header)
% filename = 'SigRec_Default_(2012-11-23)_[18-50-39] IGBTs OFF (fs=2kHz)';
% filename = 'FAT_AccTest_eMove6_640_1800_PB'


% input/output checks
if (nargin<=1); error('wrong nr of input arguments'); end
if (nargin>2); error('wrong nr of input arguments'); end

% open file and read all data
[fid, message] = fopen([char(filename),'.dat'], 'r', 'ieee-le');
x = fread(fid, [header.ColumnCount,inf], 'float32')';

header.SampleCount = length(x);
