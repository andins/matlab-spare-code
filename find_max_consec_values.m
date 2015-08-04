function [max_consec, longest_interval] = find_max_consec_values(serie, val)

z_serie = serie ~= val;
sizeS = size(z_serie);
if sizeS(2)>sizeS(1)
    z_serie = cat(2, 1, z_serie);
    z_serie = cat(2, z_serie, 1);
elseif sizeS(1)>sizeS(2)
    z_serie = cat(1, 1, z_serie);
    z_serie = cat(1, z_serie, 1);
else
    error('serie must be a column or row vector!')
end
% find the indices of all non interesting values
idxs = find(z_serie);
% take the difference between contiguous indices
idx_diff = diff(idxs);
[max_consec idx_max] = max(idx_diff);
max_consec = max_consec - 1;
longest_interval = idxs(idx_max+1)-max_consec:idxs(idx_max+1)-1;

% iterative method
% 
% max_consec = 0;
% i = 1;
% while i < length(serie)
%     if serie(i)==val
%         max_consec_tmp = 1;
%         while serie(i+1)==val
%             max_consec_tmp = max_consec_tmp + 1;
%             if i < length(serie)-1
%                 i = i + 1;
%             else
%                 if serie(i+1)==val
%                     max_consec_tmp = max_consec_tmp + 1;
%                 end
%                 return
%             end
%         end
%         if max_consec_tmp > max_consec
%             max_consec = max_consec_tmp;
%         end
%     end
%     i = i + 1;
% end