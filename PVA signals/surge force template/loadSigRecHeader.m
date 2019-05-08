function header = loadSigRecHeader(filename)
% filename = 'SigRec_Default_(2012-11-23)_[18-50-39] IGBTs OFF (fs=2kHz)';

[fid, message] = fopen([char(filename),'.header'], 'r');
C = textscan(fid, '%s %s %s %s %s');
fclose(fid);

header.filename =      filename;

header.ColumnCount =   str2num(C{2}{3});
header.Tsample =       str2num(C{2}{2});
header.version =       char(C{4}{1});

for i = 1:header.ColumnCount
    header.labels{i} = char(C{4}{3+i});
%     header.units{i} =  char(C{2}{32 + (i-1)*5});
end
header.labels =        header.labels';
% header.units =         header.units';

if header.version ~= '1.0'
    warning('Signal Recording file version is not 1.0, compatibility issues might occur');
end

clear fid; clear C; clear i;
