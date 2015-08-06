function varargout=errorshade(xx,meanV,stdV,varargin)
% Plot the mean of a time series together with some dispersion statistics (std,sem,etc)
%
% [h1 h2]=errorshade(xx,meanV,stdV)
%
% plots meanV as a line against vector xx and stdV as a shaded area of the same color.
% If meanV and stdV are matrices, the column of meanV and stdV are plotted
% as separate lines and shades. It returns two column vectors one for each
% line in meanV and one for each shaded area in stdV.
%
% [h1 h2]=errorshade(xx,meanV,stdV,col_mean)
%
% uses the optional argument col to specify the color of the plots (the
% area is still shaded). col can be a usual color string (e.g.
% 'r','b',etc.) or an m by 3 matrix specifying the RGB colors for each of the m
% lines in meanV.
%
% [h1 h2]=errorshade(xx,meanV,stdV,col_mean,col_std,...)
%
% uses the optional argument col_std to specify color of the shaded area
% separately from that of lines.
% Optional arguments can be used to specify line style and other properties
% of the line objects.
% Other properties of the patch objects have to be specified using the
% returned handles and the command set.
%
% Notes on shading:
% The shading is not obtained through transparency of the patch since this
% is not supported by some rendered (painters for example doesn't support it but
% it give a superior quality of graphics for printing) and can give problems
% with some hardware.
% However, if desired, transparency can be used by setting 'facealpha'
% property of each handle in h2 to a value lower than 1.
%
% TODO: put input errors; write a decent help

if nargin<3
    error('errorshade(X,V,C) plots the mean of rows in matrix V as a line of color C against vector X and the standard deviation as a shaded area of color C. If the mean of columns of V is needed use the transpose of V and X. Optional arguments can be used to specify line style, transparence of area etc.')
end


if isnumeric(varargin{1})
    mean_col = varargin{1};
    startVarArgIn = 2;
    if isnumeric(varargin{2})
        std_col = varargin{2};
        startVarArgIn = 3;
    end
else
    startVarArgIn = 1;
    mean_col = [];
end

% if col_mean is an RGB triple replicate it to apply to all lines in meanV
if all(size(mean_col)==[1,3])
    mean_col = repmat(mean_col, size(meanV,2), 1);
end
% if size(size(xx))>2 || size(size(meanV))>2 ||  size(size(stdV))>2
%        error('input vectors must be column or row vectors')
% end

if ~iscolumn(xx) 
	xx=xx';
end
if ~iscolumn(meanV)
	meanV=meanV';
end
if ~iscolumn(stdV)
       stdV = stdV';
end


% x coord for polygon vertices
poly_xx = cat(1,xx,flipud(xx));
% y coord for polygon vertices
poly_std = cat(1,meanV+stdV,flipud(meanV-stdV));

hold on
h_line=plot(xx,meanV,varargin{startVarArgIn:end});
for i=1:size(mean_col,1)
    set(h_line(i), 'color', mean_col(i,:))
end
for i=1:size(poly_std,2)
    line_col = get(h_line(i), 'color');
    patch_col = line_col + .6;
    patch_col(patch_col>1) = 1;
    if isnumeric(varargin{2}) && isnumeric(varargin{1})
        patch_col = std_col(i,:);
    end
    h_patch(i,1)=patch('xdata', poly_xx, 'ydata',poly_std(:,i));
    set(h_patch(i), 'edgecolor','none','facecolor', patch_col)
end
ax_child = get(gca, 'children');
set(gca, 'children', ax_child(end:-1:1))


switch nargout
    case 1
        varargout{1} = h_line;
    case 2
        varargout{1} = h_line;
        varargout{2} = h_patch;
end


end
