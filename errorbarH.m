function hh = errorbarH(varargin)
%ERRORBARH Horizontal error bar plot.
% Andrea Insabato 2016
% This function works like the usual errorbar() function (of which it is a
% modified copy).
% However for a fast implementation I used the old v6 matlab implementation
% which was more readable. As a consequence changing the axes (ex.
% errorbar(h, x, y, bar)) may not work.
% For the future: use the new matlab implementation.

% Parse possible Axes input
cax = gca;
args = varargin;
nargs = length(args);
error(nargchk(2,6,nargs,'struct'));

x = args{1};
y = args{2};
if nargs > 2, l = args{3}; end
if nargs > 3, u = args{4}; end
if nargs > 4, symbol = args{5}; end

if min(size(x))==1,
    npt = length(x);
    x = x(:);
    y = y(:);
    if nargs > 2,
        if ~ischar(l)
            l = l(:);
        end
        if nargs > 3
            if ~ischar(u)
                u = u(:);
            end
        end
    end
else
    npt = size(x,1);
end

if nargs == 3
    if ~ischar(l)
        u = l;
        symbol = '-';
    else
        symbol = l;
        l = y;
        u = y;
        y = x;
        n = size(y,2);
        x(:) = (1:npt)'*ones(1,n);
    end
end

if nargs == 4
    if ischar(u),
        symbol = u;
        u = l;
    else
        symbol = '-';
    end
end


if nargs == 2
    l = y;
    u = y;
    y = x;
    n = size(y,2);
    x(:) = (1:npt)'*ones(1,n);
    symbol = '-';
end

u = abs(u);
l = abs(l);

if ischar(x) || ischar(y) || ischar(u) || ischar(l)
    error(message('MATLAB:errorbar:NumericInputs'))
end

if ~isequal(size(x),size(y)) || ~isequal(size(x),size(l)) || ~isequal(size(x),size(u)),
    error(message('MATLAB:errorbar:InputSizeMismatch'));
end

tee = (max(x(:))-min(x(:)))/100;  % make tee .02 x-distance for error bars
xl = x - u;
xr = x + l;
ytop = y + tee;
ybot = y - tee;
n = size(y,2);

% Plot graph and bars
cax = newplot(cax);
hold_state = ishold(cax);

% build up nan-separated vector for bars
xb = zeros(npt*9,n);
xb(1:9:end,:) = xl;
xb(2:9:end,:) = xl;
xb(3:9:end,:) = NaN;
xb(4:9:end,:) = xl;
xb(5:9:end,:) = xr;
xb(6:9:end,:) = NaN;
xb(7:9:end,:) = xr;
xb(8:9:end,:) = xr;
xb(9:9:end,:) = NaN;

yb = zeros(npt*9,n);
yb(1:9:end,:) = ytop;
yb(2:9:end,:) = ybot;
yb(3:9:end,:) = NaN;
yb(4:9:end,:) = y;
yb(5:9:end,:) = y;
yb(6:9:end,:) = NaN;
yb(7:9:end,:) = ytop;
yb(8:9:end,:) = ybot;
yb(9:9:end,:) = NaN;

[ls,col,mark,msg] = colstyle(symbol);
if ~isempty(msg), error(msg); end
symbol = [ls mark col]; % Use marker only on data part
esymbol = ['-' col]; % Make sure bars are solid

% ERRORBAR calls the 'v6' version of PLOT, and temporarily modifies global
% state by turning the MATLAB:plot:DeprecatedV6Argument and
% MATLAB:plot:IgnoringV6Argument warnings off and on again.
oldWarn(1) = warning('off','MATLAB:plot:DeprecatedV6Argument');
oldWarn(2) = warning('off','MATLAB:plot:IgnoringV6Argument');
try
    h = plot('v6',xb,yb,esymbol,'parent',cax); hold(cax,'on')
    h = [h;plot('v6',x,y,symbol,'parent',cax)];
catch err
    warning(oldWarn); %#ok<WNTAG>
    rethrow(err);
end
warning(oldWarn); %#ok<WNTAG>

if ~hold_state, hold(cax,'off'); end

function [pvpairs,args,nargs,msg] = parseargs(args)
% separate pv-pairs from opening arguments
[args,pvpairs] = parseparams(args);
% check for LINESPEC
if ~isempty(pvpairs)
    [l,c,m,tmsg]=colstyle(pvpairs{1},'plot');
    if isempty(tmsg)
        pvpairs = pvpairs(2:end);
        if ~isempty(l)
            pvpairs = {'LineStyle',l,pvpairs{:}};
        end
        if ~isempty(c)
            pvpairs = {'Color',c,pvpairs{:}};
        end
        if ~isempty(m)
            pvpairs = {'Marker',m,pvpairs{:}};
        end
    end
end
msg = checkpvpairs(pvpairs);
nargs = length(args);


