function varargout=errorshade(xx,meanV,stdV,varargin)
% Plot the mean of time series together with some dispersion statistics (std,sem,etc)
%
% [h1 h2]=errorshade(xx,meanV,stdV,col,varargin)
%
% plots meanV as a line of color col 
% against vector xx and stdV as a shaded area of color col.
% Optional arguments can be used to specify line style, transparence of area (faceAlpha), etc.
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
for i=1:length(mean_col)
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
