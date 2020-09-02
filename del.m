function varargout = del(varargin)
   for i=1:nargin,
       varargin{i}(~any(varargin{i},2),:) = [];
   end
   varargout = varargin;
end