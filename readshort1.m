function [data,count,fid] = readshort(filename)
%-------------------------------------------------------------------------
% USAGE  [data,count,fid] = readshort('filename');
% Optional Input -
%                filename - filename of the file to be read (char. string);
%                           Note that it should be given within single quotes.
% The file read is stored into the array 'data' as a column vector.
%-------------------------------------------------------------------------

%-------------------------------------------------------------------------
% Author       : P.S.Murthy, Speech & Vision Lab, Dept. of CSE, IITM.
% Date         :  2 Mar 1996
% Last revised : 15 Oct 1998
% Comments     :
% Other functions called :
% Other MatLab functions called : 'input', 'fopen', 'fread'.
%-------------------------------------------------------------------------
if nargin == 0,
	filename = input('Enter binary input filename:   ','s');
end

fid = fopen(filename,'r');
if fid == -1
	disp('   ERROR: File not found. Check path or filename !!');
else
	[data,count] = fread(fid,'short');

	% CONVERT TO COLUMN VECTOR.
	data = data(:);
end
fclose(fid);
%-------------------------------------------------------------------------
% LOG OF CHANGES
% Just added the header containing the author info and dates.
% The additional command of converting 'data' t a column vector has been added.
% The error display is added so that if file not found. the message is given.
% 15 Oct 1998: Now the filename can also be directly passed as argument.
