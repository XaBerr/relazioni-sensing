%
% loadOBR.m
%
% This function reads data from an OBR (binary) file and returns:
% z         the longitudinal coordinates [m]
% P         complex signal on "parallel" polarization
% S         complex signal on "orthogonal" polarization
% info      structure comprising the measurement parameters
%
% [z, P, S, info]=loadOBR(filename)
%

function [z, P, S, info]=loadOBR(filename)


% declare a persistent variable to handle a warning politely (see below)
persistent lastWarningDate


%------------
% open file
%------------

fd=fopen(filename, 'r', 'ieee-le');


%-------------
% read infos
%-------------

info=struct('f0', [], 'df', [], 't0', [], 'dt', [], 'group_indx', [], ...
    'gain', [], 'fc_indx', [], 'npts', [], 'type', '', ...
    'meas_date', [], 'cal_date', [], 'device', '', 'file_ver', []);

% file version
info.file_ver=fread(fd, 1, 'float32');

% check point
check=fread(fd, 8, '*char');
if strcmp(check, 'OBR/OFDR')
    error('Apparently the file "%s" is not a valid OBR file.', filename);
end

% frequency, start and increment
info.f0=fread(fd, 1, 'float64');
info.df=fread(fd, 1, 'float64');

% time, start and increment
info.t0=fread(fd, 1, 'float64');
info.dt=fread(fd, 1, 'float64');

% measurement type 
type=fread(fd, 1, 'uint16');
if type==1
    info.type='Reflection';
elseif type==0
    info.type='Transmission';
else
    error('Unknown measurement type %d.', type);
end

% group index
info.group_indx=fread(fd, 1, 'float64');

% gain
info.gain=fread(fd, 1, 'int32');

% front connector index 
info.fc_indx=fread(fd, 1, 'int32');

% data size
datasize=fread(fd, 1, 'uint32');
if datasize~=8
    warning('loadOBR:unexpected', 'Data size is %d, while it was expected to be 8.', datasize)
end

% data points
info.npts=fread(fd, 1, 'uint32')/2;

% measurement date and time stamp
info.meas_date=fread(fd, 8, 'uint16');

% calibration date and time stamp
info.cal_date=fread(fd, 8, 'uint16');



%----------------------------------------------------
%  skipping temperature and strain coefficients !!!
%----------------------------------------------------



%-------------
%  read data
%-------------

% longitudinal coordinates
c=299792458;    % speed of light [m/s]
z=(info.t0 + (0:info.npts-1)*info.dt)*c*1e-9/(2*info.group_indx);

% move file "pointer" the data starting point
fseek(fd, 2048, 'bof');     

% read data
data=fread(fd, [info.npts,4], 'float64');
P=data(:,1) + 1i*data(:,2);
S=data(:,3) + 1i*data(:,4);

% check if we are in long range
if z(end)>600
    % yes, we are loading a long-length file
    % currently, these files have a lot of garbage beyond 500m, let's prune
    % it; let's also warn the user of the pruning, at least once a day
    if now -lastWarningDate > 1
        % at least 1 day is passed since the last warning, 
        % let's remind the problem
        warning('loadOBR:longRange', 'Long-range data beyond 500m has been pruned.');
        lastWarningDate=now;
    end
    
    % let's prune data
    J=find(z<=500);
    z=z(J);
    P=P(J);
    S=S(J);
end



%---------------------
%  reads device name
%---------------------

found=false;
while ~found
    buffer=fread(fd, 10, '*char');
    
    if isempty(buffer)
        % according to the manual, this should not happen; 
        % however, just in case, let's avoid an infinity loop
        found=true;
    else 
        % search the tag '@'
        res=regexp(buffer, '^([^@]+)@', 'tokens');
        if isempty(res)
            info.device=[info.device, buffer];
        else
            info.device=[info.device, res{1}];
            found=true;
        end
    end
end




%--------------
%  close file
%--------------

fclose(fd);
end