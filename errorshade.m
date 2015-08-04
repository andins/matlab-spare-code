function [h1 h2]=errorshade(xx,meanV,stdV,col,varargin)
% Plot the mean of time series together with some dispersion statistics (std,sem,etc)
%
% [h1 h2]=errorshade(xx,meanV,stdV,col,varargin)
%
% plots meanV as a line of color col 
% against vector xx and stdV as a shaded area of color col.
% Optional arguments can be used to specify line style, transparence of area (faceAlpha), etc.
%
% TODO: make it work with matrix input (implement it a subclass of plot and
% patch)
if nargin<4
    error('errorshade(X,V,C) plots the mean of rows in matrix V as a line of color C against vector X and the standard deviation as a shaded area of color C. If the mean of columns of V is needed use the transpose of V and X. Optional arguments can be used to specify line style, transparence of area etc.')
end

if size(size(xx))>2 || size(size(meanV))>2 ||  size(size(stdV))>2
       error('input vectors must be column or row vectors')
end

if ~isrow(xx) 
	xx=xx';
end
if ~isrow(meanV)
	meanV=meanV';
end
if ~isrow(stdV)
       stdV = stdV';
end

if isscalar(col)
    colMean = col;
    colStd = col;
elseif ( all(size(col)==[1,2]) || all(size(col)==[2,1]) ) && ischar(col)
    colMean = col(1);
    colStd = col(2);
elseif all(size(col)==[1,3]) && isnumeric(col)
    colMean = col;
    colStd = col;
elseif all(size(col)==[2,3])
    colMean = col(1,:);
    colStd = col(2,:);
else
    error('col must be a character, a 1-2 string, a 1-3 RGB vector or a 2-3 RGB matrix specifing color for line and shading separately!')
end

alfa=.5;

for i=1:nargin-5
    if strcmp(varargin{i},'facealpha')
       alfa = varargin{i+1};
       varargin{i}=[];
       varargin{i+1}=[];
    end
end

% x coord for polygon vertices
poly_xx = cat(2,xx,fliplr(xx));
% y coord for polygon vertices
poly_std = cat(2,meanV+stdV,fliplr(meanV-stdV));

hold on
h2=patch(poly_xx, poly_std, colStd,'facealpha',alfa,'edgecolor','none');
h1=plot(xx,meanV,varargin{:},'color',colMean);
hAnnotation = get(h2,'Annotation');
hLegendEntry = get(hAnnotation','LegendInformation');
set(hLegendEntry,'IconDisplayStyle','off')
end