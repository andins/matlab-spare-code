% Andrea Insabato 15/01/15
% False Discovery Rate - Benjamini-Hochberg method
%
% rejectedH0s = FDR_benjHoch(pvals, q, corr, fig)
%
% Controls the False Discovery Rate of a set of tests with p-values pvals to a level q with the
% Benjamini-Hochberg procedure.
% pvals is a vector of p-values for each null hypothesis tested.
% q is the desired threshold.
% corr is an optional string ('positive' or 'arbitrary') indicating if there is correlation between tests (see below).
% fig is an optional boolean determining whether to plot pvalues and criterias.
% It returns a vector rejectedH0s with the indices of the rejected null hypothesis
% corresponding to the tests in pvals. In case no test is significant an
% empty matrix is returned.
%
%
% Correlation between tests:
% Benjamini and Yakutieli (2001) proved that under positive correlation BH procedure
% controls FDR to a given level q.
% Under arbitrary correlations a modification of the procedure still controls FDR to
% the level q but it is more conservative.
% A resampling method can be used instead.
%
% TODO: implement the resampling method

function rejectedH0s = FDR_benjHoch(pvals, q, corr, fig)

if nargin < 3
	c = 1; 
else
	switch corr
	case 'positive'
		c = 1;
	case 'arbitrary'
		c = cumsum(1./[1:length(pvals)])
	otherwise
		error('FDR_benjHoch: corr can be either ''positive'' or ''arbitrary''')
	end
end

if nargin < 4
	fig = false;
end

[ordered_pval, pvalIdx] = sort(pvals,'ascend');
criterias = q * [1:length(pvals)] ./ (length(pvals)*c);
% if pvals is column vector transpose criterias to avoid problems
if size(pvals,2)==1
   criterias = criterias';
end
num_rejectedH0s = find(ordered_pval <= criterias,1,'last');  % reject ordered H0s from 1 to this index
rejectedH0s = pvalIdx(1:num_rejectedH0s);

if fig
	figure
	plot(ordered_pval, '-k', 'linewidth', 3)
	hold on
	plot(criterias, '--r', 'linewidth', 2)
	set(gca, 'xticklabel', pvalIdx, 'fontsize', 16)
	xlabel('indexes of ordered p-values')
	ylabel('ordered p-values')
	legend({'p-values'; 'criterias'})
	set(gca, 'xtick', [1:length(pvals)], 'xticklabel', pvalIdx, 'fontsize', 16)
end
